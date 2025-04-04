# news/admin.py
from django.contrib import admin
from django.utils.html import format_html

from .models import Article, Category, Tag


admin.site.site_header = "Админка Info to Go"
admin.site.site_title = "Админка"
admin.site.index_title = "Привет админ! Не сломай ничего."


class TagInline(admin.TabularInline):
    """Встроенная форма для тегов статьи."""
    model = Article.tags.through
    extra = 1


@admin.register(Article)
class ArticleAdmin(admin.ModelAdmin):
    """
    Административный интерфейс для управления статьями.
    Позволяет просматривать, фильтровать, создавать и редактировать статьи.
    """
    # list_display отображает поля в таблице
    list_display = ('pk', 'title', 'category', 'publication_date', 'views', 'status_display', 'is_active_display', 'author')
    # list_display_links позволяет указать в качестве ссылок на объект другие поля
    list_display_links = ('pk', 'title')
    # list_filter позволяет фильтровать по полям
    list_filter = ('category', 'is_active', 'status', 'author')
    # сортировка, возможна по нескольким полям, по возрастанию или по убыванию
    ordering = ('category', '-is_active')
    # search_fields позволяет искать по полям
    search_fields = ('title', 'content')
    # actions позволяет выполнять действия над выбранными записями
    actions = ('make_inactive', 'make_active', 'set_checked', 'set_unchecked')
    actions_on_bottom = True  # Показывать действия также внизу страницы
    list_per_page = 20
    # включение иерархического отображения по дате
    date_hierarchy = 'publication_date'
    # перенос кнопок сохранения в верхнюю часть формы
    save_on_top = True

    # fieldsets позволяет выбирать группы полей (не работает с fields)
    fieldsets = (
        ('Главная информация', {'fields': ('title', 'content', 'author')}),
        ('Настройки фильтрации', {'fields': ('category', 'is_active', 'status')}),
        ('Доп. инфо', {'fields': ('views', 'slug')}),
    )

    # inlines позволяет добавлять дополнительные поля
    inlines = [TagInline]

    readonly_fields = ('views', 'slug')

    def get_queryset(self, request):
        """Возвращает все объекты, включая неактивные, для отображения в админке."""
        return Article.all_objects.get_queryset()

    @admin.display(description='Статус')  # Убрано boolean=True
    def status_display(self, obj):
        """Красивое отображение статуса с цветовой индикацией."""
        if obj.status:
            return format_html('<span style="color: green;">✓ Проверено</span>')
        return format_html('<span style="color: orange;">⚠ Не проверено</span>')

    @admin.display(description='Активна')  # Убрано boolean=True
    def is_active_display(self, obj):
        """Красивое отображение активности с цветовой индикацией."""
        if obj.is_active:
            return format_html('<span style="color: green;">✓ Да</span>')
        return format_html('<span style="color: red;">✗ Нет</span>')

    @admin.action(description='Сделать неактивными выбранные статьи')
    def make_inactive(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(request, f'{updated} статей было отмечено как неактивные')

    @admin.action(description='Сделать активными выбранные статьи')
    def make_active(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(request, f'{updated} статей было отмечено как активные')

    @admin.action(description='Отметить статьи как проверенные')
    def set_checked(self, request, queryset):
        updated = queryset.update(status=Article.Status.CHECKED)
        self.message_user(request, f'{updated} статей было отмечено как проверенные')

    @admin.action(description='Отметить статьи как не проверенные')
    def set_unchecked(self, request, queryset):
        updated = queryset.update(status=Article.Status.UNCHECKED)
        self.message_user(request, f'{updated} статей было отмечено как не проверенные', 'warning')


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    """Административный интерфейс для управления категориями."""
    list_display = ('name',)
    search_fields = ('name',)


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    """Административный интерфейс для управления тегами."""
    list_display = ('name',)
    search_fields = ('name',)