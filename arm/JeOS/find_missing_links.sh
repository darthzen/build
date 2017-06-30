#!/bin/bash

for i in *.kiwi; do
    IMAGENAME=$(echo ${i%*.kiwi})
    if grep -q Contrib $i; then
        # Skip contrib imags
        continue
    fi
    if ! osc meta pkg openSUSE:Factory:ARM $IMAGENAME &>/dev/null; then
        echo $IMAGENAME
    fi
done
