# users/forms.py
from django import forms
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from allauth.account.forms import SignupForm, LoginForm

User = get_user_model()

# Оставляем существующие формы для обратной совместимости
class CustomAuthenticationForm(AuthenticationForm):
    """
    Кастомная форма аутентификации с стилями Bootstrap 5.
    Поддерживает вход как по имени пользователя, так и по email.
    """
    username = forms.CharField(
        label='Логин или Email',
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Введите имя пользователя или email'})
    )
    password = forms.CharField(
        label='Пароль',
        widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Введите пароль'})
    )

class RegisterUserForm(UserCreationForm):
    """
    Форма для регистрации новых пользователей.
    Наследуется от UserCreationForm, который предоставляет базовую валидацию паролей.
    """
    email = forms.EmailField(
        label='Email',
        widget=forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Введите email'})
    )

    # Переопределяем поля, чтобы добавить стили Bootstrap
    username = forms.CharField(
        label='Имя пользователя',
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Введите имя пользователя'})
    )

    first_name = forms.CharField(
        label='Имя',
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Введите имя'}),
        required=False
    )

    password1 = forms.CharField(
        label='Пароль',
        widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Введите пароль'})
    )

    password2 = forms.CharField(
        label='Подтверждение пароля',
        widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Повторите пароль'})
    )

    class Meta:
        model = User
        fields = ('username', 'email', 'first_name', 'password1', 'password2')

    def clean_email(self):
        """Проверка email на уникальность"""
        email = self.cleaned_data['email']
        if User.objects.filter(email=email).exists():
            raise ValidationError("Пользователь с таким email уже существует")
        return email

# Добавляем новую форму для django-allauth
class CustomSignupForm(SignupForm):
    """
    Кастомная форма регистрации с дополнительными полями:
    - first_name
    - last_name
    """
    first_name = forms.CharField(
        max_length=30,
        label='Имя',
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите ваше имя'
        })
    )
    last_name = forms.CharField(
        max_length=30,
        label='Фамилия',
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите вашу фамилию'
        })
    )

    def __init__(self, *args, **kwargs):
        """Инициализация формы с кастомизацией полей"""
        super(CustomSignupForm, self).__init__(*args, **kwargs)
        # Стилизация поля email
        self.fields['email'].widget = forms.EmailInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите email'
        })
        # Стилизация поля "Пароль"
        self.fields['password1'].widget = forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите пароль'
        })
        # Стилизация поля "Подтверждение пароля"
        self.fields['password2'].widget = forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Подтвердите пароль'
        })

    def save(self, request):
        """Сохранение пользователя с дополнительными полями"""
        user = super(CustomSignupForm, self).save(request)
        user.first_name = self.cleaned_data['first_name']
        user.last_name = self.cleaned_data['last_name']
        user.username = user.email  # Используем email как username
        user.save()
        return user