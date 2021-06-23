FROM jboss/keycloak

# Install zip
USER root
RUN microdnf update -y && microdnf install -y zip && microdnf clean all

USER 1000
# Add, built and deploy the scripts as a JAR file
ADD --chown=1000 scripts /tmp/
RUN cd /tmp/nectar-scripts && zip -r /tmp/nectar-scripts.zip . && rm -fr /tmp/nectar-scripts && mv /tmp/nectar-scripts.zip /opt/jboss/keycloak/standalone/deployments/nectar-scripts.jar

# Add theme
ADD --chown=1000 themes /opt/jboss/keycloak/themes/
