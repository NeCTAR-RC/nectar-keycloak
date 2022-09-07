FROM quay.io/keycloak/keycloak:19.0.1 as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_DB=mariadb
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_CACHE_CONFIG_FILE=cache-ispn.xml

# Add Nectar theme
ADD ./themes/nectar /opt/keycloak/themes/nectar/

# Add our JDBC ping config, and remove old config
COPY ./cache-ispn.xml /opt/keycloak/conf/cache-ispn.xml

USER root
RUN chown -R keycloak /opt/keycloak

USER keycloak
RUN /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config

FROM quay.io/keycloak/keycloak:19.0.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT /opt/keycloak/bin/kc.sh

