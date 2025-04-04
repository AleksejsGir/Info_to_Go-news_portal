# news/templatetags/user_extras.py
from django import template

register = template.Library()

@register.filter(name='has_group')
def has_group(user, group_name):
    """
    Возвращает True, если пользователь аутентифицирован и состоит в группе с именем group_name.
    """
    if not user.is_authenticated:
        return False
    return user.groups.filter(name=group_name).exists()

@register.filter(name='can_edit')
def can_edit(article, user):
    """
    Проверяет, имеет ли пользователь право редактировать статью.
    Условие:
      - пользователь аутентифицирован, и
      - либо является суперпользователем,
      - либо состоит в группе "Moderator",
      - либо является автором статьи.
    """
    if not user.is_authenticated:
        return False
    if user.is_superuser or user.groups.filter(name="Moderator").exists():
        return True
    return article.author == user