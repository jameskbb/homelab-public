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
exercised, and one VM has been deliberately destroyed and rebuilt from its
definitions (see the next section). Restoring saved data into a freshly
rebuilt VM has not been exercised. Choosing data-level backup makes that gap
easy to forget.

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

## A traffic-light policy for changes

**The choice.** Every action on the lab is sorted into green, yellow, red, or
never by how hard it is to reverse. Green proceeds without asking, yellow
needs a stated undo and a yes, red needs a separate yes for each destructive
action, and never stays off the table.

**Why.** AI coding assistants help maintain the lab, and a script or a tired
person can make the same mistakes. Sorting by reversibility puts the friction
where the damage would be, and it makes backups part of the conversation
before anything is deleted.

**What it costs.** Routine changes take an extra sentence or two of
explanation, and unattended work needs a written plan approved in advance.
[Green, yellow, red: who may change what](change-permissions.md) has the
full explanation.

## Rebuild from code after a suspected compromise

**The choice.** If a VM is suspected of being compromised, or just needs
periodic cleaning, the answer is to destroy it and rebuild it from its
written definitions, not to restore its most recent backup. The experiments
VM was rebuilt this way in a deliberate drill on 2026-08-28, carrying no
previous state across, and every check passed on the fresh copy.

**Why.** A backup copies the directories where an application keeps its
state. That is exactly where unwanted persistent state would live, so
restoring the newest backup onto a suspect machine can restore the problem
along with the data. A backup is a data recovery tool. It is not an integrity
recovery tool, and using it as one gives false confidence. Everything except
the data is already described in Git, so a rebuild costs some minutes and the
loss of session history, not the loss of function.

**What it costs.** The decision about what to carry across has to be made
before the old VM is destroyed, not after. For routine cleaning, the newest
verified backup can be restored. For a suspected compromise, nothing is
carried across, or only a backup from before a known-good date, which is one
reason to keep older snapshots around. Credentials that were on the machine
have to be rotated separately; a rebuild does not do that for you.

**What it does not prove.** A rebuild of one VM says nothing about the
physical host beneath it. It also re-downloads the same pinned software, so a
compromised upstream release would be fetched again rather than filtered out.
Pinning by checksum narrows that risk to the pinned release itself.

## Retention that trims itself, with safety floors

**The choice.** Old offsite snapshots are removed by a scheduled job that
keeps a fixed number of daily, weekly, and monthly snapshots, then verifies
the repository. The job was enabled only after each VM had a passing restore
test, and reducing any of the keep counts is treated as a destructive change
that needs its own approval.

**Why.** The first version only uploaded and never deleted, and an earlier
draft of this decision argued for keeping it that way because storage was
cheap. That was overruled: retention that depends on a person remembering to
prune is retention that silently does not happen, and unbounded growth is
undesirable regardless of cost. Shrinking what gets uploaded in the first
place, by excluding reproducible files, had already cut the growth rate and
made the timing of this decision unhurried.

**What it costs.** An unattended job that deletes backup data is exactly the
kind of action the [permission policy](change-permissions.md) otherwise
treats as needing approval every time. So the job carries guards that do not
depend on the retention numbers being right:

- The most recent few snapshots are always kept, whatever the date rules say,
  so clock or time zone mistakes cannot empty the repository.
- The job refuses to prune a nearly empty repository. Very few snapshots is
  more likely a symptom of something wrong than something to tidy.
- A full dry run is logged immediately before the real deletion, so the log
  answers "what did it remove last week" without guesswork.
- The repository is verified in the same run, so damage is caught by the job
  that could have caused it.
- It does nothing at all if the repository is locked, missing, or fails to
  open.

**When the simpler option is fine.** If your backups are small and you
restore from them regularly, a manual prune after a reviewed dry run is a
reasonable place to start. Automate it once you have watched it run and read
what it would delete.

## A separate VM for an AI assistant that runs tools

**The choice.** The personal experiments VM exists largely to hold one AI
assistant that can read messages, run commands, and use tools on the
operator's behalf. It runs on its own VM with its own operating system, not
alongside the applications or the game servers, and never on the physical
host.

**Why.** An assistant like this handles untrusted content, executes tools, and
stores its own credentials. Its security model is closer to a server that
runs arbitrary code than to an ordinary dashboard. Sharing an operating
system with the applications VM would let a mistake by the assistant or one
of its plugins reach the start page and monitoring data. Sharing with the
games VM would put it next to game worlds and a container system that already
holds broad authority. A VM boundary keeps those mistakes contained, and the
VM can be rebuilt from its definitions on its own schedule, as the previous
section describes.

**How it starts small.** The first deployment listens only to itself, with no
public exposure, no reverse proxy, and no inbound messaging channel. No
credentials for the other VMs are copied into it. Command execution, file
changes, and other capabilities begin denied and are added one at a time,
each with a written reason. The software is installed at a pinned release
with automatic updates disabled, and its state has its own backup.

**What it costs.** One more operating system to patch, monitor, back up, and
document. Container access inside the VM is still powerful; the boundary
limits the damage a bad tool can do, but does not make one harmless. And
keeping the assistant reachable only from itself means every additional way
to talk to it is a separate decision.

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
