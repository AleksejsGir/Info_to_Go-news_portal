# Generated by Django 5.1.6 on 2025-03-12 20:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('news', '0008_favorite'),
    ]

    operations = [
        migrations.AddField(
            model_name='article',
            name='image',
            field=models.ImageField(blank=True, null=True, upload_to='articles/%Y/%m/%d/', verbose_name='Изображение'),
        ),
    ]
