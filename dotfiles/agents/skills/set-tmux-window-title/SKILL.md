---
name: set-tmux-window-title
description: Give a new agent session or major work topic a descriptive title and set the tmux window title. Use once when starting a new session or switching to a new main topic, not for every command or small task.
---

# Set tmux window title

Choose a short, descriptive title for the session's main topic. If the agent environment supports naming the session, use the same title there. Set the tmux window title once at the start of the topic:

```bash
if [ -n "${TMUX_PANE:-}" ] &&
   window_id=$(tmux display-message -p -t "$TMUX_PANE" -F '#{window_id}' 2>/dev/null) &&
   [ -n "$window_id" ]; then
  tmux rename-window -t "$window_id" '<title>' || true
fi
```

Replace `<title>` with the chosen title (shell-quote it safely). Resolve the window from the agent's `TMUX_PANE` rather than relying on the client's currently active window. If the pane cannot be resolved or tmux is unavailable, do not rename any window; continue the work normally. Do not rerun this for routine commands or minor changes within the same topic.
