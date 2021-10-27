from django import urls
from django.urls import path

from . import views

app_name = "reports"
urlpatterns = [
    path(
        "temperature/<int:year>/<str:month>/<int:day>/",
        views.TemperatureRecordDayArchiveView.as_view(),
        name="body_temperature_day_archive",
    ),
    path(
        "temperature/today/",
        views.TemperatureRecordTodayArchiveView.as_view(),
        name="body_temperature_today",
    ),
]
