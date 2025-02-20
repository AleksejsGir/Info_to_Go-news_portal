from django.contrib import admin
from django.template.defaultfilters import title
from django.utils.html import format_html
from django.contrib.admin import SimpleListFilter
from parso.python.tree import Class

from .models import Article, Category, Tag


admin.site.site_header = "Администрирование портала Info to Go"
admin.site.site_title = "Админка"
admin.site.index_title = "Привет, администратор!"

class ArticleSpider(SimpleListFilter):
    title = 'аисты'
    parameter_name = 'is_active'

    def lookups(self, request, model_admin):
        return (
            ('active', 'да'),
            ('inactive', 'Неактивные'),
        )
    def queryset(self, request, queryset):
        if self.value() == 'active':
            return queryset.filter(is_active=True)
        if self.value() == 'inactive':
            return queryset.filter(is_active=False)



class TagInline(admin.TabularInline):
    model = Article.tags.through
    extra = 1


class ArticleAdmin(admin.ModelAdmin):
    # list_display отображает поля в таблице
    list_display = ('pk', 'title', 'category', 'publication_date', 'views', 'colored_status')
    # list_filter позволяет фильтровать по полям
    list_filter = ('category',)
    # search_fields позволяет искать по полям
    search_fields = ('title', 'content')
    # actions позволяет выполнять действия над выбранными записями
    actions = ('make_inactive', 'make_active')
    # fields позволяет выбирать поля для редактирования (не fieldsets)
    # fields = ('title', 'category', 'content', 'tags', 'is_active')


    list_per_page = 15 # количество записей на странице
    list_display_links = ('title',) # поля, которые являются ссылками
    ordering = ('-views',) # сортировка по умолчанию

    # fieldsets позволяет выбирать группы полей (не работает с fields)
    fieldsets = (
        ('Главная информация', {'fields': ('title', 'content')}),
        ('Дополнительные параметры', {'fields': ('category', 'tags', 'is_active')}),
    )

    # inlines позволяет добавлять дополнительные поля
    inlines = [TagInline]

    def get_queryset(self, request):
        return Article.all_objects.get_queryset()

    @admin.display(description='Пауки внутри')
    def has_spiders(self, article):
        return 'Да' if 'пауки' in article.content else 'Нет'

    @admin.action(description='Сделать неактивными выбранные статьи')
    def make_inactive(modeladmin, request, queryset):
        queryset.update(is_active=False)

    @admin.action(description='Сделать активными выбранные статьи')
    def make_active(modeladmin, request, queryset):
        queryset.update(is_active=True)

    @admin.action(description='Отметить статьи как проверенные')
    def set_checked(self, request, queryset):
        updated = queryset.update(status=Article.Status.CHECKED)
        self.message_user(request, f'{updated} статей было отмечено как проверенные')

    @admin.action(description='Отметить статьи как не проверенные')
    def set_unchecked(self, request, queryset):
        updated = queryset.update(status=Article.Status.UNCHECKED)
        self.message_user(request, f'{updated} статей было отмечено как не проверенные', 'warning')


admin.site.register(Category)
admin.site.register(Tag)
