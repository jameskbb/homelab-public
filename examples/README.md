# Worked examples

These files show the shape of the configuration used in this lab. Every
value in them is fictional: host names end in `.example`, names are generic,
and sizes are small enough for a practice VM. None of these files is copied
from the running lab, and none will work unchanged. Read the comments, then
adapt the values to your own equipment and the official documentation linked
from the [tooling guide](../docs/tooling-guide.md).

| Example | What it shows | Used in |
| --- | --- | --- |
| [start-page-and-monitor](start-page-and-monitor/) | One Docker Compose file that runs Homepage and Uptime Kuma, plus a small Homepage links file | [Your first homelab](../docs/start-here.md), steps 3 and 4 |
| [repeatable-setup](repeatable-setup/) | An OpenTofu definition for one VM and an Ansible playbook that configures it, showing how the two jobs stay separate | [Your first homelab](../docs/start-here.md), step 5 |
| [restic-practice.md](restic-practice.md) | A backup and restore exercise on disposable sample files | [Your first homelab](../docs/start-here.md), step 5 |

Two habits apply to all of them. Keep secrets out of files you might share:
passwords, keys, and tokens belong in environment variables or a secret
store, never in the example files. And treat each example as a starting
point to understand, not a finished setup to trust.

[Back to the homelab overview](../README.md)
