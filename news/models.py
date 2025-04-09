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

    def get_favorites_for_user(self, user):
        """Получает ID статей, добавленных в избранное указанным пользователем"""
        if not user or not user.is_authenticated:
            return []
        return self.filter(user=user).values_list('article_id', flat=True)


class LikeManager(models.Manager):
    """Менеджер для модели Like"""

    def get_likes_for_user(self, user):
        """Получает ID статей, лайкнутых указанным пользователем"""
        if not user or not user.is_authenticated:
            return []
        return self.filter(user=user).values_list('article_id', flat=True)


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
    name = models.CharField(unique=True, verbose_name='Тег')

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

    def toggle_like(self, user):
        """Переключает состояние лайка для данного пользователя"""
        if not user or not user.is_authenticated:
            return False, self.likes.count()

        like, created = self.likes.get_or_create(user=user)
        if not created:
            like.delete()
        return created, self.likes.count()

    def toggle_favorite(self, user):
        """Переключает состояние избранного для данного пользователя"""
        if not user or not user.is_authenticated:
            return False, self.favorites.count()

        favorite, created = self.favorites.get_or_create(user=user)
        if not created:
            favorite.delete()
        return created, self.favorites.count()

    def increment_views(self):
        """Увеличивает счетчик просмотров на 1"""
        self.views += 1
        self.save(update_fields=['views'])

    def is_liked_by_user(self, user):
        """Проверяет, лайкнута ли статья пользователем"""
        if not user or not user.is_authenticated:
            return False
        return self.likes.filter(user=user).exists()

    def is_favorite_for_user(self, user):
        """Проверяет, добавлена ли статья в избранное пользователем"""
        if not user or not user.is_authenticated:
            return False
        return self.favorites.filter(user=user).exists()

    class Meta:
        db_table = 'Articles'
        verbose_name = 'Статья'
        verbose_name_plural = 'Статьи'
        ordering = ['-publication_date']  # Добавлено упорядочивание по умолчанию

    def __str__(self):
        return self.title


class Like(models.Model):
    """
    Модель для хранения лайков к статьям.
    Лайки доступны только авторизованным пользователям.
    """
    article = models.ForeignKey(
        Article,
        on_delete=models.CASCADE,
        related_name='likes',
        verbose_name='Статья'
    )
    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='user_likes',
        verbose_name='Пользователь'

    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Время лайка')

    objects = LikeManager()

    class Meta:
        db_table = 'Likes'
        verbose_name = 'Лайк'
        verbose_name_plural = 'Лайки'
        unique_together = ('article', 'user')  # Каждый пользователь может лайкнуть статью только один раз

    def __str__(self):
        return f"Лайк статьи {self.article.title} от {self.user.username}"


class Favorite(models.Model):
    """
    Модель для хранения избранных статей.
    Добавление в избранное доступно только авторизованным пользователям.
    """
    article = models.ForeignKey(
        Article,
        on_delete=models.CASCADE,
        related_name='favorites',
        verbose_name='Статья'
    )
    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='user_favorites',
        verbose_name='Пользователь'


    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Время добавления')

    objects = FavoriteManager()

    class Meta:
        db_table = 'Favorites'
        verbose_name = 'Избранное'
        verbose_name_plural = 'Избранное'
        unique_together = ('article', 'user')  # Каждый пользователь может добавить статью в избранное только один раз

    def __str__(self):
        return f"Избранная статья {self.article.title} пользователя {self.user.username}"


class Comment(models.Model):
    article = models.ForeignKey(
        Article,
        on_delete=models.CASCADE,
        related_name='comments',
        verbose_name='Статья'
    )
    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='user_comments',
        null=True,
        blank=True,
        verbose_name='Пользователь'
    )
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='replies',
        verbose_name='Родительский комментарий'
    )
    content = models.TextField(verbose_name='Комментарий')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Создан')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='Обновлен')

    # Методы для работы с лайками комментариев
    def toggle_like(self, user, is_like=True):
        """Переключает состояние лайка/дизлайка для данного пользователя"""
        if not user or not user.is_authenticated:
            return False, self.get_likes_count(), self.get_dislikes_count()

        # Проверяем, есть ли уже лайк/дизлайк от этого пользователя
        existing = CommentLike.objects.filter(comment=self, user=user).first()

        if existing:
            # Если уже стоит такая же оценка - удаляем её (снимаем)
            if existing.is_like == is_like:
                existing.delete()
                return False, self.get_likes_count(), self.get_dislikes_count()
            else:
                # Если стоит противоположная - меняем её
                existing.is_like = is_like
                existing.save()
                return True, self.get_likes_count(), self.get_dislikes_count()
        else:
            # Если оценки нет - создаём новую
            CommentLike.objects.create(comment=self, user=user, is_like=is_like)
            return True, self.get_likes_count(), self.get_dislikes_count()

    def get_likes_count(self):
        """Возвращает количество лайков комментария"""
        return self.comment_likes.filter(is_like=True).count()

    def get_dislikes_count(self):
        """Возвращает количество дизлайков комментария"""
        return self.comment_likes.filter(is_like=False).count()

    def is_liked_by_user(self, user):
        """Проверяет, лайкнут ли комментарий пользователем"""
        if not user or not user.is_authenticated:
            return False
        return CommentLike.objects.filter(
            comment=self, user=user, is_like=True
        ).exists()

    def is_disliked_by_user(self, user):
        """Проверяет, дизлайкнут ли комментарий пользователем"""
        if not user or not user.is_authenticated:
            return False
        return CommentLike.objects.filter(
            comment=self, user=user, is_like=False
        ).exists()

    class Meta:
        db_table = 'Comments'
        verbose_name = 'Комментарий'
        verbose_name_plural = 'Комментарии'
        ordering = ['-created_at']  # Новые комментарии сверху

    def __str__(self):
        return f"Комментарий от {self.user.username if self.user else 'Анонима'} к статье '{self.article.title}'"


class CommentLike(models.Model):
    """
    Модель для хранения лайков/дизлайков к комментариям.
    """
    comment = models.ForeignKey(
        Comment,
        on_delete=models.CASCADE,
        related_name='comment_likes',
        verbose_name='Комментарий'
    )
    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='user_comment_likes',
        verbose_name='Пользователь'
    )
    is_like = models.BooleanField(
        default=True,
        verbose_name='Лайк/Дизлайк',
        help_text='True для лайка, False для дизлайка'
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Время оценки')

    class Meta:
        db_table = 'CommentLikes'
        verbose_name = 'Оценка комментария'
        verbose_name_plural = 'Оценки комментариев'
        unique_together = ('comment', 'user')  # Пользователь может только один раз оценить комментарий

    def __str__(self):
        action = "лайкнул" if self.is_like else "дизлайкнул"
        return f"{self.user.username} {action} комментарий {self.comment.id}"