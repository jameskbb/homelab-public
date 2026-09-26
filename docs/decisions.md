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
possible later. Separate VMs give applications, games, experiments, and
automated test jobs their own operating system and update schedule. Running
Docker directly on the desktop was considered and rejected because it offered
no isolation between jobs and no path to running software that does not come
as a container.

**What it costs.** Four operating systems to update instead of one, and the
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

## OpenTofu and Ansible for the virtual machines

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
front-loads effort: the first three VMs could have been clicked together
faster than they could be defined, and the payoff arrived later, when a
fourth VM was added from the same patterns.

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

## A weekly reboot that refuses when unsure

**The choice.** The whole lab, the physical host and every VM, restarts once
a week, overnight, with nobody awake. It is one narrow, reviewed exception to
the rule that rebooting the physical host is red; the
[permission policy](change-permissions.md#red-destructive-one-approval-per-action)
explains how it was approved and what still needs approval.

**Why.** The operator wanted a routine restart of everything, not one that
only happens in an emergency. Approving the rules once, carefully, is the only
way to do that with nobody awake.

**How it stays safe.** Before rebooting, a script checks that it is on the
right machine, on mains power, with core services healthy, no failed services,
storage active, no task running, and exactly the set of VMs it may reboot
running, each set to start at boot and answering through its guest agent (a
small helper inside the VM). Game players get a warning first. If any check
fails, that week is skipped; it never forces a VM down or catches up later.
After boot, a second check records any VM that did not come back. To fit
around it, a backup job moved earlier and game servers now start at boot.

**What actually happened.** The first two scheduled runs refused because the
check itself had a bug (an invalid command option), so nothing was rebooted:
the fail-safe working as designed. It was fixed on 2026-09-12. Adding the
fourth VM meant updating the set of VMs it may reboot. No completed weekly
reboot is recorded yet.

**What it costs.** The monitor lives on the physical host too, so it cannot
alert anyone during the reboot, and a reboot installs no updates.

**When the simpler option is fine.** Rebooting by hand after updates, while
you watch, is perfectly reasonable.

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

## A separate VM for automated test jobs

**The choice.** A fourth VM, the test jobs VM, runs test and build jobs for
the operator's private code using GitHub Actions self-hosted runners. A runner
is a small program that connects out to GitHub, waits for a queued job, and
runs its steps locally, with no inbound port and no router change. A real job
ran end to end on 2026-09-20. Docker access for jobs was added on 2026-09-26
for a Minecraft plugin test project (a locked-down test server in a container,
with bots playing scenarios); that project's first real job is still pending.

**Why.** Every workflow step is code that runs on the machine, and the other
VMs hold monitoring secrets, game worlds, and the AI assistant's credentials;
like the experiments VM, it gets its own boundary. There is one runner per
repository, because a personal GitHub account supports nothing broader. Each
runner takes exactly one job, then registers again fresh, so no job inherits
the previous job's working files.

**Private repositories only, enforced in code.** Each runner checks that its
repository is private before starting, and a regular check stops any runner
whose repository has become public. On a public repository, a pull request
from a stranger's copy (a fork) could run the stranger's code on the home
network. The access token the runners use is narrowly scoped and stored
encrypted, never in Git.

**What it costs.** The home network is flat by policy, so a job can reach the
other machines; that is accepted only because the repositories are private.
Docker access gives every repository's jobs effectively full administrator
access to the test jobs VM, and Docker images and caches outlive jobs; a
weekly cleanup limits growth but is not isolation. The
physical host's memory is now nearly all reserved across the four VMs, and
resizing the test jobs VM needed a restart.

**When the simpler option is fine.** GitHub's own hosted runners need no
maintenance and never touch the home network.

## Private remote access without opening the router

**The choice.** Tailscale provides access to the lab from away from home. It
builds an encrypted private network between your own devices; each device
connects outward, so there is no port forward and no router change. It was
chosen on 2026-08-30 and applied on 2026-09-12. Only the VMs joined. The
physical host deliberately did not, and only the operator's own
devices are on it. The home network stays the primary path, Tailscale sits
alongside it, and the physical console is the final fallback.

**Why.** Keeping the physical host off means a stolen phone with a live
session cannot reach the machine that can delete every VM. A "subnet router",
one VM sharing access to the whole home network, was the least work and was
rejected: on a flat network, one compromised device would expose everything in
the house. The setup automation refuses to run on the physical host and
refuses to share routes or act as an exit node (a device that forwards all
your internet traffic).

**What it costs.** Fixing the physical host still means being at home. Device
keys expire by default, months later, and a device then silently drops off;
expiry was turned off on the server VMs, and the automation checks it on every
run.

**Where it stands.** The access rules currently let administrative
connections reach only the experiments VM and the admin computer; the
applications and games VMs accept nothing over it yet. A test from away from
home is not recorded yet.

**When the simpler option is fine.** If you only need the lab while you are
home, you do not need remote access at all.

## Letting friends join games from outside

**The choice.** Friends reach a game server through a name that follows the
home internet address, plus a router port forward for that one server. A home
address can change, so a small updater (a container on the applications VM)
keeps a public name (a DNS record, the internet's address-book entry) pointed
at the current address. It makes only outbound calls, and the monitor flags it
if updates stop. It was applied on 2026-08-18.

**Why.** A name on its own exposes nothing; the port forward is what lets
outside traffic reach a single game server. Players reach only the game
ports they are given, never the administrative network, which is Tailscale's
job and for the operator only.

**What it costs.** Router changes are on the never list for automation and
AI assistants, so the operator makes them by hand, and the lab notes record
them as reported by the operator rather than independently verified.
Forwards exist for some of the cooperative games; join tests from outside
the house are not recorded yet. Every forward is a door to one server that
has to be kept updated.

**When the simpler option is fine.** If everyone plays from inside the
house, you need no forwards at all.

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
