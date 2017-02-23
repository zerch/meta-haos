# Base this image on haospi basic image
include haospi-basic-image.bb

IMAGE_FEATURES += "package-management"
EXTRA_IMAGE_FEATURES += "debug-tweaks"
