DESCRIPTION = "CAN hat test applications packagegroup"
SUMMARY = "CAN hat packagegroup - tools/testapps"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = " \
    ethtool \
    perf \
    memtester \
"
