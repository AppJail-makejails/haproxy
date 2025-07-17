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

**Note**: Previously Data Plane API was included in the `/dataplaneapi` directory, however now it is installed from the package, so it starts like any other `rc(8)` script.

### Arguments

* `haproxy_tag` (default: `13.5`): see [#tags](#tags).
* `haproxy_ajspec` (default: `gh+AppJail-makejails/haproxy`): Entry point where the `appjail-ajspec(5)` file is located.

## Tags

| Tag                     | Arch     | Version            | Type   | `haproxy_install_dataplaneapi` |
| ----------------------- | -------- | ------------------ | ------ | ------------------------------ |
| `13.5`              | `amd64`  | `13.5-RELEASE` | `thin` |              `0`               |
| `13.5-dataplaneapi` | `amd64`  | `13.5-RELEASE` | `thin` |              `1`               |
| `14.3`              | `amd64`  | `14.3-RELEASE` | `thin` |              `0`               |
| `14.3-dataplaneapi` | `amd64`  | `14.3-RELEASE` | `thin` |              `1`               |
