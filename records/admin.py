from django.contrib import admin

from .models import TemperatureRecord


@admin.register(TemperatureRecord)
class TemperatureRecordAdmin(admin.ModelAdmin):
    list_display = ("person", "body_temperature", "created_at")
    list_filter = ("created_at",)
    ordering = ("-created_at",)
