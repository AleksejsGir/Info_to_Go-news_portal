# users/utils.py
from .models import UserActivity


def record_user_activity(user, action_type, description="", related_object_id=None):
    """
    Записывает действие пользователя в историю активностей.

    Args:
        user: Пользователь, совершивший действие
        action_type: Тип действия (из списка ACTION_TYPES модели UserActivity)
        description: Описание действия (опционально)
        related_object_id: ID связанного объекта (опционально)

    Returns:
        Созданный объект UserActivity
    """
    if user and user.is_authenticated:
        activity = UserActivity(
            user=user,
            action_type=action_type,
            description=description,
            related_object_id=related_object_id
        )
        activity.save()
        return activity
    return None