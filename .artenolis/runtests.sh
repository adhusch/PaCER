#!/bin/sh
if [ "$ARCH" == "Linux" ]; then
    /mnt/prince-data/MATLAB/$MATLAB_VER/bin/./matlab -nodesktop -nosplash -r "fprintf('Hello Jenkins.\n'); quit();"
fi

CODE=$?
exit $CODE
