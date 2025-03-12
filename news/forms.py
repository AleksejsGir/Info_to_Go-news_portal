# news/forms.py
from django import forms
from .models import Article, Category, Tag

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