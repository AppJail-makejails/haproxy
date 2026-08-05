# HAProxy

HAProxy is the fastest and most widely used open-source load balancer and application delivery controller. Written in C, it has a reputation for efficient use of both processor and memory. It can proxy at either layer 4 (TCP) or layer 7 (HTTP) and has additional features for inspecting, routing and modifying HTTP messages.

It comes bundled with a web UI, called the HAProxy Stats page, that you can use to monitor error rates, the volume of traffic and latency. Features can be toggled on by updating a single configuration file, which provides a syntax for defining routing rules, rate limiting, access controls, and more.

Other features include:

* SSL/TLS termination
* Gzip compression
* Health checking
* HTTP/2
* gRPC support
* Lua scripting
* DNS service discovery
* Automatic retries of failed connections
* Verbose logging

wikipedia.org/wiki/HAProxy

<img src="https://raw.githubusercontent.com/docker-library/docs/4da3e2446a4c257c3a32faac6256bee81f770316/haproxy/logo.png" width="30%" height="auto" alt="HAProxy logo">

## How to use this Makejail

This image is being shipped with a trivial [sample configuration](haproxy.cfg) and for any real life use it should be configured according to the [extensive documentation](https://docs.haproxy.org/) and [examples](https://github.com/haproxy/haproxy/tree/master/examples). We will now show how to override shipped haproxy.cfg with one of your own.

### Create a `Containerfile`

```dockerfile
FROM ghcr.io/appjail-makejails/haproxy:15.1-33
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
```

### Build the container

```console
$ buildah build --network=host -t my-haproxy .
```

### Test the configuration file

```console
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    localhost/my-haproxy test-haproxy-config \
    haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg && 
  appjail stop test-haproxy-config
```

### Run the container

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    localhost/my-haproxy my-running-haproxy
```

If you want external hosts to be able to access your HAProxy, expose the port by specifying the `-o expose` option; for example, `-o expose="8080:80"` will expose port `8080` from the host to port `80` in the container.

### Use volume for configuration persistency

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/path/to/etc/haproxy /usr/local/etc/haproxy <pseudofs> ro" \
    ghcr.io/appjail-makejails/haproxy my-running-haproxy
```

Note that your host's `/path/to/etc/haproxy` folder should be populated with a file named `haproxy.cfg` if you are using `nullfs`, but since in this case we are using `<pseudofs>` this is optional and the `haproxy.cfg` will be copied from the container to the host in case it doesn't exists.

### Reloading config

To be able to reload HAProxy configuration, you can send `SIGUSR2` to the container:

```console
$ appjail oci kill -s USR2 my-running-haproxy
```

### Enable Data Plane API

There are equivalent images suffixed with `-api` that include Data Plane API already installed along with a [configuration file](dataplaneapi.yaml) (which works out of the box but can be modified if desired). Unlike images without the `-api` suffix, HAProxy is run using the `rc(8)` script included in the package, and Data Plane API runs in foreground.

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/path/to/etc/haproxy /usr/local/etc/haproxy <pseudofs>" \
    ghcr.io/appjail-makejails/haproxy:15.1-33-api my-running-haproxy
```

Unlike "standard" HAProxy images, the volume must be mounted in read-write mode (which is the default), since Data Plane API needs to write to all of those files.

```console
$ curl -X GET --user admin:mypassword http://my-running-haproxy:5555/v3/services/haproxy/configuration/version
1
```

More information and examples in the [official documentation](https://www.haproxy.com/documentation/haproxy-data-plane-api/installation/install-on-haproxy/#run-the-api-in-docker) of Data Plane API.

### Arguments (stage: build)

* `haproxy_from` (default: `ghcr.io/appjail-makejails/haproxy`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `haproxy_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-26
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "26"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-28
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "28"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-30
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "30"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-32
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "32"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-33
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "33"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-devel
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "-devel"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-26-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "26"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-28-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "28"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-30-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "30"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-32-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "32"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-33-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "33"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-devel-api
      containerfile: Containerfile.api
      args:
        FREEBSD_RELEASE: "15.1"
        HAPROXYVER: "-devel"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

## Notes

1. The ideas present in the Docker image of HAProxy are taken into account for users who are familiar with it.
2. The images that contain Data Plane API are "hardened" in the sense that both HAProxy and the Data Plane API run as `noroot`, a non-privileged user created at runtime with an arbitrary UID and GID (depending on what you’ve specified via the `PUID` and `PGID` environment variables). To make this work, [security/doas](https://freshports.org/security/doas) is used, since Data Plane API needs to issue the `start`, `stop`, `restart`, and `reload` subcommands using HAProxy’s `rc(8)` script.
