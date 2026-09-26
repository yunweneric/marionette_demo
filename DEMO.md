# Demo 04 — "Can you verify your own work?"

Slide 26. Five minutes. The sign-up form exists and has no validation
whatsoever: an empty submit creates an account, and so does `not-an-email`.
The agent writes the rules and then proves them by using the app.

Demo 03's filter bug is fixed on this branch, so the dashboard behaves.

## Run it

```bash
fvm flutter run
```

From the login screen, "Sign up" opens the form.

## Prompt

```
The sign-up form has no validation. Implement it — required fields, a real
email, a password of at least 8 characters, and a confirmation that has to
match — then verify all the validation states in the running app.
```

## What to watch for

The claim at the end is the whole point (slide 27). Not "I've implemented
it", but "I've implemented it, used it, and verified it":

| State                              | Expected                              |
| ---------------------------------- | ------------------------------------- |
| Submit empty                       | an error under every field            |
| `not-an-email`                     | email error only                      |
| Password `123`                     | length error                          |
| Confirmation that does not match   | mismatch error                        |
| All four fields valid              | submits, lands on the dashboard       |

Each row costs the agent a tap and a look: `enter_text`, `tap`,
`get_interactive_elements` or `take_screenshots`, then `hot_reload` between
attempts. Watch it correct itself when a message does not appear where it
expected — that correction is feedback no unit test gave it.

## After the demo

`main` carries one finished implementation of this task, if you want a
reference to diff against on stage.
