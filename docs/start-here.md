# Your first homelab

A first homelab can be one computer running one useful application. Start by
choosing something you would like to use. You can learn the surrounding tools
as the project gives you a reason to need them.

If you are simply curious about mine, the [home page](../README.md) explains
what it does and why I built it. This page is for taking the next step toward
your own small setup.

## Pick one useful job

Here are three jobs drawn from this lab. Pick the one that interests you;
each builds a different kind of understanding.

| You would like to... | A small project to explore | What you learn |
| --- | --- | --- |
| Bring useful links together | A start page using Homepage | How to run a web application and change its settings. |
| Notice when your test application stops responding | Uptime Kuma watching that application | How to check a service and recognize an interruption. |
| Run a shared Minecraft world | A test Paper server | How game-server software, settings, and saved worlds fit together. |

The start page is the first application in the build sequence below. A game
server has more to look after, including its saved world and any plugins,
which are add-ons that change the game. The [tooling guide](tooling-guide.md)
explains these choices and links to their official instructions.

## A few words you will meet

| Word | What it means here |
| --- | --- |
| Service | An application that runs so you or another device can use it, such as a game server. |
| Operating system | The basic software that runs a computer. Debian is a Linux operating system used in this lab. |
| Virtual machine, or VM | A computer created in software, with its own operating system. Several can share one physical computer. |
| Container | A package for running an application with the software it needs. Containers share the core of the operating system they run on; mine run inside VMs. |
| Configuration | The settings that tell an application how to behave. Some tools keep these in text files. |
| Monitoring | Checking whether something responds, so an interruption is easier to notice. |
| Backup and restore | A backup is a separate copy of data. A restore brings data back from that copy so you can use it again. |
| Automation | Having software carry out steps you would otherwise repeat yourself. |

## From a spare computer to one working application

This follows a small part of my setup. It is a learning sequence; the linked
official guides supply the installation steps and current requirements.

1. **Prepare a place to experiment.** The route described here uses a spare
   computer for Proxmox VE, which creates and runs VMs. Installing it can erase
   existing data, so save anything you need and use a computer you are prepared
   to dedicate to the project. Start with [the foundation](tooling-guide.md#the-foundation).
2. **Get one Linux VM working.** Learn how to start, stop, and open that virtual
   computer's console: the screen where you can interact with its operating
   system. This gives you a place to try an application.
3. **Run a start page.** Docker runs application containers, and Compose records
   how to start them. Use the guide's [Docker setup](tooling-guide.md#docker-engine-and-compose-package-and-run-applications)
   and [Homepage example](tooling-guide.md#homepage-a-starting-page-for-your-services)
   to make a small page with a few useful links. Keep the first version simple
   enough that you understand each setting you change.
4. **Notice a stop and recovery.** Add [Uptime Kuma](tooling-guide.md#uptime-kuma-see-when-something-stops-responding)
   to watch that test page. Stop the test application, observe the check report
   it down, then start it and observe recovery.
5. **Practice bringing data back.** Begin with copies of disposable sample files
   and the [restic backup exercise](tooling-guide.md#restic-encrypted-backups-with-a-recovery-path).
   Then learn where your application saves its data and try its recovery on a
   separate test instance before relying on it for important information.

You have a useful first milestone when you can explain what your application
does, change a setting, notice when it stops, and recover the data it needs.

## What looking after it involves

Running an application includes installing updates, checking it still works,
and keeping useful data recoverable. A game world makes this concrete: the
server software may be replaceable, while the things people built in the world
are the data you want to keep.

Keep a short set of notes as you go: what you installed, why you chose it,
which settings you changed, and how you tested recovery. Leave passwords out of
those notes. Git is an optional way to keep a history of changes to your notes
from the start. When setup steps become repetitive, explore
[the automation tools](tooling-guide.md#making-setup-repeatable).

## Learn from the parts that needed fixing

My [project walkthroughs](projects.md) include a dashboard that needed missing
startup files and a game restore that needed an additional reinstall step.
They show how testing can turn an incomplete setup into a better procedure.
The [lessons page](what-i-learned.md) draws out ideas you can use in your build.

[Back to the homelab overview](../README.md) |
[Explore the tools and installation guides](tooling-guide.md) |
[See how my setup fits together](architecture.md)
