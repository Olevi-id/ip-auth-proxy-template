#!/bin/bash

###
## Functions
#
update_configurations() {
    MY_URL=${MY_URL:='http://localhost:8080'}
    IDP_URL=${IDP_URL:=https://weare-staging.idp.youridentityplatform.biz}
    IDP_LOCAL_URL=${IDP_LOCAL_URL:=https://weare-staging.idp.youridentityplatform.biz}
    MY_CLIENT_SECRET=${MY_CLIENT_SECRET:=topsecret}
    MY_CLIENT_ID=${MY_CLIENT_ID:=auth-proxy}
    
    echo "**Updating config**\nMY_URL: ${MY_URL}\nIDP_URL: ${IDP_URL}\nIDP_LOCAL_URL: ${IDP_LOCAL_URL}\nMY_CLIENT_ID: ${MY_CLIENT_ID}"
    sed -i='' -e "s|<MY_URL>|${MY_URL}|g" /usr/local/apache2/conf/authn_openidc.conf
    sed -i='' -e "s|<MY_CLIENT_ID>|${MY_CLIENT_ID}|" /usr/local/apache2/conf/authn_openidc.conf
    sed -i='' -e "s|<MY_CLIENT_SECRET>|${MY_CLIENT_SECRET}|" /usr/local/apache2/conf/authn_openidc.conf
    sed -i='' -e "s|<IDP_URL>|${IDP_URL}|" /usr/local/apache2/conf/authn_openidc.conf
    sed -i='' -e "s|<IDP_LOCAL_URL>|${IDP_LOCAL_URL}|" /usr/local/apache2/htdocs/secret/index.html
    sed -i='' -e "s|<IDP_LOCAL_URL>|${IDP_LOCAL_URL}|" /usr/local/apache2/htdocs/customauth/index.html
    sed -i='' -e "s|<IDP_LOCAL_URL>|${IDP_LOCAL_URL}|" /usr/local/apache2/htdocs/index.html
    echo "**Updated config**"
}

###
## Script start
#
update_configurations
echo "** Starting Apache And Nodejs Server **"
exec node /opt/node/backend/src/server.js -D "FOREGROUND" & \
    exec /usr/local/bin/httpd-foreground
