# Demo 03 — "Can you find what's broken?"

Slide 25. Six minutes. The dashboard now lists recent activity behind three
filter chips, and one of them is wrong. The report below is all the agent
gets: it has to reproduce the behaviour in the running app before it can say
anything useful about the cause.

## Run it

```bash
fvm flutter run
```

Sign in with `demo@flutter.dev` / `flutter123`.

## Prompt

Paste the ticket, then the instruction:

```
Support ticket #042 — "The Income filter on the dashboard is lying. I tap
Income and I see my rent and my groceries. My September salary is nowhere.
The 'In this month' figure above the chips looks right."

Investigate this issue. Reproduce it and fix it.
```

## What to watch for

The path on the slide, step by step:

1. **Reproduce** — log in, tap `transactions_filter_income`.
2. **Observe** — screenshot, or read the rows back. Rent and groceries.
3. **Inspect** — the `In this month` figure disagrees with the list.
4. **Diagnose** — one predicate decides what a filter matches.
5. **Modify** — a one-line fix.
6. **Hot reload** — `hot_reload`, no sign-in again, the app keeps its state.
7. **Try again** — tap Income, then Expenses.
8. **Verify** — salary, invoice and refund under Income; rent, groceries and
   internet under Expenses.

Step 6 is the one to narrate. The agent is already signed in, and a hot
reload keeps it that way — the fix is checked in seconds, not in a fresh
launch and another sign-in.

## If the agent goes straight to the source

That is fine, and worth saying out loud: it may well read the predicate and
spot it. Then ask for the part the code cannot give you — "prove it is fixed
in the running app" — and let it tap through both chips and report back.
