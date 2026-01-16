# Braindump

Write-only journaling app. Append-only to `~/journal.md`.

## Usage

```bash
ruby journal.rb
```

Type your thoughts and press Enter. Each line is immediately saved. Ctrl+C or Ctrl+D to exit.

## Features

- Write-only: no editing, no deleting, no reading
- Timestamps at session start and after 30 minutes of inactivity
- Audio feedback on each saved line
