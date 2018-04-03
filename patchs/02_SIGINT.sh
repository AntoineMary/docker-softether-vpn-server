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

echo "Executing 02_SIGINT.sh"
echo ""

FILE="src/Mayaqua/Unix.c"
echo "> Patching $FILE <"
if [ -f $FILE ]; then

  echo "  - Changing stop signal -"
  patch 's/SIGTERM/SIGINT/g'

  echo "> $FILE Patched <"
else
  echo "$FILE don't exist" >&2
fi

echo ""
exit 0
