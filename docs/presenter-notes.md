# Presenter notes

On `main` only, deliberately: an agent working on a demo branch cannot read
the planted bug's answer out of the repo.

## Before you go on stage

- `fvm install && fvm flutter pub get`
- `dart pub global activate marionette_mcp`
- Boot the simulator and run the app **once** per branch so the first build
  is not happening live.
- Check your agent lists the Marionette tools (`connect`,
  `get_interactive_elements`, `tap`, `enter_text`, `scroll_to`,
  `take_screenshots`, `get_logs`, `hot_reload`, plus `hot_restart`,
  `swipe`, `long_press`, `press_back_button` and a few more).
- Keep the VM service URI on your clipboard. It changes on every `flutter run`.

## Timing (22 min of demo)

| Demo | Branch                     | Budget |
| ---- | -------------------------- | ------ |
| 01   | `demo/01-see-the-app`      | 5 min  |
| 02   | `demo/02-use-the-app`      | 6 min  |
| 03   | `demo/03-find-the-bug`     | 6 min  |
| 04   | `demo/04-verify-your-work` | 5 min  |

Switching branches with the app running is fine: `git checkout`, then ask the
agent to `hot_reload`. That is a demo in itself — no rebuild, no re-login.

## Demo 03 — where the bug is

`lib/features/transactions/transaction_list.dart`, `_matches`:

```dart
case TransactionFilter.income:
  return transaction.amount.isNegative;   // ← income is amount > 0
case TransactionFilter.expenses:
  return !transaction.amount.isNegative;
```

The fix is `transaction.isIncome` / `!transaction.isIncome`. `main` has it.

Why this bug: the `In this month` figure above the chips is computed from
`isIncome` and stays correct, so the screen contradicts itself only while it
is running. Reading the file is enough to spot it — that is fine, and it is
the honest version of the story. The part the code cannot give you is the
proof, so ask for it: *"show me it is fixed in the app."*

## Demo 04 — what "verified" should sound like

Not "I added validators" but "I added validators, submitted an empty form and
got four errors, typed `not-an-email` and got the email error, used a 3-letter
password and got the length error, mismatched the confirmation and got the
mismatch error, then filled it in properly and landed on the dashboard."

`main` carries one finished implementation
(`lib/features/auth/signup_screen.dart`): per-field validators, a `Form` that
only starts nagging after the first submit. Diff against it if you want to
compare on stage.

## The wrinkle in demo 04

`get_interactive_elements` stops at a `TextFormField` and does not return the
error text inside it, so a `validator` + `errorText` implementation can only
be verified by screenshot. Let the agent hit that and switch tools; it is a
truer picture of the integration than pretending the tree contains
everything. If you want to show the alternative, render an error as its own
keyed `Text` under the field and list the elements again.

## Checked on 2026-09-26

Driven through `marionette_mcp` 0.6.0 against an iPhone 11 simulator, all on
Flutter 3.38.6:

- demo 02 — wrong password surfaces "That password is not right."; the right
  one lands on "Hello, Ada".
- demo 03 — the Income chip returns Rent, Groceries and Internet while
  "In this month" still reads +347 600 FCFA, and `get_logs` shows
  `[transactions] filter=Income showing=3 rows`.
- `main` — Income returns salary, invoice and refund; an empty sign-up shows
  four errors and a valid one reaches the dashboard.

## When a demo goes sideways

- **Agent cannot connect.** The URI is stale — every `flutter run` mints a new
  one. Re-copy from the console, ask it to `connect` again.
- **`get_interactive_elements` returns almost nothing.** A dialog, sheet or
  keyboard is covering the screen. `take_screenshots` first, then dismiss.
- **`enter_text` silently misses.** The field is off-screen: `scroll_to` the
  key first. On the sign-up form at small window sizes this can happen.
- **`get_logs` is empty.** The binding needs its collector — check that
  `main.dart` still passes `MarionetteConfiguration(logCollector: …)` and that
  the app was started in debug mode.
- **Hot reload does not pick a change up.** Anything touching `main()` or a
  `const` tree needs `hot_restart`, which loses the session; sign in again.
- **Everything is slow.** Ask for `take_screenshots` less often; element
  listings are cheaper and usually enough.

## Lines worth landing

- Slide 22 — the agent now has a *second source of truth*: the code, and the
  thing the code turned into.
- Slide 27 — "I've implemented it" becomes "I've implemented it, used it, and
  verified it."
- Slide 30 — this is a layer, not a replacement. The unit and widget tests
  stay exactly where they are.
