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

echo "Executing 00_Server.sh"
echo ""

FILE="src/Cedar/Server.h"
echo "> Patching $FILE <"
if [ -f $FILE ]; then

  echo "  - Changing default algorithm -"
  patch 's/"RC4-MD5"/"DHE-RSA-AES256-SHA"/g'

  echo "  - Changing default name of HUB -"
  patch 's/"DEFAULT"/"HUB"/g'

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
fi

echo ""
exit 0
