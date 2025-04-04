# urls.py (корневой)
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from news import views

urlpatterns = [
                  path('admin/', admin.site.urls),
                  path('', views.MainView.as_view(), name='index'),
                  path('about/', views.AboutView.as_view(), name='about'),
                  path('news/', include('news.urls')),
                  path('users/', include('users.urls')),  # Добавляем эту строку

                  # Остальные маршруты allauth
                  path('accounts/', include('allauth.urls')),
              ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

if settings.DEBUG:
    import debug_toolbar

    urlpatterns = [
                      path('__debug__/', include(debug_toolbar.urls)),
                  ] + urlpatterns