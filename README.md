# My homelab

A small home server built from a retired desktop computer. It hosts a few useful
services, game worlds for friends, and private experiments. This repository is
the public, human-readable version of the project: the ideas, tradeoffs, and
lessons, without the information someone could use to find or administer it.

## What is a homelab?

A homelab is a small computer environment run at home for learning and useful
personal projects. Mine is not a business or a public cloud. It is a place to
learn by building something real, while keeping the blast radius small.

## The setup at a glance

| Piece | Plain-English job |
| --- | --- |
| Dell OptiPlex desktop | The physical computer. It has an Intel i7 processor, 32 GB of memory, and two internal drives. |
| Proxmox VE | The software that lets one physical computer act like several separate computers. |
| Applications environment | Runs a simple start page and health monitoring for the services I rely on. |
| Games environment | Runs a game-management panel plus Minecraft and cooperative-game servers. |
| Personal experiments environment | Keeps private automation and AI experiments separate from the other workloads. |
| Backups and restore practice | Protects important data with automated backups and regular recovery drills. |

The hardware is intentionally ordinary. The point is to show that a useful
learning environment does not need a rack, enterprise hardware, or a huge
budget.

## How the pieces fit together

```text
One small desktop computer
        |
        v
Virtualization platform
        |
        +-- Everyday apps and monitoring
        +-- Game servers for friends
        +-- Isolated personal experiments
        |
        v
Backups, health checks, and restore practice
```

Each workload gets its own virtual computer. That makes the setup easier to
understand and means an experiment is less likely to disturb games or everyday
services.

## Principles that guide the project

1. Start with a small, useful problem. The first wins were a home dashboard,
   basic monitoring, and a Minecraft server.
2. Keep jobs separate. Apps, games, and experiments should not all depend on
   one operating system.
3. Automate repeatable work. Rebuilding or updating something should be a
   documented process, not a memory test.
4. Practice recovery. A backup is only reassuring after a restore has worked.
5. Share carefully. Public write-ups should explain the idea without exposing
   the route into the lab.

## What this repository is, and is not

This is a snapshot for people who want inspiration for a first homelab or a
blog post about learning in public. It is not an installation guide and it does
not contain production configuration.

- Start with [the architecture overview](docs/architecture.md) for the shape
  of the setup.
- Explore [the tools behind the lab](docs/tooling-guide.md) for OpenTofu,
  Uptime Kuma, and the other software, with first projects and official guides
  for building your own version.
- Read [what I learned building it](docs/what-i-learned.md) for the practical
  takeaways.
- Use [the publishing checklist](docs/before-you-publish.md) before adding a
  screenshot, diagram, or new story.

## Deliberately not public

This repository contains no passwords, tokens, private keys, internal IP
addresses, hostnames, DNS records, live service links, port-forwarding details,
network diagrams, backups, or infrastructure state. The real configuration is
kept separately and stays private.

If you are making your own public homelab repository, begin with the same rule:
share the story and the lessons, not the map to your front door.

## License

Unless a file says otherwise, the written content and diagrams in this
repository are available under the [Creative Commons Attribution 4.0
International license](https://creativecommons.org/licenses/by/4.0/).
