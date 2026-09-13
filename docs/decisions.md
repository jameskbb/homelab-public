# Why the lab is built this way

This page collects the choices behind the setup: what each one gives, what it
costs, and when a simpler option would serve you just as well. The reasons
are summarized from the lab's private decision records; the private records
also hold measurements and details that stay out of the public version.

One principle runs through most of these decisions: **rebuildable over
precious**. The virtual machines, their operating systems, and the software
they run should be recreatable from written definitions. Only the data people
care about, such as a game world or a monitor's history, needs to be
protected as something that cannot be recreated. Deciding which side of that
line something sits on settles many smaller questions.

## Virtual machines on Proxmox, not Docker directly on the desktop

**The choice.** The retired desktop runs Proxmox VE, and each job runs in its
own virtual machine (VM). Containers run inside those VMs.

**Why.** Proxmox is free, handles both VMs and containers, has a browser
interface, and has an OpenTofu provider, which made repeatable VM creation
possible later. Separate VMs give applications, games, and experiments their
own operating system and update schedule. Running Docker directly on the
desktop was considered and rejected because it offered no isolation between
jobs and no path to running software that does not come as a container.

**What it costs.** Three operating systems to update instead of one, and the
physical desktop remains a single point of failure for all of them. There is
no second machine, so no clustering or failover; recovery depends on being
able to rebuild.

**When the simpler option is fine.** If you want to run two or three
containerized applications and nothing else, Docker on a spare machine is
enough. Reach for VMs when you want different jobs to fail and update
independently, or when you want a place to practice rebuilding a whole
machine without touching the others.

## Compose for everyday applications, a management panel for games

**The choice.** The start page and monitor run from Docker Compose files.
Game servers run under Pterodactyl, which has its own web panel and runs each
game in a container it manages.

**Why.** The goal for games was to host several different ones over time
with little effort per server. Pterodactyl's reusable recipes, called eggs,
turn adding a game into a panel action rather than a new hand-written
definition each time. Its per-user permissions also let a friend manage
their own server without access to the VM. A single-game Compose setup was
considered and would have been simpler, but it is specific to one game and
would need to be repeated for each new one. A commercial panel was also
considered and rejected because its free tier caps the number of servers.

**What it costs.** The panel brings a database, a cache, a web server, and a
second always-on daemon, each needing updates and a backup plan. It is a
larger install and a larger surface to keep private than a Compose file.

**When the simpler option is fine.** For one Minecraft server, Paper on its
own, or a single-game container definition, is a perfectly good starting
point. The [tooling guide](tooling-guide.md#paper-the-minecraft-server-software)
suggests learning Paper first for that reason.

## OpenTofu and Ansible for three virtual machines

**The choice.** VM definitions are written for OpenTofu, and operating-system
configuration is written for Ansible. Neither is done by hand in the Proxmox
interface after the first experiments.

**Why.** A written definition can be reviewed, compared, and applied again.
The setup was proven on a disposable VM before any permanent one existed, and
a second configuration run reporting no changes became a routine check that a
machine still matches its definition. Keeping creation and configuration in
separate tools makes it clear which layer to change.

**What it costs.** Definitions, provider versions, and a state file to look
after. OpenTofu's state records everything it manages and can contain
sensitive values, so it needs private, recoverable storage. Automation also
front-loads effort: three VMs could be clicked together faster than they
could be defined.

**When the simpler option is fine.** With one VM, clicking through the
installer and keeping good notes is reasonable. Automate the steps once you
have repeated them and understand them, which is the order the
[first-lab page](start-here.md) suggests.

## Back up data, rebuild everything else

**The choice.** Backups cover application data and game worlds, not whole VM
disk images. Each VM is expected to be recreated from its definitions and
then have its data restored.

**Why.** Most of a VM's disk is the operating system, the runtime, and
downloaded software, all of which the definitions can put back. Whole-image
backups of that material would spend most of their space and cost on the
reproducible half. Proxmox's built-in whole-VM backup was considered and
remains an option to add later; it was not chosen as the main approach.

**What it costs.** Recovery needs to know what to reinstall. The
[Minecraft restore drill](projects.md#game-hosting-and-recovery) found that
a backup which deliberately excluded the server software needed a reinstall
step before the world was playable. Restores of selected data have been
exercised; rebuilding a whole VM from its definitions and then restoring into
it has not. Choosing data-level backup makes that gap easy to forget.

**A related detail.** Compressed archives defeat deduplication: a barely
changed world that is recompressed nightly looks like entirely new data to
the backup tool. Excluding reproducible files from the archive keeps each
upload closer to the size of what actually changed.

## Restic for offsite copies, on top of the application's own backup

**The choice.** Each application's own backup step produces a consistent
local copy first. Restic then encrypts that copy and stores it outside the
house. The first version only uploaded and never deleted; removing old
snapshots was a separate decision with its own safety limits.

**Why.** Restic encrypts on the machine before anything leaves it, so the
storage provider only ever holds ciphertext. It deduplicates, so repeated
backups of mostly unchanged data stay small, and it works with many storage
destinations. Letting the game panel upload its own backups directly was
considered and rejected because it would not encrypt client-side and would
cover only the game files, not the panel's own database and configuration.
Keeping the local backup as the consistency layer means a failed upload
never turns a good local backup into a failed one.

**What it costs.** Two more things that must never be lost: the storage
credential and the repository password. A forgotten restic password makes
every snapshot permanently unreadable, so it lives outside the lab. Recovery
also requires restic itself, not just an archive tool.

**When the simpler option is fine.** A copy on an external drive stored
elsewhere is a real offsite backup. Start there if a cloud destination feels
like too much, and practice restoring from it.

## Paper for Minecraft, with deliberate updates

**The choice.** Minecraft runs on Paper with the version pinned. Updates
happen on purpose: take a verified backup, change the pinned version, then
reinstall through the panel.

**Why.** Paper performs well, supports plugins, and keeps the ordinary game
experience for players. Pinning the version means a server does not jump to
a new game release on its own and break a world or a plugin overnight.

**What it costs.** Updates are a chore that someone has to choose to do, and
plugins have to be checked against each new version.

[Back to the homelab overview](../README.md) |
[See the architecture overview](architecture.md) |
[Read the project walkthroughs](projects.md) |
[Explore the tools](tooling-guide.md)
