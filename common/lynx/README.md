# Lynx Text Browser FTW!

It might be the oldest web browser currently under active maintenance but it is still hands down the single best browser for rapid research. Lynx does not even look at the bloat of images, CSS, and JavaScript when loading making it objectively the fastest possible way to browse the text of web sites. When combined with a `?` (`duck`) and `??` (`google`) command you fill find results to documentation queries and technical documentation as fast as it takes to open a local `man` page.

## Lynx Wrapper Script

This version of [lynx](../bin/lynx) does not allow for anything to be passed to it but the URL to open. This allows the lookup of web sites without the `http` and `https` schemas. All other configurations are placed here in the `~/.config/lynx/lynx.cfg` and `~/.config/lynx/lynx.lss` files which `lynx` finds through the `LYNX_CFG` and `LYNX_LSS` environment variables which the `lynx` wrapper script sets to point to `~/config/lynx`, which is symbolically linked to this directory (see [`setup`](setup)).
