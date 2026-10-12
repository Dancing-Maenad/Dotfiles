#!/usr/bin/env bash
set -euo pipefail

niri msg action focus-window --id "$(niri msg windows | awk '/Window ID/{id=$3; sub(/:/,"",id)} /App ID: "tidal-hifi"/{print id; exit}')"

