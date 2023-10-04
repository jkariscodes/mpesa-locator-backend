from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer, GeometryField

from .models import MpesaLocations


class MpesaLocationsSerializer(GeoFeatureModelSerializer):
    geom = GeometryField()

    class Meta:
        model = MpesaLocations
        geo_field = "geom"
        fields = ["formatted_field", "input_stri", "county"]
        read_only_fields = ["id", "latitude", "longitude"]
