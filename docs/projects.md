# Project walkthroughs

These three projects explain the work behind the useful parts of the lab,
including things that needed fixing. Each connects a practical problem to the
tools used and something you can learn from the result.

Start with the everyday applications below, then explore how setup became
repeatable and what it took to recover a game world. If you are planning your
first project, [Your first homelab](start-here.md) introduces the terms and a
smaller starting point.

The outcomes summarize work recorded through September 2026. Operational
configuration and detailed execution records remain private; these are curated
technical explanations. For tool definitions and official setup guides, see
the [tooling guide](tooling-guide.md).

## Everyday applications and monitoring

**The problem:** useful services need both a place to find them and a way to
notice when they stop responding. A start page and a monitor answer different
questions.

**What I built:** Homepage organizes links to the services, while Uptime Kuma
checks whether they respond. Both run in the applications virtual machine (VM),
with separate Docker Compose files describing how to start each application's
containers. The dashboard's settings are recorded in Git, which keeps a history
of file changes, and applied through the setup process.

**What I checked:**

- The applications were deployed and their responses checked.
- Monitoring checks were verified for applications and game services, and
  backup jobs sent success signals.
- An application restore exercise produced a recorded interruption and
  recovery in the monitor.

**A problem that improved the setup:** a dashboard deployment initially failed
because its startup process expected additional files alongside the managed
configuration. Returning to the previous working setup, called a **rollback**,
restored service; supplying the missing files allowed the next attempt to pass
its application checks. The lesson was to
verify the files an application needs at startup, as well as the settings being
changed.

**The tradeoff:** a monitor reports what its check can observe. A responding game
service does not prove someone can join, and a backup-job success signal does
not prove the data can be restored. The monitoring application also shares the
physical server, so it cannot report from there when that server is off.

For your own version, run a small dashboard and monitor that test application.
Observe a deliberate stop and recovery before depending on the check. See
[the everyday service tools](tooling-guide.md#everyday-services-and-recovery).

## Repeatable server setup

**The problem:** creating a virtual machine is only the beginning. It also needs
an operating system and configuration before it can run a useful service.
Repeating those steps manually makes the setup harder to review and recreate.

**What I built:** a reusable starting copy of Debian Linux, VM definitions
managed with OpenTofu, and settings managed with Ansible. Cloud-init handles
initial VM setup. Git records the definitions and changes so they can be
compared and explained later.

The responsibilities are separate: OpenTofu manages the virtual computer,
cloud-init gives it its initial setup, and Ansible configures the operating
system and service requirements. A change can be traced to the layer that owns
it instead of being hidden among remembered setup steps.

**What I checked:**

- A disposable VM completed creation, boot, access checks, and removal before
  the same approach was used for permanent workloads.
- Common Linux settings were applied across the VMs.
- A second Ansible run reported no changes for the configuration it managed.
  This is **idempotence**: applying the same desired configuration again does
  not need to change a system that already matches it.

**The tradeoff:** automation introduces definitions, dependencies, and state to
maintain. OpenTofu's state records the resources it manages and needs private,
recoverable storage. A repeat configuration run is useful evidence about those
tasks; it does not prove every service works or that the whole lab can be
rebuilt from scratch.

For your own version, begin with a disposable VM whose loss does not matter.
Learn the manual setup first, then automate the steps you understand. See
[the automation tools](tooling-guide.md#making-setup-repeatable) and
[the architecture layers](architecture.md#from-a-definition-to-a-running-service).

## Game hosting and recovery

**The problem:** a game server has both replaceable software and saved data that
players care about. Starting a new container is not the same as recovering a
world.

**What I built:** Pterodactyl Panel and Wings manage game workloads in the games
VM, with Paper running the Minecraft environments. Backup workflows prepare
suitable application and game data, and restic makes encrypted offsite copies
of selected data.

**What I checked:** selected application-data restores were completed, and
survival and OneBlock Minecraft environments both passed restore drills in
August 2026. The records also include offsite retrieval tests; those are a
separate check from recovering a running service.

**A problem that improved the setup:** a Minecraft restore returned the world
data, but the backup intentionally excluded downloadable server and plugin
files. Recovery also needed to reinstall the server software, reapply its saved
settings, and verify startup. The missing reinstall step was added to the
reusable automation and exercised in the second Minecraft restore drill.

This turned a successful backup into a more complete recovery procedure. The
important question became whether the saved data and the software needed to use
it could be brought back together.

**The tradeoff:** selected-data backups reduce what must be copied, but recovery
depends on knowing which software and configuration must be recreated. These
exercises cover selected applications and the two Minecraft environments.
They do not establish recovery for every game, a whole VM, or the entire
physical server.

For your own version, practice with disposable files first, then recover one
application in a separate test environment. Check the application as well as
the restored files. See [restic and recovery](tooling-guide.md#restic-encrypted-backups-with-a-recovery-path)
and [the game-hosting tools](tooling-guide.md#game-hosting).

[Back to the homelab overview](../README.md) |
[Plan a first lab](start-here.md) |
[See the architecture](architecture.md) |
[Read the lessons](what-i-learned.md)
