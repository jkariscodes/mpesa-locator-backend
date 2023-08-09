from rest_framework.routers import DefaultRouter

from .views import MpesaLocationViewSet

router = DefaultRouter()

router.register(prefix="api/v1/mpesa", viewset=MpesaLocationViewSet, basename="mpesa")

urlpatterns = router.urls
