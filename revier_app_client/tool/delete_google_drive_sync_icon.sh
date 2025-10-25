find . -name "Icon?" -exec rm -f {} \;
find . -name "Icon?" -print0 | xargs -0 rm -rf