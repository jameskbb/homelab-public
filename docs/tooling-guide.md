# The tools behind my homelab

This is the software shortlist I would share with someone building a similar
home setup. It explains what each tool does, where I use it, and a small first
project you can try. Most of these are applications and automation tools;
you do not need to write your own software library to use them.

The experience notes describe work recorded in this lab through September
2026. The project links were checked on 2026-09-10. Use each project's current
installation instructions and compatibility guidance when building your own
setup. This is a guide to recreating the approach, with choices left for your
hardware and needs.

If you only want an early win, start with one Linux virtual machine, Docker
Compose, Homepage, and Uptime Kuma. Add automation once you understand the
steps you want to repeat, and practice a restore before storing important data.

Jump to [OpenTofu](#opentofu-describe-the-virtual-computer-you-want),
[Uptime Kuma](#uptime-kuma-see-when-something-stops-responding), or
[the build order](#a-practical-build-order-for-your-own-version).

## How the pieces fit together

A virtual machine, or VM, is a separate computer implemented in software.
A container packages an application and its dependencies while sharing its
host's operating-system kernel. In this lab, application containers run inside
VMs.

| Job | Tools used here | Where they work |
| --- | --- | --- |
| Run separate virtual computers | Proxmox VE; Debian inside the VMs | Physical server and its guests |
| Create and prepare those computers | OpenTofu with the bpg Proxmox provider; cloud-init; Ansible | Administration computer and the VMs it manages |
| Run everyday applications | Docker Engine and Compose; Homepage | Applications VM |
| Check availability and protect data | Uptime Kuma; restic | Services and their backup workflows |
| Host games | Pterodactyl Panel and Wings; Paper | Games VM |

Git keeps the configuration and documentation changes reviewable. It is useful
across these layers, but committing a file does not change a running service.

## The foundation

### Proxmox VE: one physical computer, several virtual ones

Proxmox is the virtualization platform installed on the physical server. It
provides a browser interface for managing virtual computers and allocating
their memory, processor capacity, and disks.
[Project overview](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview).

**What worked here:** one desktop hosts separate applications, games, and
personal-experiment environments. Each has its own operating system. That
separation has given the project clear places to put different workloads.

**First project:** use a spare computer you are prepared to dedicate to the
lab and create one disposable Linux VM. Learn how to inspect its resources
and use its console before automating creation.
[Official installation starting point](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started).

The shared hardware is still a shared dependency: separate VMs do not make a
single physical server highly available.

### Debian and cloud-init: a repeatable Linux starting point

Debian is the Linux operating system inside the lab's VMs. Linux supplies the
basic environment that services run in.
[About Debian](https://www.debian.org/intro/about).

Cloud-init handles initial setup when a new instance is created, such as
establishing its initial user configuration. A reusable VM template is a
prepared starting image; cloud-init personalizes a new copy.
[Cloud-init introduction](https://docs.cloud-init.io/en/latest/explanation/introduction.html).

**What worked here:** a Debian cloud-init template became the starting point
for guest creation, including a disposable test before permanent workloads.

**First project:** learn to use one Debian VM, then build a reusable template
and confirm a fresh copy starts correctly. Keep initial setup small; use
Ansible for the ongoing configuration described below.

### Git: a record of what changed and why

Git stores versions of text files so you can compare changes and recover
earlier file contents. GitHub is a place to host Git repositories; Git itself
also works locally.
[Git's introduction to version control](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control).

**What worked here:** infrastructure definitions, service configuration, and
written decisions live together in the operational project. Public explanations
are curated separately.

**First project:** keep your own setup notes and non-secret configuration in a
private repository. Make a small commit after each working step and describe
what changed. Reverting a file in Git does not automatically roll back a live
machine, and Git is not a backup of your game worlds or application databases.

## Making setup repeatable

### OpenTofu: describe the virtual computer you want

OpenTofu manages infrastructure from text definitions, often called
"infrastructure as code." Its workflow is to write the desired configuration,
preview a plan, and apply the reviewed changes.
[OpenTofu workflow](https://opentofu.org/docs/intro/core-workflow/).

**What worked here:** VM definitions were exercised through a disposable VM's
creation and removal, and now describe the permanent guests. The useful result
is a repeatable definition of each VM instead of a collection of remembered
clicks.

For Proxmox, this lab uses the **bpg/proxmox provider**. A provider is the
connector that lets OpenTofu communicate with a particular platform. This one
is a community project, separate from Proxmox itself. Read its current
compatibility and authentication requirements when choosing versions.
[Provider project](https://github.com/bpg/terraform-provider-proxmox) and
[provider documentation](https://bpg.sh/docs/).

**First project:** define one disposable VM in your own environment and read
its plan before applying it. Confirm a later plan proposes no unexpected
changes. Keep OpenTofu's state file private and recoverable: it records the
resources under management and can contain sensitive values.

In this lab, OpenTofu creates the VM; Ansible configures the operating system
inside it. Keeping those responsibilities separate makes changes easier to
understand.

### Ansible: turn setup steps into a repeatable checklist

Ansible manages the desired configuration of existing machines. An
**inventory** lists the machines to manage; a **playbook** describes the work.
The **control node** is the administration computer where you run Ansible.
[Ansible getting started](https://docs.ansible.com/projects/ansible/latest/getting_started/index.html).

**What worked here:** shared baseline configuration was applied across the
VMs, and application-specific setup is recorded in reusable pieces called
roles. Repeat runs have been used to check that configured systems match the
intended setup.

**First project:** automate one small task in a disposable VM, such as ensuring
a package is installed. Run it again and confirm it reports no change when
the desired state already exists. This behavior is called idempotence.

Ansible's check and diff modes can preview supported tasks, but some tasks
cannot be simulated fully. Treat previews as useful evidence, then verify the
result after applying.
[Check-mode documentation](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_checkmode.html).

### Docker Engine and Compose: package and run applications

Docker Engine runs containers. Compose describes an application's containers,
storage, and other requirements in a YAML file, a text format for structured
settings. That file gives you a repeatable way to start the application.
[Docker Compose overview](https://docs.docker.com/compose/).

**What worked here:** Homepage and Uptime Kuma have separate Compose
definitions on the applications VM. Each application's setup has a clear home
instead of relying on a long command typed once.

**First project:** install Docker Engine and the Compose plugin inside your
Linux VM, then follow Homepage's example below.
[Docker's Debian installation guide](https://docs.docker.com/engine/install/debian/).

Learn where the app saves its data. A **volume** is storage kept separately
from the disposable container. Recreating a container is not the same thing
as recovering its data; record and back up the persistent data you need.

## Everyday services and recovery

### Homepage: a starting page for your services

Homepage is a dashboard for organizing links and displaying information from
services. Its configuration can be written in YAML.
[Homepage project documentation](https://gethomepage.dev/).

**What worked here:** it provides the lab's start page, and its visual
configuration has been managed in Git and deployed successfully.

**First project:** make a small page with a few links to your own services.
Begin with ordinary links, then add an integration only when its information
helps you. This keeps the first version easy to understand.
[Homepage Docker installation](https://gethomepage.dev/installation/docker/).

Homepage answers "where do I go?" Uptime Kuma adds the separate question
"is it responding?"

### Uptime Kuma: see when something stops responding

Uptime Kuma is a monitoring application you run yourself. It supports checks
for web pages, network services, and **push monitors**, where a job sends a
signal after it runs. It also supports notifications through multiple services.
[Uptime Kuma project and installation guide](https://github.com/louislam/uptime-kuma).

**What worked here:** checks for applications and game services were verified,
and backup jobs have sent success signals. A restore exercise also produced
a recorded outage and recovery, demonstrating that a monitor caught a real
interruption.

**First project:** create a web-page monitor for your test Homepage instance.
Briefly stop only that test app, confirm the monitor changes to down, then
start it and confirm recovery. Test notification delivery separately if you
configure notifications.

A passing check answers only the question you configured. A responding game
service does not prove a player can join; a backup-job signal does not prove
the backup can be restored. If the machine running the monitor is off, it
cannot report from there.

### restic: encrypted backups with a recovery path

Restic creates encrypted backups and supports multiple storage destinations.
It lets you restore files from snapshots, which record the contents of a
backup run. [Restic documentation](https://restic.readthedocs.io/en/stable/).

**What worked here:** encrypted offsite copies and restore tests have been
completed for selected application and game data. The recovery workflow first
prepares suitable application backups, then uses restic for the offsite copy.

**First project:** back up a folder of disposable sample files, restore it to
a different folder, and compare the contents. Start with the
[restic quickstart](https://restic.readthedocs.io/en/stable/010_introduction.html).
Then choose a destination outside
the machine whose loss you want to survive.
[Restic restore guide](https://restic.readthedocs.io/en/stable/050_restore.html).

For live databases and games, use a backup method that produces consistent
data before copying it. Restic cannot make an arbitrary copy of changing files
application-consistent. Keep the backup password recoverable separately from
the server. These selected-data restores do not establish complete physical-host
recovery.

## Game hosting

### Pterodactyl: manage game servers through a panel

Pterodactyl provides a game-server management interface and runs game servers
in Docker containers. Its **Panel** is the web interface; **Wings** is the
service that runs the game containers.
[Pterodactyl introduction and installation links](https://pterodactyl.io/project/introduction.html).

**What worked here:** it manages the lab's Minecraft environments and other
game-server workloads. It gives those workloads their own management workflow.

**First project:** after becoming comfortable with Linux and Docker, follow
both the Panel and Wings setup documentation and run one test game server.
An **egg** is Pterodactyl's reusable installation and startup recipe for a
game. Select a recipe that matches the game you want to run.
[Panel, Wings, and egg terminology](https://pterodactyl.io/project/terms.html).

This is a larger project than a dashboard: the Panel has supporting services
to maintain, and game data still needs backups. In this lab, game containers
are managed by Pterodactyl, not by the everyday-app Compose definitions.

### Paper: the Minecraft server software

Paper runs Minecraft: Java Edition servers and supports server plugins that
extend the game.
[Paper documentation](https://docs.papermc.io/paper/).

**What worked here:** survival and OneBlock Minecraft environments have run
on Paper, and both have passed restore drills. Paper is the game-server
software; Pterodactyl is the tool managing its lifecycle.

**First project:** get an unmodified Paper test server working before adding
plugins. Use the Java version required by your chosen Paper release and follow
the project's setup instructions. Add plugins one at a time, checking their
compatibility and the result in-game.
[Paper getting started](https://docs.papermc.io/paper/getting-started/).

For a first Minecraft-only experiment, you can learn Paper on its own before
adding a management panel.

## A practical build order for your own version

This is a suggested learning sequence, not a claim that every step is
automatic. Keep experiments on your own test equipment and use the linked
project guides for installation details.

| Step | Build | You have reached the checkpoint when... |
| --- | --- | --- |
| 1 | One Debian VM on a spare Proxmox machine | The VM boots and you can use its console. |
| 2 | Docker Compose and a simple Homepage | Your start page works and its configuration survives replacing the test container. |
| 3 | Uptime Kuma watching that test application | You have observed both a deliberate interruption and recovery. |
| 4 | A restic practice backup, then an application-aware backup | Sample files restore correctly; you have also tested the application's own recovery on a spare instance. |
| 5 | A separate VM built with cloud-init, OpenTofu, and Ansible | It can be created and configured from your definitions, and repeat checks show the intended state. |

Keep your working notes in Git throughout. In step 5, practice on a new VM
rather than assuming OpenTofu automatically manages the manually created
learning VM. After these foundations, add game hosting if it is useful to you.

To make your version reproducible, record these choices in your own private
notes:

- The software and provider versions you tested together.
- What each VM is for and the resources it needs.
- Which files describe creation, configuration, and application startup.
- Which data needs recovery, where its backups go, and how you tested a restore.

The result to aim for is a small service you can explain, monitor, and recover.
That is a useful foundation for deciding what to add next.

[Back to the homelab overview](../README.md) |
[See the architecture overview](architecture.md)
