# Base this image on rpi-basic-image
include recipes-core/images/rpi-basic-image.bb

SPLASH = ""
EXTRA_IMAGE_FEATURES += "read-only-rootfs"
