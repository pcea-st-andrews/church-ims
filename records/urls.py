from django.urls import path

from . import views

app_name = "records"
urlpatterns = [
    path(
        "temperature/<slug:username>/add/",
        views.TemperatureRecordCreateView.as_view(),
        name="body_temperature_create",
    ),
    path(
        "temperature/<slug:username>/",
        views.TemperatureRecordByPersonListView.as_view(),
        name="body_temperature_by_person_list",
    ),
]
