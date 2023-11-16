# nectar-keycloak

## Scripts

This repository also contains scripts used for some custom authentication logic.

They are built with the included Makefile, but can be built manually by doing:
```
cd scripts; zip ../nectar-scripts.jar -r *; cd ..
```

Each script included must have a corresponding META-INF entry.

Once the jar file is built, it can be deployted for dev testing by placing it
in the `/opt/keycloak/providers` directory, and restarting the server.
