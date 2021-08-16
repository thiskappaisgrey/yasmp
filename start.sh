#!/usr/bin/env bash
set -euo pipefail

ghcid -c 'cabal new-repl' \
            --reload=./app/Main.hs \
            -T Main.main \
            --restart=./yasmp.cabal
