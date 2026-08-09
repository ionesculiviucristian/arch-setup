#!/bin/bash
set -eu

sudo systemctl enable --now switcheroo-control.service

exit 0
