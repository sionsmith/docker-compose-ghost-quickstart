#!/bin/bash
echo "#########################################################################"
echo "## BACKUP GHOST BLOG - `date +%A` - `date +%Y-%m-%d_%Hh%Mm%Ss` ##########"
echo "#########################################################################"

DAY=$(date +%A)
FULLDATE=$(date -I)

echo "Creating Backup Folder..."
mkdir -p /home/backup/ghost

echo "Stopping Ghost Service..."
docker stop ghost

echo "Backing up Ghost Data Folder..."
tar -zcvf /home/backup/ghost/ghost-$FULLDATE.tar.gz /home/docker-compose-ghost-quickstart/dbdata

echo "Starting Ghsot Service..."
docker start ghost

echo "Uploading backup to S3..."
/usr/local/bin/aws s3 cp /home/backup/ghost/ghost-$FULLDATE.tar.gz s3://${ghost_resources_bucket}/backups/ghost-$FULLDATE.tar.gz

echo "## END BACKUP GHOST BLOG - `date +%A` - `date +%Y-%m-%d_%Hh%Mm%Ss` ##########"