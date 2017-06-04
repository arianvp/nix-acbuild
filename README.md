# nix-acbuild
Build minimal ACI containers for [rkt](https://github.com/rkt/rkt) using the Nix package manager


`nix-acbuild` calculates the minimal closure to run your provided `appc` manifest, and then
packs it up into an `appc` container, which can then be run using `rkt` for example.


## Tutorial
.. to be written


## Requirements
A  machine with nix installed to build the images

A machine with rkt installed (could be the same) to run the ACI that gets output

## Example Nginx

```
$ systemd-run rkt run --insecure-options=image $(nix-build ./examples/nginx.nix)
```

Look up the IP
```
$ machinectl
MACHINE                                  CLASS     SERVICE OS VERSION ADDRESSES
rkt-cc02c7aa-03c8-422d-8301-20788767cc00 container rkt     -  -       172.16.28.16...

```

Now go to `http://172.16.28.16` and great success!

### Example Nginx with mounts

```
systemd-run rkt run --insecure-options=image --volume website,kind=host,source=$PWD/examples/nginx-mount $(nix-build ./examples/nginx-mount) 
```

Look up the IP
```
$ machinectl
MACHINE                                  CLASS     SERVICE OS VERSION ADDRESSES
rkt-cc02c7aa-03c8-422d-8301-20788767cc00 container rkt     -  -       172.16.28.16...

```

Now go to `http://172.16.28.16` and great success!
