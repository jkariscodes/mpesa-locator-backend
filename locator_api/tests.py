import pytest
from django.urls import reverse


@pytest.fixture
def api_client():
    from rest_framework.test import APIClient

    return APIClient()


@pytest.mark.django_db
def test_api_root(client):
    url = reverse("api-root")
    response = client.get(url)
    assert response.status_code == 200


@pytest.mark.django_db
def test_unauthorized_request(api_client):
    url = reverse("mpesa-locations-list")
    response = api_client.get(url)
    assert response.status_code == 403
