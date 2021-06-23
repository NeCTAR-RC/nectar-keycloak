# Nectar Keycloak

## Theme

Our custom Nectar theme is in the theme directory.


## Scripts

This is a collection of scripts used by Nectar for specialised functionality.

See the Keycloak JavaScript Providers documentation at
https://www.keycloak.org/docs/latest/server_development/#_script_providers

### Authenticators
* None

### Policies
* None

### Mappers
* Full name to username mapper
  * This generates a new username based on the template `<firstname><lastname>` which is useful for Gerrit that can't handle email addresses as usernames
