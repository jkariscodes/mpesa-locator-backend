from django.contrib import admin
from leaflet.admin import LeafletGeoAdmin
from .models import MpesaLocations


class MpesaLocationsAdmin(LeafletGeoAdmin):
    list_display = ("formatted_field", "input_stri", "county")


admin.site.register(MpesaLocations, MpesaLocationsAdmin)
