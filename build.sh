#!/bin/bash

rm -rf -- build/core/
unzip -d build/core build/src/8.2.3.1351_StudioNet8_Softkey_PostgreSQL_ENU.zip
cp build/core/db/*.backup bpm.backup
docker compose build
docker login registry.mbit-consultants.com
docker tag bpm registry.mbit-consultants.com/mbit/bpm:studio-latest
docker push registry.mbit-consultants.com/mbit/bpm:studio-latest
docker compose restart

# curl -X POST "https://portainer.mbit-consultants.com/api/stacks/webhooks/83194ec1-39de-4519-ac34-5f0619a53c36"
