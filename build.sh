cabal v2-build
err=$?
PAGER= git diff -p
if [ $err != 0 ]; then
    exit 1
fi
