# HAProxy

HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications. It is particularly suited for web sites crawling under very high loads while needing persistence or Layer7 processing.

<img src="https://i.ibb.co/2YRDg0W/haproxy.jpg" width="60%" height="auto" alt="haproxy logo">

## How to use this Makejail

```sh
appjail makejail \
    -j haproxy \
    -f gh+AppJail-makejails/haproxy \
    -o virtualnet=":<random> default" \
    -o nat \
    -o copydir="$PWD/files" \
    -o file=/usr/local/etc/haproxy.conf
```

**Note**: DataplaneAPI is located in `/dataplaneapi` if you plane to use it.

### Arguments

* `haproxy_tag` (default: `13.4`): see [#tags](#tags).
* `haproxy_ajspec` (default: `gh+AppJail-makejails/haproxy`): Entry point where the `appjail-ajspec(5)` file is located.

## Tags

| Tag                     | Arch     | Version            | Type   | `haproxy_install_dataplaneapi` | `haproxy_dataplaneapi_version` |
| ----------------------- | -------- | ------------------ | ------ | ------------------------------ | ------------------------------ |
| `13.4`              | `amd64`  | `13.4-RELEASE` | `thin` |              `0`               | `3.0.4`     |
| `13.4-dataplaneapi` | `amd64`  | `13.4-RELEASE` | `thin` |              `1`               | `3.0.4`     |
| `14.2`              | `amd64`  | `14.2-RELEASE` | `thin` |              `0`               | `3.0.4`     |
| `14.2-dataplaneapi` | `amd64`  | `14.2-RELEASE` | `thin` |              `1`               | `3.0.4`     |
