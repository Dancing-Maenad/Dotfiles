#!/usr/bin/env bash
set -euo pipefail

niri msg windows | awk '/Title:/ {sub(/^  Title: "/, "", $0); sub(/"$/, "", $0); title=$0} /App ID: "tidal-hifi"/ {print title; exit}'

