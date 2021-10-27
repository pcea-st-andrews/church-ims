from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.views.generic.dates import DayArchiveView, TodayArchiveView

from records.models import TemperatureRecord


class TemperatureRecordDayArchiveView(
    LoginRequiredMixin, UserPassesTestMixin, DayArchiveView
):
    queryset = TemperatureRecord.objects.all()
    date_field = "created_at"
    context_object_name = "body_temperature"
    template_name = "reports/body_temperature_list.html"

    def test_func(self):
        if self.request.user.is_staff:
            return True
        return False


class TemperatureRecordTodayArchiveView(
    LoginRequiredMixin, UserPassesTestMixin, TodayArchiveView
):
    queryset = TemperatureRecord.objects.all()
    date_field = "created_at"
    context_object_name = "body_temperature"
    template_name = "reports/body_temperature_list.html"

    def test_func(self):
        if self.request.user.is_staff:
            return True
        return False
