#!/bin/bash
set -eu

sudo systemctl enable --now power-profiles-daemon.service

exit 0
