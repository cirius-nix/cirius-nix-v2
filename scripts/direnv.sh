#!/usr/bin/env bash

set -a
source <(sops --config .sops.yaml -d ./secrets/$(hostname)/$(whoami)/default.env)
set +a
