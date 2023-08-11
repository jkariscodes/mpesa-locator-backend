from django.test import SimpleTestCase
from django.urls import reverse, resolve


class PageTests(SimpleTestCase):
    def test_mpesa_endpoint_url(self):
        response = self.client.get("")
        self.assertEqual(response.status_code, 200)
