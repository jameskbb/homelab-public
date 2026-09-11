# My homelab

I turned a retired desktop into a home server for everyday applications, game
worlds for friends, and personal experiments. Along the way, I built repeatable
setup workflows, added service monitoring, and practiced recovering application
and game data from backups.

A **homelab** is a computer environment run at home for learning and useful
personal projects. This repository explains what I built, the tools behind it,
and the checks that helped me understand whether it worked. It is a public
project walkthrough, with enough context for someone who has never run a server.

**Documentation snapshot: September 2026.** Results here describe recorded
build and recovery exercises, not live service status.

## The setup at a glance

The physical server is a Dell OptiPlex desktop with an Intel i7 processor,
32 GB of memory, and two internal drives. Proxmox VE lets that one computer run
several **virtual machines (VMs)**: separate computers implemented in software,
each with its own operating system.

| Environment | What it does | Main tools |
| --- | --- | --- |
| Applications | A starting page for services and checks that they respond | Debian, Docker Compose, Homepage, Uptime Kuma |
| Games | A management panel and Minecraft and cooperative-game servers | Debian, Pterodactyl Panel and Wings, Paper |
| Personal experiments | A separate place for private automation and AI experiments | Its own Debian VM |

OpenTofu, cloud-init, and Ansible handle VM creation and configuration. Git
records changes to the setup. Restic provides encrypted offsite backups for
selected data. The [architecture overview](docs/architecture.md) explains how
these responsibilities fit together.

Separate VMs give each workload its own operating system, but all three still
depend on the same physical server. Selected-data restore exercises do not
establish recovery of the entire host.

## Selected project work

The interesting part is the work connecting the tools: defining a machine,
configuring it, running something useful, and checking recovery.

| Project | What I built and checked | Read the walkthrough |
| --- | --- | --- |
| Repeatable server setup | A reusable Linux starting point, VM definitions, and configuration tasks; checked disposable VM creation and removal and repeat configuration runs | [From definitions to a working VM](docs/projects.md#repeatable-server-setup) |
| Everyday applications and monitoring | Separate application definitions for a start page and monitoring; observed an actual interruption and recovery | [Run a service and check it](docs/projects.md#everyday-applications-and-monitoring) |
| Game hosting and recovery | Managed game environments and selected-data backups; completed restore drills for two Minecraft environments | [Recover the data that matters](docs/projects.md#game-hosting-and-recovery) |

Together, these projects demonstrate Linux administration, infrastructure as
code (describing machines in text), application deployment, monitoring, recovery
testing, and technical documentation. The walkthroughs explain the decisions,
recorded results, and limits behind those skills.

## Explore the repository

| If you want to... | Start here |
| --- | --- |
| Understand the design and its tradeoffs | [Architecture overview](docs/architecture.md) |
| See concrete work and how it was checked | [Project walkthroughs](docs/projects.md) |
| Find the tools, official guides, and a first build sequence | [Tooling guide](docs/tooling-guide.md) |
| Read the practical lessons | [What I learned](docs/what-i-learned.md) |
| Prepare your own documentation for public sharing | [Publishing checklist](docs/before-you-publish.md) |

For a first build, the tooling guide starts with one Linux VM, a simple
application, monitoring, and a practice restore. Add automation after you
understand the steps you want to repeat.

## About the public version

These are curated explanations of the setup. Operational configuration and
detailed records are maintained separately. Credentials, service addresses,
network details, and recovery material stay private. Public diagrams show
responsibilities without mapping the actual network.

Use the walkthroughs and official project guides to build your own version;
this repository is not a deployment package. My blog lives separately and may
link here for setup documentation and tooling references.

## License

Unless a file says otherwise, the written content and diagrams in this
repository are available under the [Creative Commons Attribution 4.0
International license](https://creativecommons.org/licenses/by/4.0/).
