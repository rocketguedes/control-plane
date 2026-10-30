#!/bin/sh
set -e

./occ config:system:set allow_local_remote_servers --type=bool --value=true
./occ background:cron
./occ app:install richdocuments || ./occ app:enable richdocuments
./occ config:app:set richdocuments wopi_url --value="https://office.guedescloud.com.br"
./occ config:app:set richdocuments wopi_allowlist --value="163.176.153.241,2603:c021:c00d:5900:0:7470:66db:a442,10.42.0.0/16,fd42::/56,10.43.0.0/16,fd43::/112,127.0.0.1,::1"
./occ richdocuments:activate-config
./occ app:install user_oidc || ./occ app:enable user_oidc
./occ user_oidc:provider authelia --clientid=nextcloud --clientsecret="${OIDC_CLIENT_SECRET}" --discoveryuri="https://accounts.guedescloud.com.br/.well-known/openid-configuration" || true
./occ app:disable dashboard || true
./occ db:add-missing-indices --no-interaction || true
./occ maintenance:repair --include-expensive || true
