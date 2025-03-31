# urls.py (корневой)
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from news import views
# from users.views import (
#     CustomLoginView, CustomSignupView, CustomConfirmEmailView,
#     CustomPasswordResetView, CustomPasswordResetDoneView,
#     CustomPasswordResetFromKeyView, CustomPasswordResetFromKeyDoneView,
#     CustomEmailVerificationSentView, CustomLogoutView
# )

urlpatterns = [
                  path('admin/', admin.site.urls),
                  path('', views.MainView.as_view(), name='index'),
                  path('about/', views.AboutView.as_view(), name='about'),
                  path('news/', include('news.urls')),
                  # Удаляем path('users/', include('users.urls')), так как переходим полностью на allauth

                  # # Кастомные маршруты allauth
                  # path('accounts/login/', CustomLoginView.as_view(), name='account_login'),
                  # path('accounts/signup/', CustomSignupView.as_view(), name='account_signup'),
                  # path('accounts/logout/', CustomLogoutView.as_view(), name='account_logout'),
                  # path('accounts/confirm-email/<str:key>/', CustomConfirmEmailView.as_view(),
                  #      name='account_confirm_email'),
                  # path('accounts/confirm-email/', CustomEmailVerificationSentView.as_view(),
                  #      name='account_email_verification_sent'),
                  # path('accounts/password/reset/', CustomPasswordResetView.as_view(), name='account_reset_password'),
                  # path('accounts/password/reset/done/', CustomPasswordResetDoneView.as_view(),
                  #      name='account_reset_password_done'),
                  # path('accounts/password/reset/key/<str:uidb36>-<str:key>/', CustomPasswordResetFromKeyView.as_view(),
                  #      name='account_reset_password_from_key'),
                  # path('accounts/password/reset/key/done/', CustomPasswordResetFromKeyDoneView.as_view(),
                  #      name='account_reset_password_from_key_done'),

                  # Остальные маршруты allauth (для функциональности, которая не переопределена выше)
                  path('accounts/', include('allauth.urls')),
              ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
    ] + urlpatterns