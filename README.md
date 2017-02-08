This is my custom layer to work on top of raspberrypi layer from yocto community.

How to setup and start build:
    1.) Clone this repo.

    2.) Run "scripts/start_project.sh" with your custom setup. (Check "--help")

        This will create the project directory with all required layers

    3.) source setup-environent and create the build folder:

        % source setup-environment build

    4.) run bitbake with rpi base image:

        % bitbake rpi-base-image

