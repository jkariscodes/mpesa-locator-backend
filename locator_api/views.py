from rest_framework import viewsets, permissions
from .models import MpesaLocations
from .serializers import MpesaLocationsSerializer


class MpesaLocationViewSet(viewsets.ModelViewSet):
    queryset = MpesaLocations.objects.all()
    serializer_class = MpesaLocationsSerializer
    permission_classes = [permissions.IsAuthenticated]
