# news/forms.py
from django import forms
from .models import Article, Category


class ArticleForm(forms.ModelForm):
    """
    Форма для создания новой статьи с использованием ModelForm
    Преимущества ModelForm:
    - Автоматическое связывание с моделью Article
    - Встроенная валидация полей
    - Упрощенное сохранение данных
    """

    class Meta:
        model = Article
        fields = ['title', 'content', 'category']

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