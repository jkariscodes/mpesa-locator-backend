import uuid
import pytest
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework.authtoken.models import Token

User = get_user_model()


@pytest.mark.django_db
def test_user_create():
    User.objects.create_user("jkariuki", "jkariuki@email.com", "JKariuki123")
    assert User.objects.count() == 1
