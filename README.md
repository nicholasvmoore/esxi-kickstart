NGINX auto kickstart ESXi
=========================


# Adding an OS
In order to add an OS you will need to mount the ISO and copy its contents to `/var/lib/tftpboot/esxi/`. After this you will need to modify the boot.cfg for the standard BIOS as we're not using EFI yet. This file is located on the root of the ISO and you'll need to run a sed to remove the slashes before making the rest of your modifications. Because we're booting off of HTTP we need to add a `prefix=` and modify the `kernelopt=`.

## SED
```bash
sed -i ‘s/\///g’ boot.cfg
```

## Prefix & Kernel Opt
```
# kernelopt
kernelopt=runweasel ks=http://172.16.0.100.lii01.livun.com/ks/

# prefix
prefix=http://172.16.0.100/esxi/67u1