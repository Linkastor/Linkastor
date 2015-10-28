#!/usr/bin/env bash

echo "Create production db snapshot..."
ssh ubuntu@23.253.148.61 "pg_dump -Fc -h localhost -p 5432 -U linkastor -d linkastor_production > /home/ubuntu/pg.dump"

echo "Download dump..."
scp ubuntu@23.253.148.61:/home/ubuntu/pg.dump db/pg.dump

echo "Reset local db..."
rake db:drop
rake db:create

echo "Restore local db..."
pg_restore -h localhost -p 5432 -U linkastor -d linkastor_development db/pg.dump