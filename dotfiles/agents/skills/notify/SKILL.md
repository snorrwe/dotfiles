---
name: notify
description: Send a desktop notification when work is finished or the user's input is needed. Use when the user needs to return to the session, not for routine progress updates.
---

# Notify the user

When you finish the requested work or cannot continue without the user's input, send one brief notification. Do not send notifications for routine progress or duplicate notifications for the same event.

Use the current session/window title as the summary if it describes the task; otherwise use a short task name. In the body, say what happened and what the user needs to do (for example, “Ready for review” or “Need your choice of deployment target”). Keep the notification consistent with your response to the user.

```bash
notify-send 'Refine notify skill' 'Finished — ready for review' || true
```

Shell-quote both arguments. If `notify-send` is unavailable or fails (for example, there is no desktop notification service), continue with a normal response instead of retrying or treating it as a task failure.
