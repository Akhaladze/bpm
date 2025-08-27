#!/bin/bash

pg_restore --host 10.20.20.82 --port 5432 --username=mbitadmin --dbname=bpm --no-owner --no-privileges --verbose bpm.backup
#pg_restore --host 127.0.0.1 --port 5432 --username=mbitadmin --dbname=bpm --no-owner --no-privileges --verbose --disable-triggers BPMonline815StudioNet6.backup
