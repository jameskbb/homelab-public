# What I learned building a homelab

The most useful lessons came from checking the work: repeating setup, observing
an interruption, and restoring saved data. These notes reflect the exercises
described in the [project walkthroughs](projects.md) through September 2026.

## Start with a useful job

The project became useful when every addition answered a simple question: what
problem does this solve at home? A start page reduces friction. Monitoring tells
me when something is unavailable. Game servers create a shared place for
friends. Those jobs made the project easier to prioritize than a list of
hardware upgrades.

## Ordinary hardware is enough to begin

The retired desktop became the foundation for applications, games, and
experiments. It provided a place to practice virtualization, Linux setup,
monitoring, and recovery using hardware already available.

All the virtual machines still share its physical resources. That makes
understanding the shared limits part of the project.

## Keep different jobs separate

Keeping applications, games, and experiments in different virtual computers
gives their settings and updates separate homes. Supporting software for a game
can change within the games environment, and an experiment has its own
operating system. That is useful organization, even though a problem with the
physical desktop can still affect every environment.

## Repeatable setup needs a second run

Creating a test VM that could be discarded checked the setup process before
using it for lasting projects. Running the configuration again checked whether
it needed further changes when the intended setup already existed. The recorded
second Ansible run reported no changes.

Those checks answer specific questions. Applying settings can succeed while
an application still needs a check of what it actually does. Keeping machine
setup, application settings, and checks of the result distinct makes the work
easier to understand.

## Test what a monitor can observe

A monitor recorded an interruption and recovery during an application restore
exercise. That is more useful evidence than a dashboard that has only ever
shown healthy services.

The scope of a check matters. A web response does not prove every feature works,
and a backup success signal does not prove recovery. Monitoring helps identify
where to look; the application and its data still need their own checks.

## Configuration includes startup requirements

A dashboard deployment exposed missing files expected by the application's
startup process. Returning to the previous working setup restored service, and
including the missing files allowed the next attempt to pass its checks.

The lesson was to record the surrounding startup requirements along with the
settings I wanted to manage. A configuration file can look complete while the
application still lacks something it needs to start.

## Backups become real at restore time

The Minecraft restore drills showed why restoring files and recovering a
service are different tasks. World data was backed up, while downloadable
server and plugin files were excluded. The recovery workflow needed to put
the server software and saved settings back alongside the restored data.

Adding the missing reinstall step to automation and exercising it in the second
drill improved the procedure. Selected application and Minecraft restores now
have recorded results; rebuilding the entire physical server was not covered by
these exercises.

## Public sharing needs a different kind of documentation

The private build notes are detailed because they must support operation and
recovery. Public notes have a different job: explain the decisions, the
learning, and the outcomes without sharing internal routes, service links,
account details, or secrets. Both documents can be honest, but they should not
be the same document.

[Back to the homelab overview](../README.md) |
[Plan a first lab](start-here.md) |
[Read the project walkthroughs](projects.md) |
[Explore the tools](tooling-guide.md)
