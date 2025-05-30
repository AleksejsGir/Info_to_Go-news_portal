# Generated by Django 5.1.6 on 2025-03-31 21:23

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('news', '0011_alter_favorite_unique_together_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterField(
            model_name='favorite',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_favorites', to=settings.AUTH_USER_MODEL, verbose_name='Пользователь'),
        ),
        migrations.AlterField(
            model_name='like',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_likes', to=settings.AUTH_USER_MODEL, verbose_name='Пользователь'),
        ),
        migrations.AlterUniqueTogether(
            name='favorite',
            unique_together={('article', 'user')},
        ),
        migrations.AlterUniqueTogether(
            name='like',
            unique_together={('article', 'user')},
        ),
    ]
