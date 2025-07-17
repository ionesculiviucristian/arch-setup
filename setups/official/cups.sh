#!/bin/bash
set -eu

sudo systemctl enable cups.service
sudo systemctl start cups.service

exit 0
