# users/authentication.py
from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend
from django.db.models import Q

User = get_user_model()

class EmailAuthBackend(ModelBackend):
    """
    Аутентификация через email или username.
    """
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            # Ищем пользователя либо по username, либо по email
            user = User.objects.get(Q(username=username) | Q(email=username))
            if user.check_password(password):
                return user
            return None
        except User.DoesNotExist:
            return None
        except User.MultipleObjectsReturned:
            # Если у нас есть несколько пользователей с одинаковым email
            # (что в идеале не должно происходить), берем первого
            user = User.objects.filter(Q(username=username) | Q(email=username)).first()
            if user.check_password(password):
                return user
            return None