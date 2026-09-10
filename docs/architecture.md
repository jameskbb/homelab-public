# Architecture overview

This is a purposefully simplified view of the lab. It describes roles, not
addresses, routes, ports, account names, or access methods.

```text
                         Home network
                              |
                              v
                 +-------------------------+
                 |   Small desktop server  |
                 |      Proxmox VE host    |
                 +-------------------------+
                    |          |          |
                    v          v          v
              +---------+ +---------+ +---------+
              |  Apps   | |  Games  | | Personal|
              |         | |         | |experiments|
              +---------+ +---------+ +---------+
                    |          |          |
                    +----------+----------+
                               |
                               v
                  Monitoring, backups, recovery
```

## Why virtual computers?

The desktop runs three virtual computers. Think of each as its own apartment in
the same building. They share physical hardware but have separate operating
systems, storage, and responsibilities.

| Environment | What it is for | Why it is separate |
| --- | --- | --- |
| Apps | A home dashboard and service monitoring | Everyday services can stay stable while other projects change. |
| Games | Game management plus Minecraft and cooperative games | Game updates and player activity have their own space and storage. |
| Personal experiments | Private automation and AI experiments | Higher-risk experimentation does not share an operating system with the apps or games. |

## The operating rhythm

The build is managed as a small set of layers:

```text
Document the intended change
        -> Create or adjust a virtual computer
        -> Configure its operating system
        -> Run the service
        -> Monitor it and test recovery
```

This sequence is less exciting than clicking around until something works, but
it makes changes easier to repeat and easier to explain later.

## Boundaries that matter

The lab is designed for private use. Administrative services stay private, and
anything that might be shared with friends is treated as a separate decision.
The public version of the project never publishes the details that identify the
home network or provide an administration path into it.

## What I would change next time

I would still begin with one physical computer and separate workloads early.
The biggest improvement would be deciding what needs a backup and performing a
small restore test before adding more services. It is much easier to build that
habit with two services than with twenty.
