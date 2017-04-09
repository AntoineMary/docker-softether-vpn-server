#! /bin/sh
set -e

FILE="src/Cedar/Interop_OpenVPN.h"
echo "> Patching $FILE <"
if [ -f $FILE ]; then
  echo "  - Changing default algorithm -"
  sed -n 's/"AES-128-CBC"/"AES-256-CBC"/gp' $FILE
  sed -n 's/"SHA1"/"RMD160"/gp' $FILE

  echo "  - Changing default OpenVPN client option string -"
  sed -n 's/cipher AES-128-CBC,auth SHA1/cipher AES-256-CBC,auth RMD160/gp' $FILE

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
  exit 1
fi

FILE="src/bin/hamcore/openvpn_sample.ovpn"
echo "> Patching $FILE <"
if [ -f $FILE ]; then
  echo "  - Changing default cipher -"
  sed -n 's/cipher AES-128-CBC/cipher AES-256-CBC/gp' $FILE

  echo "  - Changing default auth -"
  sed -n 's/auth SHA1/auth RMD160/gp' $FILE

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
  exit 1
fi

exit 0
