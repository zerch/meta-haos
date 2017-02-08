This is my custom layer to work on top of raspberrypi layer from yocto community.

How to setup and start build:

    1.) Clone this repo.

    2.) Run "scripts/start_project.sh" with your custom setup. (Check "--help")

        This will create a repo project directory with all required layers

    3.) Change dir to project and source setup-environent to create the build folder:

        % source setup-environment build

    4.) Run bitbake with rpi base image:

        % bitbake rpi-base-image

    OR

    At step 2*.)  run "start_project.sh" with "-c" option to automatically create and check build environment and parse recipes

