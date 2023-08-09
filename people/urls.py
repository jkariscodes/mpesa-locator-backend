from django.urls import path, include, re_path
from django.views.generic import TemplateView
from dj_rest_auth.registration.views import (
    RegisterView,
    VerifyEmailView,
    ConfirmEmailView,
    ResendEmailVerificationView,
)
from dj_rest_auth.views import LoginView, LogoutView

urlpatterns = [
    path("login/", LoginView.as_view()),
    path("logout/", LogoutView.as_view()),
    path("signup/", RegisterView.as_view(), name='account_signup'),
    path("email-verify/", VerifyEmailView.as_view(), name='rest_verify-email'),
    path("email-resend/", ResendEmailVerificationView.as_view(), name='rest_resend_email'),
    path(
        "verify-email/",
        TemplateView.as_view(),
        name="account_email_verification_sent",
    ),
    re_path(
        r"^confirm-email/(?P<key>[-:\w]+)/$",
        ConfirmEmailView.as_view(),
        name="account_confirm_email",
    )
]
