#!/bin/sh

# launch MATLAB
if [ "$ARCH" == "Linux" ]; then
    /mnt/prince-data/MATLAB/$MATLAB_VER/bin/./matlab -nodesktop -nosplash < test/testAll.m
fi

CODE=$?
exit $CODE
