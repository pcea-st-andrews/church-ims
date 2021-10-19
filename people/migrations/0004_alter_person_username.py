# Generated by Django 3.2.7 on 2021-10-19 07:13

import django.contrib.auth.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        (
            "people",
            "0003_interpersonalrelationship_people_unique_interpersonalrelationship",
        ),
    ]

    operations = [
        migrations.AlterField(
            model_name="person",
            name="username",
            field=models.CharField(
                error_messages={
                    "unique": "A person with that username already exists."
                },
                max_length=50,
                unique=True,
                validators=[django.contrib.auth.validators.UnicodeUsernameValidator()],
            ),
        ),
    ]
