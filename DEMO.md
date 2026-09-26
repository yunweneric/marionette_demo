# Demo 01 — "Can you see my app?"

Slide 21. Five minutes. Nothing here is wired: this branch exists so the
agent has a screen to *look at*.

## Run it

```bash
fvm flutter run            # debug mode, so MarionetteBinding is active
```

Copy the VM service URI the console prints (`ws://127.0.0.1:XXXXX/ws`).

## Prompt

```
Connect to my Flutter application at <vm-service-uri> and inspect the
available interactive elements.
```

## What to watch for

The agent should come back with the login screen's controls, not a guess
from the source:

| Element              | Key                                   |
| -------------------- | ------------------------------------- |
| Email field          | `login_email_field`                   |
| Password field       | `login_password_field`                |
| Show/hide password   | `login_toggle_password_visibility`    |
| Forgot password      | `login_forgot_password_button`        |
| Log in               | `login_submit_button`                 |
| Sign up              | `login_signup_button`                 |

## The point

The agent has a second source of truth (slide 22). Ask it something the code
alone cannot answer — "which of these is currently on screen?", "what does
the password field show after you tap the eye?" — and it has to look.
