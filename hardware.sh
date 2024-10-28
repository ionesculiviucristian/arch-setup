echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", ATTR{authorized}="0"' | sudo tee -a /etc/udev/rules.d/81-bluetooth-hci.rules
