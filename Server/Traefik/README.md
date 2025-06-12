# Traefik Dynamic Routing Using File Provider

This guide explains how to configure **dynamic routing** in Traefik using the **file provider**. Configuration files are placed in a specific directory such as `/etc/traefik/dynamic/`.

---

## 1. Main Configuration File: `/etc/traefik.yml`

This is the main Traefik configuration file. It defines global settings, entry points, and enables the file provider to load dynamic routes.

```yaml
global:
  checkNewVersion: true
  sendAnonymousUsage: true

entryPoints:
  web:
    address: :80
  websecure:
    address: :443
  other1:
    address: :8080

providers:
  file:
    directory: /etc/traefik/dynamic
    watch: true
````

> `watch: true` makes Traefik automatically reload the configuration when any file changes in `/etc/traefik/dynamic`.

---

## 2. Example Dynamic Configuration File

**Path:** `/etc/traefik/dynamic/incrustwerush.org.yml`

```yaml
http:
  routers:
    incrustwerush-web:
      rule: "Host(`incrustwerush.org`) && PathPrefix(`/`)"
      service: incrustwerush-web
      entryPoints:
        - web
      middlewares:
        - incrustwerush-web

    test-incrustwerush-web:
      rule: "Host(`test.incrustwerush.org`) && PathPrefix(`/`)"
      service: test-incrustwerush-web
      entryPoints:
        - web
      middlewares:
        - test-incrustwerush-web

  middlewares:
    incrustwerush-web:
      stripPrefix:
        prefixes:
          - "/"
    test-incrustwerush-web:
      stripPrefix:
        prefixes:
          - "/"

  services:
    incrustwerush-web:
      loadBalancer:
        servers:
          - url: "http://192.168.200.20:8090/"
    test-incrustwerush-web:
      loadBalancer:
        servers:
          - url: "http://192.168.200.252:8080/"
```

---

## Explanation

* **Routers** define rules for matching incoming HTTP requests based on host and path.
* **Middlewares** modify the request before passing it to the service (e.g., strip `/` from the path).
* **Services** forward the request to the specified backend server(s).
