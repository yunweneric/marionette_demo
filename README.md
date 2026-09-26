# Marionette demo — Flutter Akure 2026

The app behind *"Your Coding Agent Is Flying Blind"*. A small banking-ish
Flutter app whose only job is to be driven by an AI agent through
[Marionette MCP](https://github.com/leancodepl/marionette_mcp): the agent
connects to the running app over the VM service, reads the widget tree, taps,
types, screenshots, reads logs, and hot reloads between attempts.

Flutter **3.38.6**, pinned with fvm (`.fvmrc`). Every command below assumes
`fvm` in front of `flutter`.

## Setup, once

```bash
fvm install                              # the pinned 3.38.6
fvm flutter pub get
dart pub global activate marionette_mcp  # the bridge the agent talks to
```

Claude Code picks up the server from `.mcp.json` in this repo. For other
tools:

```bash
claude mcp add --transport stdio marionette -- marionette_mcp   # Claude Code, global
```

```jsonc
// Cursor · .cursor/mcp.json
{ "mcpServers": { "marionette": { "command": "marionette_mcp", "args": [] } } }
```

## Setup, every time

```bash
fvm flutter run          # debug mode — MarionetteBinding only exists there
```

Copy the VM service URI the console prints, then tell the agent:

```
Connect to my Flutter app at ws://127.0.0.1:<port>/<token>/ws
```

Sign-in for every branch: `demo@flutter.dev` / `flutter123` (also printed on
the login screen, so the agent can read it rather than be told).

## The branches

One per demo, each one the state of the app when that demo starts. Every
branch carries its own `DEMO.md` with the prompt and what to watch for.

| Branch                     | Slide | The question                      |
| -------------------------- | ----- | --------------------------------- |
| `demo/01-see-the-app`      | 21    | "Can you see my app?"             |
| `demo/02-use-the-app`      | 23    | "Can you use my app?"             |
| `demo/03-find-the-bug`     | 25    | "Can you find what's broken?"     |
| `demo/04-verify-your-work` | 26    | "Can you verify your own work?"   |
| `main`                     | —     | all four, finished: bug fixed, validation implemented |

They are stacked, so each branch contains everything before it:

```
main
└── demo/04-verify-your-work   sign-up form, no validation
    └── demo/03-find-the-bug   transactions + the planted bug
        └── demo/02-use-the-app   sign-in → dashboard
            └── demo/01-see-the-app   login screen, nothing wired
```

Presenter notes — including where the planted bug lives and what to do when a
demo goes sideways — are in [`docs/presenter-notes.md`](docs/presenter-notes.md),
on `main` only, so an agent working on a demo branch cannot read the answer
out of the repo.

## What is Marionette-specific in this app

Two things, both in [`lib/main.dart`](lib/main.dart):

```dart
MarionetteBinding.ensureInitialized(
  MarionetteConfiguration(logCollector: logs),
);
```

and a `runZoned` print hook that forwards `debugPrint` into that collector so
`get_logs` returns something. Everything else is an ordinary Flutter app.

Keys are the other half. Every control carries one (`login_submit_button`,
`transactions_filter_income`, …) because that is what `get_interactive_elements`
returns and what `tap` and `enter_text` take. Text matching also works, but
keys survive a copy change.
