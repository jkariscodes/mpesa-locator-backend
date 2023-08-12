from .base import *

ENV = "development"

SECRET_KEY = env("SECRET_KEY")

DEBUG = env("DEBUG")

ALLOWED_HOSTS = env("ALLOWED_HOSTS").split(" ")

DATABASES = {
    "default": {
        "ENGINE": env("ENGINE"),
        "NAME": env("DB_NAME"),
        "USER": env("DB_USER"),
        "PASSWORD": env("DB_PASSWORD"),
        "HOST": env("DB_HOST"),
        "PORT": env("DB_PORT"),
        "TEST": {
            "TEMPLATE": env("TEST_TEMPLATE_DB_NAME"),
            "NAME": env("TEST_DB_NAME"),
        },
    }
}

# REST API configuration
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework.authentication.BasicAuthentication",
        "rest_framework.authentication.TokenAuthentication",
    ],
    "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
}

# Cross-origin configuration
CORS_ALLOW_ALL_ORIGINS = True

# Email backend
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"
