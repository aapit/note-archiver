# Note Archiver
A shell script that archives Markdown files from various folders with an 'archive' tag. It can be run from a cronjob, making sure your other notes always stay fresh.

________________________________________________________________________________

# Installation
## 1. Download this repository
```bash
$ git clone https://github.com/aapit/note-archiver.git
```

## 2. Create a config file from the provided template
```bash
$ cd note-archiver
$ cp archiver.template.config archiver.config
```

## 3. Fill out config
Set the correct configuration values for your situation in `archiver.config`

## 4. Run the script
```bash
$ chmod +x archive-notes.sh
$ ./archive-notes.sh
```

## 5. Set up a cronjob
We don't want to run this script manually, but instead have the cron daemon do the archiving automatically in the background.
Edit the crontab:
```bash
$ crontab -e
```
This opens your default editor and allows you to add this to the cron:
```bash
0 */4 * * * $HOME/Scripts/note-archiver/archive-notes.sh
```
Upon saving the crontab and exiting the editor, it's installed.
The cronjob above would run the script every 4 hours.

________________________________________________________________________________

# Usage
I use frontmatter headers in all my Markdown notes.
This allows me to store metadata in a more-or-less structured format.

```yaml
---
created:    20190812
updated:    20190815
author:     David
tags:       foo, bar, archive
---
```
When a `*.md` note in one of the provided directories has a tag `archive` like above (or `archief`) , it's considered up for archival and will be moved to the provided archive folder the next time the cronjob runs.
