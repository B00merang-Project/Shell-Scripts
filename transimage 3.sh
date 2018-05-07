#!/bin/bash
# FOLDER=actions
IMAGES=new

size=$1

# cd $FOLDER
mkdir new

for PHOTO in *.png
do
#  BASE=`basename $PHOTO`
   NAME=${PHOTO%'.png'}
#  convert "$PHOTO" -colorspace gray "$IMAGES/$BASE"
   convert "$PHOTO"[40x] "$IMAGES/$NAME@2.png"
#  echo $NAME
done
