#!/bin/bash
set -e

THEOS=~/theos
PACKAGE_ID="com.yourid.swipeinputtweak"
DEB_NAME="SwipeInputTweak.deb"

echo "[*] Cleaning..."
make clean

echo "[*] Building..."
make package FINALPACKAGE=1

echo "[*] Moving deb to root..."
mv packages/*.deb ./$DEB_NAME

echo "[*] Done. Output: $DEB_NAME"
