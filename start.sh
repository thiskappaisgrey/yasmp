#!/usr/bin/env bash
set -euo pipefail
case $1 in
    app)
        ghcid -c 'cabal new-repl' \
                    --reload=./src \
                    -T Lib.app \
                    --restart=./yasmp.cabal;;
    test)
        ghcid -c "cabal new-repl yasmp-test" --test "main";;
    *)
        echo "enter app or test";;
esac
