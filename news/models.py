import unidecode
import time
from django.db import models
from django.utils.text import slugify
from django.db.models import Q
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _

class ArticleQuerySet(models.QuerySet):
    """Расширенный QuerySet для статей с дополнительными методами запросов"""

    def with_related(self):
        """Оптимизированный запрос с предзагрузкой связанных объектов"""
        return self.select_related('category').prefetch_related('tags').order_by(
            '-publication_date')  # Добавлена явная сортировка

    def search(self, query):
        """Поиск по заголовку и содержанию"""
        if not query:
            return self.none()
        return self.filter(
            Q(title__icontains=query) | Q(content__icontains=query)
        )

    def by_category(self, category):
        """Фильтрация по категории"""
        return self.filter(category=category)

    def by_tag(self, tag):
        """Фильтрация по тегу"""
        return self.filter(tags=tag)

    def sort_by(self, field, order='desc'):
        """Сортировка по заданному полю"""
        valid_fields = {'publication_date', 'views'}
        if field not in valid_fields:
            field = 'publication_date'

        if order == 'asc':
            return self.order_by(field)
        return self.order_by(f'-{field}')


class ArticleManager(models.Manager):
    """Менеджер для модели Article с дополнительными методами"""

    def get_queryset(self):
        """Возвращает QuerySet с дополнительными методами"""
        return ArticleQuerySet(self.model, using=self._db).filter(is_active=True)

    def with_related(self):
        """Оптимизированный запрос с предзагрузкой связанных объектов"""
        return self.get_queryset().with_related()

    def search(self, query):
        """Поиск по заголовку и содержанию"""
        return self.get_queryset().with_related().search(query)

    def by_category(self, category):
        """Фильтрация по категории"""
        return self.get_queryset().with_related().by_category(category)

    def by_tag(self, tag):
        """Фильтрация по тегу"""
        return self.get_queryset().with_related().by_tag(tag)

    def sort_by(self, field, order='desc'):
        """Сортировка по заданному полю"""
        return self.get_queryset().with_related().sort_by(field, order)

    def sorted_by_title(self):
        """Метод отсортированных по заголовку"""
        return self.get_queryset().all().order_by('-title')


class AllArticleManager(models.Manager):
    def get_queryset(self):
        return ArticleQuerySet(self.model, using=self._db)


class FavoriteManager(models.Manager):
    """Менеджер для модели Favorite"""

    def get_favorites_for_ip(self, ip_address):
        """Получает ID статей, добавленных в избранное с заданного IP"""
        return self.filter(ip_address=ip_address).values_list('article_id', flat=True)


class LikeManager(models.Manager):
    """Менеджер для модели Like"""

    def get_likes_for_ip(self, ip_address):
        """Получает ID статей, лайкнутых с заданного IP"""
        return self.filter(ip_address=ip_address).values_list('article_id', flat=True)


class Category(models.Model):
    name = models.CharField(max_length=255, verbose_name='Категория')

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'Categories'
        verbose_name = 'Категория'
        verbose_name_plural = 'Категории'
        ordering = ['name']


class Tag(models.Model):
    name = models.CharField( unique=True, verbose_name='Тег')

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'Tags'
        verbose_name = 'Тег'
        verbose_name_plural = 'Теги'


