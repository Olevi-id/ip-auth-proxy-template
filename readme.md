OIDC Relying Party (RP) Template
===============================

This tool can be placed in front of an application as reverse HTTP Proxy to protect the application with authentication using Identity Provider (OIDC OP i.e. [OpenId Connect](https://openid.net/specs/openid-connect-core-1_0.html) Provider) e.g. 
[shibboleth-idp-dockerized](https://github.com/klaalo/shibboleth-idp-dockerized).

It is always best if the application supports OIDC out of the box, but as that is not always the case, one can use authenticating proxy in front of the service/application acting as Policy Enforcement Point (PEP) to make decisions in access and authorisation.

## Standing on the shoulders of giants

We invented almost nothing ourselves. This tool is based:

* <https://httpd.apache.org>
* <https://github.com/zmartzone/mod_auth_openidc>

## Demonstration only

This is only an example of one possible way of protecting an application with authentication.

You should evaluate every aspect of this tool **VERY CAREFULLY** before using in production. This is only a demonstration on how to protect your application with authentication. This tool *does not* consider all aspects of information security, but you need to have a hold on your own implementation and deployment.

There is an online demo at: <https://weare-test.testbed.youridentityplatform.biz>

## Running

### Build locally

    docker build -t auth-proxy .
    docker run --rm -p 8080:80 --name auth-proxy auth-proxy

By default, the container is set to access WeAre Demonstration IdP instance. The entrypoint script overwrites values in configuration, so even after building the image it is possible to run the proxy with different configuration set. You can override the built in values e.g. by specifying them on command line:

    docker run --rm -p 8080:80 \
        --env IDP_URL=http://host.docker.internal \
        --env IDP_LOCAL_URL=http://localhost \
        --env MY_CLIENT_ID=auth-proxy \
        --name auth-proxy auth-proxy

Alternate method to allow access to IdP running on localhost:

    docker run --rm -p 8080:80 \
        --add-host idp:172.17.0.1 \
        --env IDP_URL=http://idp \
        --env IDP_LOCAL_URL=http://localhost \
        --env MY_CLIENT_ID=your-client-id \
        --name auth-proxy auth-proxy

Make note that you need to make the host network visible to the container with the made up name so that it can 
interact with the identity broker running locally in another container. Above is two methods to accomplish that. 
See [this](https://docs.docker.com/desktop/networking/) Docker Desktop documentation page.

### Run from Dockerhub

    docker run --rm -p 8080:80 klaalo/ip-auth-proxy-template:main

## TODO: Authentication method selection

The rp sets acr_values in OIDC request to give a hint to the IdP about the preferred authentication method. 
Currently, this is done using path selection and configuration in the mod_authn_openidc. 
The authn module [brings a new feature](https://github.com/zmartzone/mod_auth_openidc/wiki) in version 2.3.11rc1, 
where similar result can be achieved with query parameter. That is much more convenient approach, 
but as the current HTTPD docker image doesn't have the latest version of the authn module, 
we'll have to use more clonky method.

The previous was written with different FROM Docker image, but we haven't yet got to fix this.


## Relevant variables

Following variables have sensible defaults set. In order to run this somewhere else, please set variables to your liking. See [httpd-entrypoint.sh](httpd-entrypoint.sh). See default values in the file.

| var | description |
---- | ---- |
| MY_URL | base url of this authproxy service |
| IDP_URL | base url of the idp this client is configured to relay upon (as seen by the authproxy itself) |
| IDP_LOCAL_URL | base url of the idp as seen by the end user browser |
| MY_CLIENT_SECRET | client_secret set for this OIDC RP in the IdP implementation |
