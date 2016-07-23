# Ingress Intel Download

A set of ruby scripts for downloading portal data from the [Ingress Intel Map API]().

## Setup

Create a `private.yml` file and save it in the root of this repo after cloning. This file will be ignored and should not be checked in as it will contain identifers for your Google/Ingress authentication.

```yaml
---
Headers:
  X-CSRFToken: *****
Cookies:
  csrftoken: *****
  SACSID: *****
```

## License

This repo is licensed under the MIT License. See the [LICENSE](LICENSE.md) file for rights and limitations.

