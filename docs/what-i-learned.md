# What I learned building a homelab

These are the ideas I would carry into another build. The evidence behind
each one is in the [project walkthroughs](projects.md), which describe the
setup, checks, and fixes recorded through September 2026. This page keeps to
the lessons rather than retelling the stories.

## Start with a useful job

The project became easier to prioritize once every addition had to answer a
simple question: what problem does this solve at home? A start page reduces
friction, a monitor says when something is unavailable, and a game server
gives friends a shared place. A retired desktop was enough hardware to begin
answering those questions, and it still is.

## Decide what is precious and what is rebuildable

The most useful design decision was drawing a line between data that cannot
be recreated and everything that can. Worlds, settings, and monitor history
are precious. Operating systems, runtimes, and downloaded software are
rebuildable from written definitions. That line decided what to back up, what
to automate, and what a restore has to include. It is explained on the
[decisions page](decisions.md).

## A second run is the real test of automation

Applying a configuration once shows that it can be applied. Applying it again
and seeing no changes shows that it describes a state rather than a sequence
of steps. Proving the process on a disposable VM before any permanent one
existed made later mistakes cheaper. Even so, a clean second run only speaks
for the tasks it manages; the application still needs its own check.

## A monitor tells you where to look, not that things work

A check answers only the question it was configured to ask. A web page
responding does not prove every feature works, and a backup job reporting
success does not prove the backup can be restored. The check that earned my
trust was one that recorded a real interruption and recovery during a restore
exercise, rather than a dashboard that had only ever been green.

## Configuration includes what the application needs to start

A settings file can look complete while the application still lacks
something it expects at startup. Rolling back restored service; supplying the
missing files fixed the next attempt. Since then, the files an application
needs to start are recorded alongside the settings I actually wanted to change.

## A restore is not finished until the service runs

Restoring files and recovering a service are different tasks. The Minecraft
drill returned every byte of world data and still was not playable until the
server software was reinstalled and its settings reapplied. Adding that step to
the automation, then exercising it in a second drill, was worth more than the
first backup was. Selected application and game restores now have recorded
results, and one VM has been rebuilt from its definitions; rebuilding the
whole physical server has not been exercised.

## Restoring a backup is not decontamination

A backup copies the directories where an application keeps its state, which
is exactly where anything unwanted would persist. So the answer to "this
machine might be compromised" is not the newest backup. It is a fresh VM
built from the written definitions, with a deliberate decision about what, if
anything, to carry across. The experiments VM was rebuilt that way in a
drill, and the only thing lost was session history. The
[decisions page](decisions.md#rebuild-from-code-after-a-suspected-compromise)
explains what a rebuild does and does not prove.

## A procedure done twice gets a runbook

A runbook exists so a task can be done correctly late at night by someone who
has not thought about it in months. The private lab keeps one for any
procedure performed more than once, anything risky, and every recovery path.
Four rules made them useful: start with read-only checks so it is safe to
stop partway, label every step with its
[permission level](change-permissions.md), always include a way back or say
plainly that there is none, and mark a recovery procedure untested until a
drill proves it. The [runbook example](../examples/runbook-template.md)
shows the shape with a fictional procedure.

## Public notes are a different document

The private build notes are detailed because they must support operation and
recovery. Public notes have a different job: explain the decisions, the
learning, and the outcomes without sharing internal routes, service links,
account details, or secrets. Both can be honest without being the same
document, and the [publishing checklist](before-you-publish.md) keeps the line
between them.

[Back to the homelab overview](../README.md) |
[Plan a first lab](start-here.md) |
[Read the project walkthroughs](projects.md) |
[Why the lab is built this way](decisions.md)
