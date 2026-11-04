---
name: alert-tmux-window
description: Flag the agent's tmux window for attention when requested work finishes or the user's input is needed. Use when the user should return to the session, not for routine progress updates.
disable-model-invocation: true
---

# Alert tmux window

When work finishes or you need the user's input, flag this session's tmux window once:

```bash
tmux-alert-window || true
```

The helper targets the agent's pane, including through the container bridge. It rings a terminal bell without switching focus; tmux clears the marker when the window is visited. Sound depends on terminal settings.

Do not alert for routine progress or repeat the same event. Outside tmux, do nothing. Ignore helper failure and continue normally.
