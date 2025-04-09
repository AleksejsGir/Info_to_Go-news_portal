# news/forms.py
from django import forms
from .models import Article, Category, Tag, Comment
import json
from django.core.exceptions import ValidationError


class ArticleForm(forms.ModelForm):
    """
    Форма для создания новой статьи с использованием ModelForm
    Преимущества ModelForm:
    - Автоматическое связывание с моделью Article
    - Встроенная валидация полей
    - Упрощенное сохранение данных
    """
    tags = forms.ModelMultipleChoiceField(
        queryset=Tag.objects.all(),
        widget=forms.CheckboxSelectMultiple,
        required=False,
        label='Теги'
    )

    class Meta:
        model = Article
        fields = ['title', 'content', 'category', 'tags', 'image']

        # Настройка виджетов для улучшения пользовательского интерфейса
        widgets = {
            'title': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Введите заголовок статьи'
            }),
            'content': forms.Textarea(attrs={
                'class': 'form-control',
                'placeholder': 'Введите текст статьи',
                'rows': 5
            }),
            'category': forms.Select(attrs={
                'class': 'form-select'
            }),
            'image': forms.ClearableFileInput(attrs={
                'class': 'form-control'
            }),
            'tags': forms.SelectMultiple(attrs={
                'class': 'form-select',
                'multiple': 'multiple'
            })
        }

    def clean_title(self):
        """
        Пользовательская валидация заголовка
        Пример: минимальная длина заголовка
        """
        title = self.cleaned_data['title']
        if len(title) < 5:
            raise forms.ValidationError("Заголовок должен быть не короче 5 символов")
        return title


class ArticleUploadForm(forms.Form):
    """
    Форма для загрузки JSON-файла с новостями
    """
    json_file = forms.FileField(
        label='JSON файл',
        widget=forms.ClearableFileInput(attrs={
            'class': 'form-control',
            'accept': '.json'
        })
    )

    def clean_json_file(self):
        """
        Валидация JSON-файла
        1. Проверяет, что файл является JSON
        2. Проверяет, что JSON содержит список новостей
        3. Проверяет структуру каждой новости
        """
        json_file = self.cleaned_data.get('json_file')

        if not json_file:
            return None

        # Проверяем расширение файла
        if not json_file.name.endswith('.json'):
            raise ValidationError('Файл должен иметь расширение .json')

        # Пытаемся прочитать JSON
        try:
            json_data = json.loads(json_file.read().decode('utf-8'))
            # Возвращаем указатель файла в начало для дальнейшего использования
            json_file.seek(0)

            # Проверяем, что это список
            if not isinstance(json_data, list):
                raise ValidationError('JSON должен содержать список новостей')

            # Преобразуем структуру данных, если они в формате с полем "fields"
            processed_data = []
            articles_with_issues = []

            for idx, article in enumerate(json_data):
                if not isinstance(article, dict):
                    raise ValidationError(f'Новость #{idx + 1} должна быть объектом')

                # Проверяем, есть ли поле "fields" в статье
                if 'fields' in article and isinstance(article['fields'], dict):
                    # Используем данные из поля "fields"
                    article_data = article['fields']
                else:
                    # Используем данные напрямую
                    article_data = article

                # Проверяем обязательные поля, но не вызываем ошибку
                missing_fields = []
                required_fields = ['title', 'content']
                for field in required_fields:
                    if field not in article_data or not article_data[field]:
                        missing_fields.append(field)
                        # Инициализируем пустым значением
                        article_data[field] = ""

                if missing_fields:
                    articles_with_issues.append({
                        'index': len(processed_data),  # Используем новый индекс
                        'missing_fields': missing_fields
                    })

                # Добавляем обработанную статью в новый список
                processed_data.append(article_data)

            # Проверяем теги и категории
            validation_results = self.validate_json_data(processed_data)

            # Сохраняем данные для использования в представлении
            self.json_data = processed_data
            self.validation_results = validation_results
            self.articles_with_issues = articles_with_issues

            return json_file

        except json.JSONDecodeError:
            raise ValidationError('Файл содержит невалидный JSON')

    def validate_json_data(self, json_data):
        """
        Валидирует теги и категории из JSON-данных
        Возвращает словарь с информацией о существующих и новых тегах и категориях
        """
        results = {
            'existing_categories': set(),
            'new_categories': set(),
            'existing_tags': set(),
            'new_tags': set(),
            'valid': True
        }

        # Получаем все существующие категории и теги
        existing_categories = {cat.name.lower(): cat for cat in Category.objects.all()}
        existing_tags = {tag.name.lower(): tag for tag in Tag.objects.all()}

        for article in json_data:
            # Проверяем категорию
            if 'category' in article and article['category']:
                category_name = article['category'].lower()
                if category_name in existing_categories:
                    results['existing_categories'].add(article['category'])
                else:
                    results['new_categories'].add(article['category'])

            # Проверяем теги
            if 'tags' in article and isinstance(article['tags'], list):
                for tag in article['tags']:
                    if tag:
                        tag_name = tag.lower()
                        if tag_name in existing_tags:
                            results['existing_tags'].add(tag)
                        else:
                            results['new_tags'].add(tag)

        return results


class CommentForm(forms.ModelForm):
    """
    Форма для добавления комментариев к статьям
    """
    class Meta:
        model = Comment
        fields = ['content']
        widgets = {
            'content': forms.Textarea(attrs={
                'class': 'form-control',
                'placeholder': 'Напишите комментарий...',
                'rows': 3
            }),
        }
        labels = {
            'content': 'Ваш комментарий'
        }

    def clean_content(self):
        """
        Проверка содержимого комментария
        """
        content = self.cleaned_data['content']
        if len(content) < 2:
            raise forms.ValidationError("Комментарий должен содержать не менее 2 символов")
        return content