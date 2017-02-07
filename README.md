This is my custom layer to work on top of raspberrypi layer from yocto community.

Aiming to create a 'systemd' based rpi basic image

Currently only holding config samples to be used for TEMPLATECONF,
not a real layer yet.

This depends on:

    git clone -b morty git://git.yoctoproject.org/poky.git

    git clone -b morty git://git.openembedded.org/meta-openembedded

    git clone -b morty https://github.com/meta-qt5/meta-qt5.git

    git clone -b morty git://git.yoctoproject.org/meta-raspberrypi

How to setup and start build:

    1.) Create a layers directory where all the required git projects are cloned including this one

    2.) Create symlink to setup-environment:

        % ln -s meta-haos/conf/setup-environment .

    Folder structure should look like this:
        meta-haos
        meta-qt5
        meta-openembedded
        meta-raspberrypi
        poky
        setup-environment

    3.) source setup-environent and create the build folder:

        % source setup-environment build

    4.) run bitbake with rpi base image:

        % bitbake rpi-base-image

