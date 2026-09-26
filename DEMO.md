# Demo 02 — "Can you use my app?"

Slide 23. Six minutes. Sign-in now works, so the agent can drive it:
find → tap → type → tap → navigate → observe.

## Run it

```bash
fvm flutter run
```

## Prompt

```
Log into the application and navigate to the dashboard.
```

The credentials are on the login screen itself (`demo@flutter.dev` /
`flutter123`), so the agent can read them rather than be told them — a small
moment worth pointing out on stage.

## What to watch for

1. `get_interactive_elements` → it finds the two fields and the button.
2. `enter_text` into `login_email_field` and `login_password_field`.
3. `tap` on `login_submit_button`.
4. Sign-in takes 700 ms, so the agent has to look *again* to see the result.
5. `dashboard_greeting` reads "Hello, Ada".

## Worth doing live

Give it the wrong password on purpose:

```
Try logging in with the password "wrong" and tell me what the app does.
```

It taps, waits, reads `login_error_banner`, and reports the app's own
sentence — "That password is not right." Nothing in the source says which
message wins for which failure; only the running app does.
