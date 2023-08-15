from django.contrib.gis.db import models
from django.utils.translation import gettext_lazy as _


class MpesaLocations(models.Model):
    formatted_field = models.CharField(_("Name"), max_length=254)
    latitude = models.FloatField(_("Latitude"))
    longitude = models.FloatField(_("Longitude"))
    input_stri = models.CharField(_("Detailed Name"), max_length=254)
    county = models.CharField(_("County"), max_length=20)
    geom = models.MultiPointField(_("Geometry"))

    class Meta:
        indexes = [
            models.Index(fields=["geom"], name="geom_index")
        ]

    def __str__(self):
        return self.formatted_field
