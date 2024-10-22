# Build stage
FROM quay.io/keycloak/keycloak:22.0.5 as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=mariadb
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_CACHE_CONFIG_FILE=cache-ispn.xml

# Install Nectar custom provider
COPY providers/nectar-scripts.jar /opt/keycloak/providers/nectar-scripts.jar
# Install any other custom providers
#COPY providers/*.jar /opt/keycloak/providers/

# Add themes
ADD ./themes /opt/keycloak/themes

# Add our JDBC ping config, and remove old config
COPY ./cache-ispn.xml /opt/keycloak/conf/cache-ispn.xml

USER root
RUN chown -R keycloak /opt/keycloak

USER keycloak
RUN /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config


# Run stage
FROM quay.io/keycloak/keycloak:22.0.5
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

# Install Nectar custom provider
COPY providers/nectar-scripts.jar /opt/keycloak/providers/nectar-scripts.jar
# Install any other custom providers
#COPY providers/*.jar /opt/keycloak/providers/

ENTRYPOINT /opt/keycloak/bin/kc.sh
