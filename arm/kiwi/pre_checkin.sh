#!/bin/bash
set -e

CPP=cpp
if [ -e /usr/bin/cpp-4.6 ]; then
    # SLES11 has cpp4.3 as default which generates spurious blank lines
    CPP=cpp-4.6
fi

headversion=$(date -d "$(head -n 2 *.changes | tail -n 1 | cut -d- -f1 )" +%Y.%m.%d)

#armv6_gfx_images="rootfs raspberrypi"
#armv6_jeos_images="$armv6_gfx_images"

#armv7_gfx_images="rootfs arndale beagle beaglebone chromebook panda sabrelite vexpress cuboxi paz00 raspberrypi2 raspberrypi3 olinuxinolime olinuxinolime2 a20olinuxinolime a13olinuxino a20olinuxinomicro"
#armv7_jeos_images="$armv7_gfx_images cubieboard cubieboard2 cubietruck cubox midway-pxe efikamx loco cuboxi paz00 bananapi odroid odroidxu3"

#aarch64_gfx_images="rootfs efi hikey raspberrypi3_aarch64"
#aarch64_jeos_images="$aarch64_gfx_images thunderx thunderx-pxe vexpress64 pine64 m400-pxe efi-pxe"
#aarch64_devel_images="efi"

aarch64_gfx_images="raspberrypi3_aarch64"
aarch64_jeos_images="$aarch64_gfx_images pine64"

for arch in armv6 armv7 aarch64; do
    image_list=""

    if [[ $arch == armv6 ]]; then
        jeos_images=$armv6_jeos_images
        gfx_images=$armv6_gfx_images
        devel_images=
    elif [[ $arch == armv7 ]]; then
        jeos_images=$armv7_jeos_images
        gfx_images=$armv7_gfx_images
        devel_images=
    else
        jeos_images=$aarch64_jeos_images
        gfx_images=$aarch64_gfx_images
        devel_images=$aarch64_devel_images
    fi
    for machinetype in $jeos_images; do
        image_list="$image_list JeOS-$machinetype"
    done
    for machinetype in $devel_images; do
        image_list="$image_list JeOS-$machinetype-devel"
    done
    for machinetype in $gfx_images; do
#        image_list="$image_list E20-$machinetype"
#        image_list="$image_list LXQT-$machinetype"
#        image_list="$image_list XFCE-$machinetype"
        image_list="$image_list X11-$machinetype"
    done

    echo "Arch: $arch - image_list: $image_list"

    for i in $image_list; do
        if [[ $i == X11-* ]]; then
            image_type=TYPE_X11
            image_type_string="X11"
            flavor="${i/X11-/}"
        elif [[ $i == XFCE-* ]]; then
            image_type=TYPE_XFCE
            image_type_string="XFCE"
            flavor="${i/XFCE-/}"
        elif [[ $i == E20-* ]]; then
            image_type=TYPE_E20
            image_type_string="E20"
            flavor="${i/E20-/}"
        elif [[ $i == LXQT-* ]]; then
            image_type=TYPE_LXQT
            image_type_string="LXQT"
            flavor="${i/LXQT-/}"
        elif [[ $i == JeOS-* ]]; then
            image_type=TYPE_JEOS
            image_type_string="JeOS"
            flavor="${i/JeOS-/}"
        else
            echo "Unknown image type: $i"
            exit 1
        fi

        pxe=
        if [[ $i == *-pxe ]]; then
            flavor="${flavor/-pxe/}"
            pxe=1
        fi

        with_devel=
        if [[ $i == *-devel ]]; then
            flavor="${flavor/-devel/}"
            image_type_string+="-devel"
            with_devel=1
        fi

        # special cases: JeOS-rootfs is called "JeOS" as package and add .armv6 to armv6 rootfs
        if [ "$arch" = "armv6" ]; then
            suffix=".armv6"
        elif [ "$arch" = "aarch64" ]; then
            suffix=".aarch64"
        else
            suffix=""	# No suffix for armv7
        fi
        if [ "$i" = "JeOS-rootfs" ]; then
            i="JeOS"$suffix
        elif [[ "$i" == *"-rootfs" ]]; then
            i=$i$suffix
        elif [ "$flavor" == "efi" ]; then
            i=$i$suffix
        fi

        # create kiwi description
        image_type_info="-DIMAGE_TYPE=$image_type -DIMAGE_TYPE_STRING=$image_type_string -DIS_ARCH_$arch=1 -DCHANGED=$headversion"
        [ "$pxe" ] && image_type_info="$image_type_info -DUSE_PXE"
        [ "$with_devel" ] && image_type_info="$image_type_info -DUSE_DEVEL_PACKAGES"
        t=$(mktemp)
        echo "Formatting $i"
        $CPP $image_type_info -DIS_FLAVOR_$flavor=1 -DFLAVOR_TYPE=$flavor -P Images.kiwi.in -o $t
        # replace defines that cpp would ignore
        # do not use 'quiet' here so we get kiwi output
        sed -i "s/FLAVOR_TYPE/$flavor/g;s/IMAGE_TYPE/$image_type/g;s/IMAGE_TYPE_STRING/$image_type_string/g;s/ARCH/$arch/g;s/KERNEL_CMDLINE_DEFAULT/loglevel=3 plymouth.enable=0 rootflags=size=100%/g" $t
        # this will abort if there's an error (see set -e)
        xmllint --format $t --output $i.kiwi || break
        rm -f $t
        # get BOOTKERNEL var
        bootkernel=$(grep '<package name="kernel-' $i.kiwi | grep "bootinclude" | sed 's/.*kernel-//;s/".*$//')

        if [ "$flavor" != "rootfs" ]; then
            # create uboot scripts
            for i in install setup; do
                sed "s/FLAVOR/$flavor/g;s/TARGET/firstboot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT//g" uboot-image-$i.in > uboot-image-$flavor-$i
            done
            rm -rf x y
            mkdir -p x/kiwi-hooks
            # kiwi 7.x
            sed "s/FLAVOR/$flavor/g;s/TARGET/boot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT/1/g" installUBoot.sh > x/kiwi-hooks/installUBoot.sh
            sed "s/FLAVOR/$flavor/g;s/TARGET/boot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT/1/g" uboot-image-setup.in > x/kiwi-hooks/setupUBoot.sh
            # kiwi 8.x
            sed "s/FLAVOR/$flavor/g;s/TARGET/boot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT/1/g" installUBoot.sh > x/kiwi-hooks/postInstallBootLoader.sh
            sed "s/FLAVOR/$flavor/g;s/TARGET/boot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT/1/g" uboot-image-setup.in > x/kiwi-hooks/postSetupBootLoader.sh
            # kiwi 7.x/8.x
            sed "s/FLAVOR/$flavor/g;s/TARGET/boot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT/1/g" uboot-image-install.in > x/kiwi-hooks/preCallInit.sh
            chmod +x x/kiwi-hooks/*
            # compare to the old tar ball
            TGZ=uboot-setup-$flavor.tgz
            if [ -f $TGZ ]; then
                mkdir -p y
                tar -xzf $TGZ -C y
                if ! diff -br x y > /dev/null; then
                    tar -czf $TGZ --owner root --group root -C x kiwi-hooks
                fi
                rm -rf x y
            else
                tar -czf $TGZ --owner root --group root -C x kiwi-hooks
                rm -rf x
            fi
        fi

    done
done
