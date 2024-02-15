SUMMARY = "CAN hat support development image"

LICENSE = "MIT"

inherit core-image
require can-hat-image.bb

IMAGE_FEATURES += "ssh-server-openssh tools-debug debug-tweaks"

# Add SK Pang CAN hat configuration using extra RPI configuration options:
#     https://meta-raspberrypi.readthedocs.io/en/latest/extra-build-config.html

# This is required for RPI3 and 0 (if we want to use UART, of course)
ENABLE_UART = "1"

# Enable Dual CAN hat
ENABLE_SPI_BUS = "1"
ENABLE_DUAL_CAN = "1"

# By default it operates on 16MHz so no explicit setting is needed
# CAN_OSCILLATOR="8000000"
# Same goes to the interrupts which are set by default to the values we need
#CAN0_INTERRUPT_PIN = "25"
#CAN1_INTERRUPT_PIN = "24"

CORE_IMAGE_EXTRA_INSTALL += "can-hat-packagegroup-testapps"
