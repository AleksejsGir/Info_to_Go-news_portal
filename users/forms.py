# users/forms.py
from django import forms
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from allauth.account.forms import SignupForm, LoginForm, ResetPasswordForm, EmailAddress
from .models import Profile

User = get_user_model()


class ResendVerificationEmailForm(forms.Form):
    """
    Форма для повторной отправки письма подтверждения email

    Ключевые особенности:
    - Валидация существования незавершенной регистрации
    - Стилизация под Bootstrap
    - Информативные сообщения об ошибках
    """
    email = forms.EmailField(
        label='Email для подтверждения',
        widget=forms.EmailInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите email для повторной отправки',
            'autofocus': 'autofocus'
        })
    )

    def clean_email(self):
        """
        Проверка корректности email и статуса подтверждения
        """
        email = self.cleaned_data.get('email')

        # Проверяем существование email-адреса в системе
        try:
            email_address = EmailAddress.objects.get(email=email)

            # Проверяем, что email еще не подтвержден
            if email_address.verified:
                raise forms.ValidationError(
                    "Указанный email уже подтвержден. Вы можете войти в систему."
                )

        except EmailAddress.DoesNotExist:
            raise forms.ValidationError(
                "Пользователь с указанным email не найден. Проверьте правильность ввода."
            )

        return email


class CustomResetPasswordForm(ResetPasswordForm):
    """
    Кастомная форма сброса пароля с улучшенной стилизацией и валидацией
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        # Настройка поля email
        self.fields['email'].widget = forms.EmailInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите ваш зарегистрированный email',
            'autofocus': 'autofocus'
        })
        self.fields['email'].label = 'Email для восстановления'

    def clean_email(self):
        """
        Валидация email с информативными сообщениями
        """
        email = self.cleaned_data['email']

        # Находим пользователей с указанным email
        self.users = User.objects.filter(email=email)

        # Проверяем существование email в базе
        if not self.users.exists():
            raise forms.ValidationError(
                "Пользователь с таким email не зарегистрирован. "
                "Проверьте правильность введенного адреса."
            )

        return email


class CustomAuthenticationForm(LoginForm):  # Наследуемся от LoginForm allauth
    """
    Кастомная форма аутентификации с расширенным функционалом.
    Поддерживает вход по email или логину с улучшенными стилями Bootstrap 5.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        # Кастомизация поля логина
        self.fields['login'].widget = forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите email или имя пользователя',
            'autofocus': 'autofocus'  # Устанавливаем фокус на это поле при загрузке
        })
        self.fields['login'].label = 'Логин или Email'

        # Кастомизация поля пароля
        self.fields['password'].widget = forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Введите пароль',
            'autocomplete': 'current-password'  # Улучшаем автозаполнение
        })
        self.fields['password'].label = 'Пароль'

        # Добавляем возможность запоминания пользователя
        self.fields['remember'].widget = forms.CheckboxInput(attrs={
            'class': 'form-check-input'
        })


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
        # user.username = user.email  # Используем email как username
        user.save()
        return user


class ProfileUpdateForm(forms.ModelForm):
    """
    Форма для обновления профиля пользователя.
    Позволяет загружать аватар и редактировать информацию о себе.
    """
    class Meta:
        model = Profile
        fields = ['avatar', 'bio']
        widgets = {
            'avatar': forms.FileInput(attrs={
                'class': 'form-control',
            }),
            'bio': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 4,
                'placeholder': 'Расскажите о себе...'
            }),
        }


class UserUpdateForm(forms.ModelForm):
    """
    Форма для обновления основной информации пользователя.
    """
    class Meta:
        model = User
        fields = ['first_name', 'last_name']
        widgets = {
            'first_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Введите ваше имя'
            }),
            'last_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Введите вашу фамилию'
            }),
        }