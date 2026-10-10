---
name: set-tmux-window-title
description: Give a new agent session or major work topic a descriptive title and set the tmux window title. Use once when starting a new session or switching to a new main topic, not for every command or small task.
---

# Set tmux window title

Choose a short, descriptive title for the session's main topic. If the agent environment supports naming the session, use the same title there. Set the tmux window title once at the start of the topic:

```bash
tmux-rename-window '<title>'
```

Replace `<title>` with the chosen title (shell-quote it safely). Use `tmux-rename-window` script. Ignore script failure; continue the work normally. Do not rerun this for routine commands or minor changes within the same topic.
