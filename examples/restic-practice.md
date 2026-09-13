# Restic practice: back up and restore sample files

This is the exercise from step 5 of [Your first homelab](../docs/start-here.md).
It uses disposable files so a mistake costs nothing. The point is to see a
backup go in and come back out before you trust the tool with real data.

Restic stores backups in a **repository**: a folder or remote location that
holds encrypted **snapshots**, each recording the contents of one backup run.
The repository is protected by a password. Keep that password somewhere
outside the machine being backed up; without it, every snapshot is unreadable.

## 1. Make something to protect

```sh
mkdir -p ~/practice/sample
echo "first note" > ~/practice/sample/notes.txt
echo "a second file" > ~/practice/sample/other.txt
```

## 2. Create a repository

Restic reads the repository location and password from environment variables,
which keeps them out of your command history. For practice, the repository
is a local folder. Later, point it at storage outside the machine.

```sh
export RESTIC_REPOSITORY=~/practice/repo
export RESTIC_PASSWORD_FILE=~/practice/password.txt
echo "practice-only-password" > "$RESTIC_PASSWORD_FILE"
restic init
```

## 3. Back up, change something, back up again

```sh
restic backup ~/practice/sample
echo "an edit" >> ~/practice/sample/notes.txt
restic backup ~/practice/sample
restic snapshots
```

The snapshot list shows two entries. Restic only stored the parts that
changed between them, which is why a mostly unchanged folder costs little
to back up repeatedly.

## 4. Restore to a different folder and compare

Restoring somewhere new avoids overwriting the original while you check
the result.

```sh
restic restore latest --target ~/practice/restored
diff -r ~/practice/sample ~/practice/restored/$HOME/practice/sample
```

No output from the comparison means the restored files match. Try restoring
the first snapshot by its ID as well, and confirm the note lacks the edit.

## What this does and does not show

You have proved that files go in and come back out. For a real application,
two more questions remain. First, are the files a usable copy? A database or
a game world may need the application's own backup step before copying, so
that the files are consistent. Second, does the application start again with
the restored data? The lab's [recovery walkthrough](../docs/projects.md#game-hosting-and-recovery)
shows how a restore that returned all the files still needed the server
software reinstalled before the world was playable.

[Back to the examples](README.md) |
[Restic documentation](https://restic.readthedocs.io/en/stable/)
