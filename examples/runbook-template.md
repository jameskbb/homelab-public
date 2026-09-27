# Runbook: restart the start page after a settings change

This is a fictional example of the runbook shape used in the lab. The
service, container, and host names are made up. Copy the structure, not the
values. Each step carries its permission level from the
[traffic-light policy](../docs/change-permissions.md): green needs no
approval, yellow needs a stated undo and a yes, red needs its own yes for
each destructive action.

- **Purpose:** apply an edited settings file to the start page and confirm
  it came back.
- **Highest permission level:** yellow. Nothing here destroys data.
- **Estimated time:** five minutes.
- **Last tested:** never tested. This example has not been run anywhere.
  A real runbook states the date of the last drill, or says "never tested"
  this plainly.

## When to use this

You changed the start page's settings file in the repository and want the
running service to pick it up.

## When not to use this

- The container is already stopped or crashing. That is troubleshooting, not
  a settings reload, and needs the logs first.
- You changed the Compose file itself, not just the settings. Recreating the
  container is a different procedure with a different rollback.

## Prerequisites

- Shell access to the applications VM.
- The settings change is already committed, so the previous version can be
  recovered from Git.

## Pre-flight checks (green)

Read-only commands that confirm the starting state. Nothing here changes
anything, so it is always safe to run and always safe to stop after.

```bash
docker compose -f /srv/startpage/compose.yaml ps
docker compose -f /srv/startpage/compose.yaml config --quiet
```

Expected: the `startpage` container shows as running, and the config check
prints nothing. A config error here means stop; the restart would fail.

## Procedure

1. (green) Note the current container start time so you can tell later that
   it actually restarted.

   ```bash
   docker inspect --format '{{.State.StartedAt}}' startpage
   ```

2. (yellow) Restart the container. Needs approval before running.

   Changes: the start page is unavailable for a few seconds on the
   applications VM.
   Undo: step 1 of Rollback below.

   ```bash
   docker compose -f /srv/startpage/compose.yaml restart startpage
   ```

## Verification

Prefer a command with an unambiguous result over "check that it looks right".

```bash
docker inspect --format '{{.State.StartedAt}}' startpage
curl -fsS -o /dev/null -w '%{http_code}\n' http://localhost:3000/
```

Expected: a newer start time than in step 1, and a `200` response. Then
open the page and confirm the changed setting is visible. A responding page
is not proof the setting applied.

## Rollback

1. Restore the previous settings file from Git and repeat the procedure.

   ```bash
   git -C /srv/startpage checkout HEAD~1 -- config/settings.yaml
   ```

Full rollback is possible. If a runbook cannot be fully rolled back, say so
here explicitly and describe what would be unrecoverable.

## Troubleshooting

| Symptom | Likely cause | Action |
| --- | --- | --- |
| Container restarts repeatedly | Settings file has a syntax error | Read the logs, restore the previous file, restart again. |
| Page responds but the change is missing | File edited in the wrong place | Confirm the path the container actually mounts. |

## Notes

This section records what surprised someone on an earlier run, and it is
updated after each one. In this fictional example:

- The page can show the old settings for a few seconds after the restart
  because the browser cached it. Reload before deciding the change failed.
- The config check in the pre-flight step catches syntax errors only. A
  valid file with a wrong link still passes, so the final look at the page
  matters.

A runbook explains how to do something; it does not grant approval for it.

[Back to the worked examples](README.md)
