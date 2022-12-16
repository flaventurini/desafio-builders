#!/bin/bash

############################### configuration ################################
SOURCE=$1
DESTINATION=$2
DRYRUN=$3
BOTO_CONFIG="~/.boto"

# Google storage utility (requires full path, ~/gsutil/gsutil: No such file or directory).
GSUTIL="$(which gsutil)"

# gsutil sends confirmation messages to stderr.  The quite option -q suppresses confirmations.
# if not dryrun
if [[ "$DRYRUN" != "-n" ]]
then
    GSUTIL="$GSUTIL -q"
fi

# Exclude patterns are Python regular expressions (not wildcards).
EXCLUDES='.+\.exe$'

############################ directories to backup ##########################
# Backup files in ~/ home directory
$GSUTIL rsync $DRYRUN -c -C       $SOURCE $DESTINATION

############################### confirmation #################################
# if not dryrun
if [[ "$DRYRUN" != "-n" ]]
then
    CONFIRMATION="$(date) $SOURCE  to  $DESTINATION  $DRYRUN"
    echo $CONFIRMATION >> ~/backup.log
    echo $CONFIRMATION
fi