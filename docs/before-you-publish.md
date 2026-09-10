# Public sharing checklist

Use this checklist before adding a screenshot, photo, diagram, log excerpt, or
documentation update. A public repository is easy to copy and difficult to take back.

## Check the content

1. Remove internal IP addresses, hostnames, domain names, live links, and port
   numbers.
2. Remove usernames, email addresses, account IDs, tokens, passwords, QR
   codes, keys, and recovery codes.
3. Crop screenshots to exclude browser tabs, bookmarks, notifications, file
   paths, timestamps, and network details.
4. Replace exact storage sizes, software versions, and service names when they
   would reveal more detail than the explanation needs.
5. Do not include configuration exports, logs, backup archives, command
   histories, or infrastructure state files.

## Check the explanation

Ask whether a reader can learn something useful without being able to identify
the home, the network, or a route into the lab. If the answer is yes, the
content is probably ready for this repository.

## A safe screenshot pattern

For a dashboard screenshot, use a duplicate or carefully redacted view. Show
the category of service and its general health, but hide the browser address,
names that identify people, and any detail that could be used to reach a
service. Review the image at full size before committing it.

## If you are unsure

Leave it out. You can always add a safely redacted version later. Once a secret
or private network detail is public, removing it from the current file does not
remove copies, caches, or repository history.
