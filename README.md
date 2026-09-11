# My homelab

This is a guide to the small home server I built from a retired desktop:
what I use it for, why the pieces are there, and what you could try in your own
setup. If a friend sent you this and you have never run a server, start here.

## What is a homelab?

A **server** is a computer that provides something for other devices to use,
such as a web page or a shared game world. A **homelab** is a computer setup
used for learning and personal projects, usually at home. Mine runs useful
applications, games for friends, and experiments.

**Self-hosting** means running and maintaining an application yourself. In this
lab, the applications run on my own computer. That also makes updates, backups,
and troubleshooting part of the job.

## Why I built mine

The lab gives useful projects a place to run and gives me a reason to learn how
they work. A shared Minecraft world, a page that brings my services together,
and a way to notice when something stops responding each solve a small,
understandable problem.

Those projects also create practical things to learn: setting up a computer,
making a change without losing its data, and bringing an application back from
a backup. The learning comes from looking after something I actually use.

## What it does day to day

| Part of the lab | What it is useful for |
| --- | --- |
| A start page | Puts links to my services in one place so they are easier to find. |
| Service monitoring | Checks whether applications and games respond, helping me notice interruptions. |
| Game hosting | Runs Minecraft and cooperative-game servers, giving friends a shared place to play. |
| Personal experiments | Provides a separate environment for trying private automation and AI projects. |
| Backups and recovery practice | Keeps copies of selected application and game data and tests how to bring them back. |

The start page uses **Homepage**, and the monitor uses **Uptime Kuma**. Those are
two approachable examples to explore in the [tooling guide](docs/tooling-guide.md#everyday-services-and-recovery).
The game setup uses Pterodactyl for management and Paper for Minecraft; their
roles are explained in [the game-hosting section](docs/tooling-guide.md#game-hosting).

## How one computer handles the different jobs

The hardware is a Dell OptiPlex desktop with an Intel i7 processor, 32 GB of
memory, and two internal drives. Software called **Proxmox VE** lets it run
several **virtual machines (VMs)**: computers created in software, each with
its own operating system.

I use one VM for applications, one for games, and one for personal experiments.
That gives their settings and updates separate places to live. They still share
the physical desktop, so a problem with that computer can affect all three.
The [architecture overview](docs/architecture.md) has a diagram and explains
the tools that connect the pieces.

## If you want to build your own

Start with one thing you would enjoy using, then learn what it takes to run and
look after it. My setup grew to cover several jobs; your first project can be
much smaller.

Read [Your first homelab](docs/start-here.md) for a small starting project,
the words you will encounter, and a path from a working application to a
practice restore. It leads into the installation references when you are ready.

## Where to go next

| What you are curious about | Read this |
| --- | --- |
| Where to start with a first lab | [Your first homelab](docs/start-here.md) |
| How the different parts fit together | [Architecture overview](docs/architecture.md) |
| What happened while building and fixing things | [Project walkthroughs](docs/projects.md) |
| Which tools I used and where to learn them | [Tooling guide](docs/tooling-guide.md) |
| What I would carry into another build | [What I learned](docs/what-i-learned.md) |

## About the public version

These notes describe work recorded through September 2026, rather than live
service status. They explain the setup and lessons so others can build their
own version. Operational configuration and detailed records are maintained
separately. Credentials, service addresses,
network details, and recovery material stay private. Public diagrams show
responsibilities without mapping the actual network.

For installation, follow the official guides linked from the tooling page and
choose settings for your own equipment. My blog lives separately and may link
here for setup documentation and tooling references.

If you are adding public notes or images, use the
[publishing checklist](docs/before-you-publish.md).

## License

Unless a file says otherwise, the written content and diagrams in this
repository are available under the [Creative Commons Attribution 4.0
International license](https://creativecommons.org/licenses/by/4.0/).
