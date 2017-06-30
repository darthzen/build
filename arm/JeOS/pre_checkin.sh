#!/bin/bash
set -e

CPP=cpp
if [ -e /usr/bin/cpp-4.6 ]; then
    # SLES11 has cpp4.3 as default which generates spurious blank lines
    CPP=cpp-4.6
fi

headversion=$(date -d "$(head -n 2 JeOS.changes | tail -n 1 | cut -d- -f1 )" -u +%Y.%m.%d)

armv6_gfx_images="rootfs raspberrypi"
armv6_jeos_images="$armv6_gfx_images"

armv7_gfx_images="rootfs vexpress"
# Allwinner
armv7_gfx_images="$armv7_gfx_images a13olinuxino a20olinuxinolime a20olinuxinomicro olinuxinolime olinuxinolime2"
# Broadcom
armv7_gfx_images="$armv7_gfx_images raspberrypi2"
# Nvidia
armv7_gfx_images="$armv7_gfx_images paz00"
# NXP
armv7_gfx_images="$armv7_gfx_images cuboxi sabrelite"
# Samsung
armv7_gfx_images="$armv7_gfx_images arndale chromebook"
# Texas Instruments
armv7_gfx_images="$armv7_gfx_images beagle beaglebone panda"

armv7_jeos_images="$armv7_gfx_images"
# Allwinner
armv7_jeos_images="$armv7_jeos_images bananapi cubieboard cubieboard2 cubietruck nanopineo nanopineoair"
# Calxeda
armv7_jeos_images="$armv7_jeos_images midway-pxe"
# Intel
armv7_jeos_images="$armv7_jeos_images socfpgade0nanosoc"
# NXP
armv7_jeos_images="$armv7_jeos_images cuboxi loco udooneo"
# Marvell
armv7_jeos_images="$armv7_jeos_images clearfog cubox"
# Rockchip
armv7_jeos_images="$armv7_jeos_images fireflyrk3288 tinker"
# Samsung
armv7_jeos_images="$armv7_jeos_images odroid odroidxu3"
# Generic EFI images
armv7_jeos_images="$armv7_jeos_images efi efi-pxe"

aarch64_gfx_images="rootfs efi hikey raspberrypi3"
aarch64_jeos_images="$aarch64_gfx_images efi-pxe m400-pxe vexpress64"
# Allwinner
aarch64_jeos_images="$aarch64_jeos_images pine64"
# Amlogic
aarch64_jeos_images="$aarch64_jeos_images nanopik2 odroidc2"
aarch64_devel_images="efi"

x86_64_gfx_images="rootfs efi"
x86_64_jeos_images="$x86_64_gfx_images efi-pxe"
x86_64_devel_images="efi"

echo "<multibuild>" > _multibuild

for arch in armv6 armv7 aarch64 x86_64; do
    image_list=""

    for img in jeos gfx devel; do
        eval ${img}_images=\"\$${arch}_${img}_images\"
    done
    for machinetype in $jeos_images; do
        image_list="$image_list JeOS-$machinetype"
    done
    for machinetype in $devel_images; do
        image_list="$image_list JeOS-$machinetype-devel"
    done
    for machinetype in $gfx_images; do
        image_list="$image_list E20-$machinetype"
        image_list="$image_list LXQT-$machinetype"
        image_list="$image_list XFCE-$machinetype"
        image_list="$image_list X11-$machinetype"
    done

    echo "Arch: $arch - image_list: $image_list"

    for i in $image_list; do
        if [[ $i == XFCE-* ]]; then
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
        elif [[ $i == X11-* ]]; then
            image_type=TYPE_X11
            image_type_string="X11"
            flavor="${i/X11-/}"
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
        if [ "$arch" = "armv7" ]; then
            # No suffix for armv7
            suffix=""
        else
            suffix=".$arch"
        fi
        if [ "$i" = "JeOS-rootfs" ]; then
            i="JeOS"$suffix
        elif [[ "$i" == *"-rootfs" ]]; then
            i=$i$suffix
        elif [ "$flavor" == "efi" ] || [ "$flavor" == "raspberrypi3" ]; then
            i=$i$suffix
        fi

        # create kiwi description
        image_type_info="-DIMAGE_TYPE=$image_type -DIMAGE_TYPE_STRING=$image_type_string -DIS_ARCH_$arch=1 -DCHANGED=$headversion"
        [ "$pxe" ] && image_type_info="$image_type_info -DUSE_PXE"
        [ "$with_devel" ] && image_type_info="$image_type_info -DUSE_DEVEL_PACKAGES"
        t=$(mktemp)
        echo "Formatting $i"
        flavor_type=$flavor
        $CPP $image_type_info -DIS_FLAVOR_$flavor=1 -DFLAVOR_TYPE=$flavor_type -P Images.kiwi.in -o $t
        # replace defines that cpp would ignore
        sed -i "s/FLAVOR_TYPE/$flavor_type/g;s/IMAGE_TYPE/$image_type/g;s/IMAGE_TYPE_STRING/$image_type_string/g;s/ARCH/$arch/g;s/KERNEL_CMDLINE_DEFAULT/loglevel=3 splash=silent plymouth.enable=0 rootflags=size=100%/g" $t
        # this will abort if there's an error (see set -e)
        xmllint --format $t --output $i.kiwi || break
        rm -f $t
        # get BOOTKERNEL var
        bootkernel=$(grep '<package name="kernel-' $i.kiwi | grep "bootinclude" | sed 's/.*kernel-//;s/".*$//')

        # Determine if we're a contrib package
        CONTRIB_REPO=
        while read image contrib; do
            if [ "$flavor" = "$image" ]; then
                CONTRIB_REPO="$contrib"
            fi
        done < contribs

        # Add all non-contrib builds to the package build list
        if [ ! "$CONTRIB_REPO" ]; then
            echo "<package>$i</package>" >> _multibuild
        fi

        if [ "$flavor" != "rootfs" ]; then
            # create uboot scripts
            for i in install setup; do
                sed "s/FLAVOR/$flavor_type/g;s/TARGET/firstboot/g;s/BOOTKERNEL/$bootkernel/g;s/IS_FIRSTBOOT//g" uboot-image-$i.in > uboot-image-$flavor_type-$i
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
            # add contrib repo name
            if [ "$CONTRIB_REPO" ]; then
                echo "$CONTRIB_REPO" > x/kiwi-hooks/contrib_repo
            fi
            # compare to the old tar ball
            TGZ=uboot-setup-$flavor_type.tgz
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

echo "</multibuild>" >> _multibuild

# Prepare cloud.cfg tarballs for dracut based firstboot initrd
for f in cloud.cfg.noswap cloud.cfg.swapfile; do
    mkdir -p x/etc/cloud
    cp $f x/etc/cloud/cloud.cfg

    TGZ=$(echo $f | sed 's/\./-/g').tgz
    if [ -f $TGZ ]; then
        mkdir -p y
        tar -xzf $TGZ -C y
        if ! diff -br x y > /dev/null; then
            tar -czf $TGZ --owner root --group root -C x etc
        fi
        rm -rf x y
    else
        tar -czf $TGZ --owner root --group root -C x etc
        rm -rf x
    fi
done
