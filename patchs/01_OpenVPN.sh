#! /bin/sh
set -e

patch() {
  PATTERN=$1

  if [[ "$(sed -n "$PATTERN"p"" "$FILE")" ]]; then
    echo "        > $(sed -n "$PATTERN"p"" $FILE)"
    sed -i "$PATTERN" "$FILE"
  else
    echo "Nothing to replace in "$FILE" with "$PATTERN"" >&2
    exit 1
  fi
}

echo "Executing 03_OpenVPN.sh"
echo ""

FILE="src/Cedar/Interop_OpenVPN.h"
echo "> Patching $FILE <"
if [ -f $FILE ]; then

  echo "  - Changing default algorithm -"
  patch 's/"AES-128-CBC"/"AES-256-CBC"/g'
  patch 's/"SHA1"/"RMD160"/g'

  echo "  - Changing default OpenVPN client option string -"
  patch 's/cipher AES-128-CBC,auth SHA1/cipher AES-256-CBC,auth RMD160/g'

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
fi

echo ""

FILE="src/bin/hamcore/openvpn_sample.ovpn"
echo "> Patching $FILE <"
if [ -f $FILE ]; then

  echo "  - Changing default cipher -"
  patch 's/cipher AES-128-CBC/cipher AES-256-CBC/g'

  echo "  - Changing default auth -"
  patch 's/auth SHA1/auth RMD160/g'

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
fi

echo ""
exit 0
