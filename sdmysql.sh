#!/bin/bash
#
# This script is written by me XD
# written to be used on debian plesk servers 
# to be invoked by cron job daily
# change date parameter if you need a backup per hour or minute
# licensed under gplv3

mkdir -p /private-backup; cd /private-backup; if [ -f "dumpmysql.db.01.oldest.gz" ]; \
then if [ -f dumpmysql.db.fom.*.gz ]; then echo "iffirst"; rm dumpmysql.db.fom.*.gz; fi; mv dumpmysql.db.01.oldest.gz dumpmysql.db.fom.$(($(date +%Y%m%H%M)-10000)).gz; fi;\
if [ -f dumpmysql.db.*.previous.gz ]; then PREVIOUSFILE=$(ls dumpmysql.db.*.previous.gz); \
mv dumpmysql.db.${PREVIOUSFILE:13:2}.previous.gz dumpmysql.db.${PREVIOUSFILE:13:2}.oldest.gz; else echo $PREVIOUSFILE "<-NPRFILE"; fi; \
if [ -f dumpmysql.db.*.latest.gz ]; then LATESTFILE=$(ls dumpmysql.db.*.latest.gz); \
mv dumpmysql.db.${LATESTFILE:13:2}.latest.gz dumpmysql.db.${LATESTFILE:13:2}.previous.gz; else echo $LATESTFILE "<-NLRFILE"; fi; \
MYSQL_PWD=`cat /etc/psa/.psa.shadow`; mysqldump -x --all-databases -u admin -p$MYSQL_PWD | gzip > dumpmysql.db.$(date +%d).latest.gz;


#if [ -f "dumpmysql.db.01.oldest.gz" ]; then if [ -f "dumpmysql.db.fom.*.gz" ]; then rm dumpmysql.db.fom.*.gz; else mv dumpmysql.db.01.oldest.gz dumpmysql.db.fom.$(date +%Y%m).gz; fi; fi; if [ -f dumpmysql.db.*.previous.gz ]; then PREVIOUSFILE=$(ls dumpmysql.db.*.previous.gz); mv dumpmysql.db.${PREVIOUSFILE:13:2}.previous.gz dumpmysql.db.${PREVIOUSFILE:13:2}.oldest.gz; else echo $PREVIOUSFILE "<-NPRFILE"; fi; if [ -f dumpmysql.db.*.latest.gz ]; then LATESTFILE=$(ls dumpmysql.db.*.latest.gz); mv dumpmysql.db.${LATESTFILE:13:2}.latest.gz dumpmysql.db.${LATESTFILE:13:2}.previous.gz; else echo $LATESTFILE "<-NLRFILE"; fi; MYSQL_PWD=`cat /etc/psa/.psa.shadow`; mysqldump -x --all-databases -u admin -p$MYSQL_PWD | gzip > dumpmysql.db.$(date +%d).latest.gz
