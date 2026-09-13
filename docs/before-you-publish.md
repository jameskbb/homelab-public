# Public sharing checklist

Use this checklist before adding a screenshot, photo, diagram, or
documentation update. A public repository is easy to copy and difficult to take back.

## Check the content

1. Remove real IP addresses, internal hostnames, personal domains, live service
   links, port mappings, and administration paths. Official software project
   and documentation links are useful references and can stay.
2. Remove usernames, email addresses, account IDs, tokens, passwords, QR
   codes, keys, and recovery codes.
3. Crop screenshots to exclude browser tabs, bookmarks, notifications, file
   paths, timestamps, and network details.
4. Replace exact storage sizes, software versions, and service names when they
   would reveal more detail than the explanation needs.
5. Do not include configuration exports, logs, backup archives, command
   histories, or infrastructure state files.
6. Inspect image metadata as well as visible content. Remove location data,
   device identifiers, and identifying filenames before adding an image.

## Check the explanation

Explain what the project does and why a choice matters before listing tools.
Keep claims tied to recorded work: a planned service is still a plan, a passing
monitor is not a complete functional test, and a selected-data restore does not
establish recovery of an entire server. Date results when that context matters.

Check that a reader can learn something useful without identifying the home,
the network, or a route into the lab. Keep diagrams conceptual and label
fictional examples. Review the complete change and check its document links
before publishing. The repository's automated checks look for broken links
and obvious secrets on every push. They support this review; they cannot
prove that a file is safe to share.

## A safe screenshot pattern

For a dashboard screenshot, prefer a separate demonstration view with fictional
service names and sample data. Label it as an example. If using an actual
capture, remove identifying content, including the browser address and names
that identify people. Export a flattened image so covered text cannot be
uncovered by removing an editing layer, inspect its metadata, and review the
final image at full size before committing it.

## If you are unsure

Leave it out. You can always add a safely redacted version later. Once a secret
or private network detail is public, removing it from the current file does not
remove copies, caches, or repository history.

[Back to the homelab overview](../README.md)
