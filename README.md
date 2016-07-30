# Ingress Intel Download

A set of ruby scripts for downloading portal data from the [Ingress Intel Map API]().

## Setup

Create a `private.yml` file and save it in the root of this repo after cloning. This file will be ignored and should not be checked in as it will contain identifers for your Google/Ingress authentication.

You will need to sniff your own HTTP traffic ([Charles proxy](https://www.charlesproxy.com/) recommended) to the [Ingress Intel Map](https://www.ingress.com/intel/) in order to retrieve the following values:

```yaml
---
Headers:
  X-CSRFToken: *****
Cookies:
  csrftoken: *****
  SACSID: *****
```

The CSRF token header and cookie values will be the same and I haven't seen the change over time. However, the `SACSID` cookie changes each time the session expires.

## License

This repo is licensed under the MIT License. See the [LICENSE](LICENSE.md) file for rights and limitations.

