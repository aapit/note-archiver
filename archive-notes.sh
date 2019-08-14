#!/bin/bash
# @description This script archives Markdown notes that are tagged with 'archive'
# @author David Spreekmeester <@aapit>

# Read config _________________________________________________________________
. archiver.config

# Print output ________________________________________________________________
pr() {
    # $1 = string to display
    # $2 = prefix sign, like '!'
    # $3 = color code for prefix (int)
    [ -z "$2" ] && prefix="  " || prefix="$2 ";
    [ -z "$3" ] || prefix="\e[${3}m${prefix}\e[39m"
    echo -e "\t${prefix}${1}"
}
approve() {
    pr "$1" ✓ 32
}
warn() {
    pr "$1" ! 31
}

# Handle notes ________________________________________________________________
count_notes() {
    # $1 = Dir
    local result=$(/bin/ls -1 ${1}/*.md | wc -l)
    echo "$result"
}
list_archive_notes() {
    # $1 = Dir
    local result=$(grep -E -l "${PATTERN}" ${1}/*.md)
    echo "$result"
}
count_archive_notes() {
    # $1 = Dir
    local archive_list=$(list_archive_notes ${1})
    local archive_count=$(echo "${archive_list}" | wc -l)
    [ -n "${archive_list}" ] \
        && echo ${archive_count} \
        || echo "0"
}
archive_notes() {
    # $1 = Dir
    local archive_list=$(list_archive_notes ${1})
    while read -r file; do
        local basename=$(basename "$file")
        mv "${file}" "${BACKUP_FOLDER}/" \
            && approve "Archived \e[34m'${basename}'\e[39m"
    done <<< "$archive_list"
}

# Main loop ___________________________________________________________________
walk_folders() {
    for i in ${NOTES_FOLDERS[@]}; do
        echo "${i}"
        pr "$(count_notes ${i}) notes"
        archive_note_count="$(count_archive_notes ${i})"
        if [ "$archive_note_count" -gt "0" ]; then
            [ "$archive_note_count" -eq "1" ] \
                && local nounverb="Note needs" \
                || local nounverb="Notes need"
            warn "$archive_note_count ${nounverb} archiving"
            [ -w "${BACKUP_FOLDER}" ] \
                && archive_notes ${i}
        else
            approve "All fresh"
        fi
    done
}

walk_folders
