# On second boot, the rootfs is no longer tmpfs and dracut would interpret the
# command line argument, remove it again from the config
for file in /boot/boot.script; do
	[ -e "$file" ] && sed -i -e 's/rootflags=size=100%//' $file
done

#==========================================
# Recreate boot.script after first boot
#------------------------------------------
if [ -x /usr/bin/mkimage ]; then
	mkimage -A arm -O linux -a 0 -e 0 -T script -C none \
		-n 'Boot-Script' -d /boot/boot.script /boot/boot.scr
	if [ ! $? = 0 ]; then
		Echo "Failed to create boot script image"
	fi
fi

if [ "FLAVOR" = "mustang" -o "FLAVOR" = "m400" ]; then
	#==========================================
	# create uImage and uInitrd for x-gene
	#------------------------------------------
	/usr/bin/mkimage -A arm -O linux -C none -T kernel -a 0x00080000           \
	                 -e 0x00080000 -n Linux -d /boot/Image /boot/uImage
	/usr/bin/mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n initramfs \
	                 -d /boot/initrd /boot/uInitrd
fi
