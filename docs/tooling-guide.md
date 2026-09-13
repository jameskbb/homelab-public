# The tools behind my homelab

This is the software shortlist I would share with someone building a similar
home setup. It explains what each tool does, where I use it, and a small first
project you can try. Most of these are applications and automation tools.

If you are new to servers, begin with [Your first homelab](start-here.md) for
plain-language definitions and a smaller first project. You can return here
for a particular tool when you reach the step that uses it.

The experience notes describe work recorded in this lab through September
2026. The project links were checked on 2026-09-11. Use each project's current
installation instructions and compatibility guidance when building your own
setup. This is a guide to recreating the approach, with choices left for your
hardware and needs.

If you only want an early win, start with one Linux virtual machine, Docker
Compose, Homepage, and Uptime Kuma. Add automation once you understand the
steps you want to repeat, and practice a restore before storing important data.

Explore [the foundation](#the-foundation),
[repeatable setup](#making-setup-repeatable),
[everyday services and recovery](#everyday-services-and-recovery),
[game hosting](#game-hosting), or
[the build order](#a-practical-build-order-for-your-own-version).

For the recorded checks connecting these tools, read the
[project walkthroughs](projects.md). For why each tool was chosen over a
simpler option, read [Why the lab is built this way](decisions.md). The
[worked examples](../examples/README.md) show what the configuration files
look like, with fictional values.

## How the pieces fit together

A virtual machine, or VM, is a separate computer implemented in software.
A container packages an application and the supporting software it needs while
sharing the core of the operating system it runs on. In this lab, application
containers run inside VMs.

| Job | Tools used here | Where they work |
| --- | --- | --- |
| Run separate virtual computers | Proxmox VE; Debian inside the VMs | Physical server and its VMs |
| Create and prepare those computers | OpenTofu with the bpg Proxmox provider; cloud-init; Ansible | Administration computer and the VMs it manages |
| Run everyday applications | Docker Engine and Compose; Homepage | Applications VM |
| Check availability and protect data | Uptime Kuma; restic | Services and their backup workflows |
| Host games | Pterodactyl Panel and Wings; Paper | Games VM |

Git keeps changes to settings and documentation reviewable. A **commit** is a
saved checkpoint of changes to files. Saving that checkpoint does not itself
change a running service.

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
its plan before applying it. The [example VM definition](../examples/repeatable-setup/vm.tf)
shows the shape of one. Confirm a later plan proposes no unexpected
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
a package is installed. The [example playbook](../examples/repeatable-setup/baseline.yml)
does that and little more. Run it again and confirm it reports no change when
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
Linux VM, then follow Homepage's example below. The
[example Compose file](../examples/start-page-and-monitor/compose.yaml) is
annotated line by line.
[Docker's Debian installation guide](https://docs.docker.com/engine/install/debian/).

Learn where the app saves its data. A **volume** is persistent storage managed
by Docker; a **bind mount** connects a folder on the VM to the container. Both
can keep data outside the container itself. Recreating a container is not the
same thing as recovering its data; record and back up the persistent data you
need. [Docker storage documentation](https://docs.docker.com/engine/storage/).

## Everyday services and recovery

### Homepage: a starting page for your services

Homepage is a dashboard for organizing links and displaying information from
services. Its configuration can be written in YAML.
[Homepage project documentation](https://gethomepage.dev/).

**What worked here:** it provides the lab's start page, and its visual
configuration has been managed in Git and deployed successfully.

**First project:** make a small page with a few links to your own services,
like the [example links file](../examples/start-page-and-monitor/homepage-config/services.yaml).
Begin with ordinary links, then add an integration only when its information
helps you. Follow the installation guide's required settings; ordinary links
do not need a Docker integration.
[Homepage Docker installation](https://gethomepage.dev/installation/docker/).

Homepage answers "where do I go?" Uptime Kuma adds the separate question
"is it responding?"

### Uptime Kuma: see when something stops responding

Uptime Kuma is a monitoring application you run yourself. It supports checks
for web pages, network services, and **push monitors**, where a job sends a
signal after it runs. It also supports notifications through multiple services.
[Uptime Kuma project and installation guide](https://github.com/louislam/uptime-kuma).

**What worked here:** checks for applications and game services were verified,
and backup jobs have sent success signals. A monitor has also caught a real
interruption; the [monitoring walkthrough](projects.md#everyday-applications-and-monitoring)
describes that and what a passing check does not tell you.

**First project:** create a web-page monitor for your test Homepage instance.
Briefly stop only that test app, confirm the monitor changes to down, then
start it and confirm recovery. Test notification delivery separately if you
configure notifications.

### restic: encrypted backups with a recovery path

Restic creates encrypted backups and supports multiple storage destinations.
It lets you restore files from snapshots, which record the contents of a
backup run. [Restic documentation](https://restic.readthedocs.io/en/stable/).

**What worked here:** encrypted offsite copies and restore tests have been
completed for selected application and game data. Offsite means the backup is
stored in another location; encryption protects its contents with a password.
The recovery workflow first prepares suitable application backups, then uses
restic for the offsite copy.

**First project:** back up a folder of disposable sample files, restore it to
a different folder, and compare the contents. The
[restic practice exercise](../examples/restic-practice.md) walks through
exactly that. Then choose a destination outside the machine whose loss you
want to survive.
[Restic restore guide](https://restic.readthedocs.io/en/stable/050_restore.html).

For databases and games that are running, follow the application's own backup
procedure before copying its data. An **application-consistent backup** contains
data the application can use to recover correctly; copying files while they
are changing may not produce that result. Keep the backup password recoverable
separately from the server.

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

The step-by-step sequence lives in [Your first homelab](start-here.md#from-a-spare-computer-to-one-working-application):
one VM, then a start page, a monitor, a practice restore, and finally
automation. Keep experiments on your own test equipment and use the linked
project guides for installation details. When you reach the automation step,
practice on a new VM rather than assuming OpenTofu will adopt the one you
built by hand. Add game hosting after those foundations if it is useful to you.

To make your version reproducible, record these choices in your own private
notes:

- The software and provider versions you tested together.
- What each VM is for and the resources it needs.
- Which files describe creation, configuration, and application startup.
- Which data needs recovery, where its backups go, and how you tested a restore.

The result to aim for is a small service you can explain, monitor, and recover.
That is a useful foundation for deciding what to add next.

[Back to the homelab overview](../README.md) |
[Plan a first lab](start-here.md) |
[See the architecture overview](architecture.md) |
[Read the project walkthroughs](projects.md)
