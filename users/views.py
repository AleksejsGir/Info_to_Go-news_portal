# # users/views.py
# from django.shortcuts import redirect
# from django.urls import reverse_lazy
#
# # Импортируем все необходимые классы allauth
# from allauth.account.views import (
#     LoginView,
#     SignupView,
#     ConfirmEmailView,
#     PasswordResetView,
#     PasswordResetDoneView,
#     PasswordResetFromKeyView,
#     PasswordResetFromKeyDoneView,
#     EmailVerificationSentView,
#     LogoutView
# )
#
# # Кастомные представления для Allauth
# class CustomLoginView(LoginView):
#     """
#     Кастомное представление для входа в систему через allauth.
#     """
#     template_name = 'account/login.html'
#
# class CustomSignupView(SignupView):
#     """
#     Кастомное представление для регистрации через allauth.
#     """
#     template_name = 'account/signup.html'
#
# class CustomLogoutView(LogoutView):
#     """
#     Кастомное представление для выхода из системы.
#     """
#     # Используем стандартный шаблон allauth
#
# class CustomConfirmEmailView(ConfirmEmailView):
#     """
#     Кастомное представление для обработки подтверждения email.
#     """
#     template_name = 'account/confirm_email.html'
#
#     def get(self, *args, **kwargs):
#         response = super().get(*args, **kwargs)
#         # Проверяем, есть ли подтвержденные email у пользователя
#         if hasattr(self, 'object') and self.object.emailaddress_set.filter(verified=True).exists():
#             return redirect('account_login')  # Редирект на страницу входа
#         return response  # Возвращаем стандартный ответ
#
# class CustomPasswordResetView(PasswordResetView):
#     """
#     Кастомное представление для запроса сброса пароля.
#     """
#     template_name = 'account/password_reset.html'
#
# class CustomPasswordResetDoneView(PasswordResetDoneView):
#     """
#     Кастомное представление для подтверждения запроса сброса пароля.
#     """
#     template_name = 'account/password_reset_done.html'
#
# class CustomPasswordResetFromKeyView(PasswordResetFromKeyView):
#     """
#     Кастомное представление для ввода нового пароля.
#     """
#     template_name = 'account/password_reset_from_key.html'
#
# class CustomPasswordResetFromKeyDoneView(PasswordResetFromKeyDoneView):
#     """
#     Кастомное представление для подтверждения сброса пароля.
#     """
#     template_name = 'account/password_reset_from_key_done.html'
#
# class CustomEmailVerificationSentView(EmailVerificationSentView):
#     """
#     Кастомное представление страницы после отправки ссылки подтверждения.
#     """
#     template_name = 'account/verification_sent.html'