class Article(models.Model):
    class Status(models.IntegerChoices):
        UNCHECKED = 0, 'не проверено'
        CHECKED = 1, 'проверено'

    title = models.CharField(max_length=255, verbose_name='Заголовок')
    content = models.TextField(verbose_name='Содержание')
    publication_date = models.DateTimeField(auto_now_add=True, verbose_name='Дата публикации')
    views = models.IntegerField(default=0, verbose_name='Просмотры')
    category = models.ForeignKey('Category', on_delete=models.CASCADE, default=1, verbose_name='Категория')
    tags = models.ManyToManyField('Tag', related_name='article', verbose_name='Теги')
    slug = models.SlugField(unique=True, blank=True, verbose_name='Слаг')
    is_active = models.BooleanField(default=True, verbose_name='Активна')

    status = models.BooleanField(default=0,
                                 choices=(map(lambda x: (bool(x[0]), x[1]), Status.choices)),
                                 verbose_name='Проверено')

    image = models.ImageField(
        upload_to='articles/%Y/%m/%d/',
        blank=True,
        null=True,
        verbose_name='Изображение'
    )

    author = models.ForeignKey(
        get_user_model(),
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        default=None,
        verbose_name=_('Автор')
    )

    objects = ArticleManager()
    all_objects = AllArticleManager()

    def save(self, *args, **kwargs):
        # Если slug не установлен - генерируем его
        if not self.slug:
            # Базовый slug из заголовка или 'untitled'
            base = slugify(unidecode.unidecode(self.title)) if self.title else 'untitled'
            # Ограничиваем длину базового slug и добавляем метку времени для уникальности
            max_length = 40  # Оставляем место для timestamp
            base = base[:max_length]
            timestamp = str(int(time.time()))[-6:]  # Берем последние 6 цифр timestamp
            self.slug = f"{base}-{timestamp}"

        # Один вызов save вместо двух
        super().save(*args, **kwargs)

    def toggle_like(self, ip_address):
        """Переключает состояние лайка для данного IP-адреса"""
        like, created = self.likes.get_or_create(ip_address=ip_address)
        if not created:
            like.delete()
        return created, self.likes.count()

    def toggle_favorite(self, ip_address):
        """Переключает состояние избранного для данного IP-адреса"""
        favorite, created = self.favorites.get_or_create(ip_address=ip_address)
        if not created:
            favorite.delete()
        return created, self.favorites.count()

    def increment_views(self):
        """Увеличивает счетчик просмотров на 1"""
        self.views += 1
        self.save(update_fields=['views'])

    def is_liked_by_ip(self, ip_address):
        """Проверяет, лайкнута ли статья с данного IP"""
        return self.likes.filter(ip_address=ip_address).exists()

    def is_favorite_for_ip(self, ip_address):
        """Проверяет, добавлена ли статья в избранное с данного IP"""
        return self.favorites.filter(ip_address=ip_address).exists()

    class Meta:
        db_table = 'Articles'
        verbose_name = 'Статья'
        verbose_name_plural = 'Статьи'
        ordering = ['-publication_date']  # Добавлено упорядочивание по умолчанию

    def __str__(self):
        return self.title


class Like(models.Model):
    """
    Модель для хранения лайков к статьям
    Каждый IP может лайкнуть статью только один раз
    """
    article = models.ForeignKey(
        Article,
        on_delete=models.CASCADE,
        related_name='likes',
        verbose_name='Статья'
    )
    ip_address = models.GenericIPAddressField(verbose_name='IP-адрес')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Время лайка')

    objects = LikeManager()

    class Meta:
        db_table = 'Likes'
        verbose_name = 'Лайк'
        verbose_name_plural = 'Лайки'
        unique_together = ('article', 'ip_address')  # Уникальность лайка

    def __str__(self):
        return f"Лайк статьи {self.article.title}"


class Favorite(models.Model):
    """
    Модель для хранения избранных статей
    Каждый IP может добавить статью в избранное только один раз
    """
    article = models.ForeignKey(
        Article,
        on_delete=models.CASCADE,
        related_name='favorites',
        verbose_name='Статья'
    )
    ip_address = models.GenericIPAddressField(verbose_name='IP-адрес')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Время добавления')

    objects = FavoriteManager()

    class Meta:
        db_table = 'Favorites'
        verbose_name = 'Избранное'
        verbose_name_plural = 'Избранное'
        unique_together = ('article', 'ip_address')  # Уникальность избранного

    def __str__(self):
        return f"Избранная статья {self.article.title}"