# Generated by Django 3.2.7 on 2021-10-20 08:23

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("people", "0005_person_phone_number"),
    ]

    operations = [
        migrations.AlterField(
            model_name="person",
            name="created_by",
            field=models.ForeignKey(
                help_text="The user who created this record.",
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name="people_creators",
                to=settings.AUTH_USER_MODEL,
            ),
        ),
    ]
