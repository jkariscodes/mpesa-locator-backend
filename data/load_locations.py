import os
from django.contrib.gis.utils import LayerMapping
from django.contrib.gis.gdal import DataSource

from locator_api.models import MpesaLocations

locations_mapping = {
    'formatted_field': 'formatted_',
    'latitude': 'latitude',
    'longitude': 'longitude',
    'input_stri': 'input_stri',
    'county': 'COUNTY',
    'geom': 'MULTIPOINT',
}


def run(verbose=True):
    file = os.getcwd() + '/data/mpesa_locations.gpkg'
    ds = DataSource(file)
    mpesalocations_layer = ds[0].name

    # Layer Mappings
    mpesa_layer_mapping = LayerMapping(
        MpesaLocations, file, locations_mapping, layer=mpesalocations_layer
    )
    # Save data
    mpesa_layer_mapping.save(strict=True, verbose=verbose)
