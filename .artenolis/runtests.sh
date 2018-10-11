#!/bin/sh
if [ "$ARCH" == "Linux" ]; then
    /mnt/MATLAB/$MATLAB_VER/bin/./matlab -nodesktop -nosplash -r "fprintf('Hello ARTENOLIS.\n'); quit();"
fi

CODE=$?
exit $CODE
