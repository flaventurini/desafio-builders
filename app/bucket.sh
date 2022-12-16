#!/bin/bash

################################### usage ####################################
# Option "-n" is "dry run".  Dry run example:
#   $ ~/test_source/backup_script ~/test_source/ gs://wolfv-backup-tutorial -n
# Real backups omit the third argument.  Live run example:
#   $ ~/test_source/backup_script ~/test_source/ gs://wolfv-backup-tutorial
# Example cron job that backs up twice a day at 03:52 and 15:52:
#	$ crontab -e
#	52 03,15 * * * ~/test_source/backup_script ~/test_source/ gs://wolfv-backup-tutorial

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
$GSUTIL rsync $DRYRUN -c -C       $SOURCE/ $DESTINATION/

############################### confirmation #################################
# if not dryrun
if [[ "$DRYRUN" != "-n" ]]
then
    CONFIRMATION="$(date) $SOURCE  to  $DESTINATION  $DRYRUN"
    echo $CONFIRMATION >> ~/test_source/backup.log
    echo $CONFIRMATION
fi


#gsutil cp -n /logs-app/*.txt gs://bucket-devsecops-builders