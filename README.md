# nix-acbuild
Build minimal ACI containers using the Nix package manager


## Tutorial
.. to be written

## Example

```
$ nix-build ./examples/nginx.nix
$ systemd-run rkt run --insecure-options=image $PWD/result/image.aci
$ machinectl
MACHINE                                  CLASS     SERVICE OS VERSION ADDRESSES
rkt-cc02c7aa-03c8-422d-8301-20788767cc00 container rkt     -  -       172.16.28.16...

```

Now go to `http://172.16.28.16` and great success!
