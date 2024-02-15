# Network configuration files
SUMMARY = "Network configuration files"
LICENSE = "CLOSED"

SRC_URI = " \
    file://eth0_dhcp \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install() {

    install -d 0644 ${D}${sysconfdir}/network
    install -d 0644 ${D}${sysconfdir}/sysctl.d
    install -d 0644 ${D}${sysconfdir}/udev/rules.d
    install -d 0644 ${D}${sysconfdir}/NetworkManager
    install -d 0644 ${D}${sysconfdir}/NetworkManager/dispatcher.d
    install -d 0644 ${D}${sysconfdir}/NetworkManager/system-connections
    install -d 0644 ${D}${sbindir}

    # Connection settings for Ethernet dongle device
    install -m 0600 ${WORKDIR}/eth0_dhcp ${D}${sysconfdir}/NetworkManager/system-connections
}
