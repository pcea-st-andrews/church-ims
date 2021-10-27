from django.contrib import admin

from .models import InterpersonalRelationship, Person


class FamilyMembersInline(admin.TabularInline):
    model = InterpersonalRelationship
    fk_name = "person"
    extra = 1


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ("username", "full_name", "age", "created_by")
    list_filter = ("gender", "dob")
    inlines = (FamilyMembersInline,)
    search_fields = ("username", "full_name")
    ordering = ("username",)


@admin.register(InterpersonalRelationship)
class InterpersonalRelationshipAdmin(admin.ModelAdmin):
    list_display = (
        "person",
        "relative",
        "relation",
    )
    ordering = ("person", "relative")
