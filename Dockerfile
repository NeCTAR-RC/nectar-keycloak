### Build stage
FROM quay.io/keycloak/keycloak:26.8.2 AS builder

ENV KC_FEATURES=scripts
ENV KC_TRANSACTION_XA_ENABLED=false
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_HTTP_MANAGEMENT_RELATIVE_PATH=/
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=mariadb

# Add our providers
COPY providers/nectar-scripts.jar /opt/keycloak/providers/nectar-scripts.jar

# Add our themes
ADD themes /opt/keycloak/themes

USER root
RUN chown -R keycloak /opt/keycloak

USER keycloak
RUN /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config

### Run stage
FROM quay.io/keycloak/keycloak:26.8.2
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Mitigation for CVE-2026-114938: limit the JVM to AVX2.
# Remove once the ubi9 java-21-openjdk package in the base image is at
# least 21.0.13.1 (26.8.2 ships 21.0.13.0.9-1). Check with:
#   docker run --rm --entrypoint java <image> -version
ENV JAVA_OPTS_APPEND="-XX:UseAVX=2"

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
