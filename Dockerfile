FROM httpd:bullseye
USER root

# Install necessary packages
RUN apt update -yy && apt upgrade -yy 
RUN apt-get install -y libapache2-mod-auth-openidc nodejs npm

# Activating Apache Modules
RUN sed -i 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/^#\(LoadModule .*mod_proxy.so\)/\1/' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/^#\(LoadModule .*mod_proxy_http.so\)/\1/' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/mod_rewrite\.so/a LoadModule auth_openidc_module /usr/lib/apache2/modules/mod_auth_openidc.so'  /usr/local/apache2/conf/httpd.conf
RUN printf "Include \"/usr/local/apache2/conf/authn_openidc.conf\"\n"  >> /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/LogLevel warn/LogLevel debug/'  /usr/local/apache2/conf/httpd.conf
RUN echo "User-agent: * \nDisallow: /" >> /usr/local/apache2/htdocs/robots.txt

# Copy node server
ADD backend/ /opt/node/backend
WORKDIR /opt/node/backend
RUN npm install

# Copying Frontend html pages
ADD frontend/public_html/images/*  /usr/local/apache2/htdocs/images/
ADD frontend/public_html/authenticated-index.html  /usr/local/apache2/htdocs/secret/index.html
ADD frontend/public_html/authenticated-index.html  /usr/local/apache2/htdocs/customauth/index.html
ADD frontend/public_html/anonymous-index.html      /usr/local/apache2/htdocs/index.html
ADD frontend/authn_openidc/authn_openidc.conf          /usr/local/apache2/conf/authn_openidc.conf

ADD ./httpd-entrypoint.sh /opt/
RUN chmod 755 /opt/httpd-entrypoint.sh

ENTRYPOINT [ "/opt/httpd-entrypoint.sh" ]