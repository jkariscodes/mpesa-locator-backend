from .base import *

ENV = "development"

SECRET_KEY = env("SECRET_KEY")

DEBUG = True

ALLOWED_HOSTS = env("ALLOWED_HOSTS").split(" ")

DATABASES_URL = env("DATABASE_URL")
