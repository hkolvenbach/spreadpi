#!/bin/bash
set -e

# Install chdkptp manually
# wget https://app.assembla.com/spaces/chdkptp/documents/cTi9WmaI4r54kqdmr6CpXy/download/cTi9WmaI4r54kqdmr6CpXy?notinline=true -O chdkptp.zip


# Install spreads dependencies
if [ -e $DELIVERY_DIR/spreads-sdist.tar.gz ]; then
    apt-get -y --force-yes install --no-install-recommends \
        python python-colorama python-yaml python-concurrent.futures \
        python-blinker python-roman python-usb python-psutil \
        python-isbnlib python-flask \
        python-requests python-wand python-zipstream python-netifaces \
        python-dbus liblua5.2-dev libusb-dev python-cffi libjpeg8-dev \
        libturbojpeg-dev
    # not available in stretch
    # apt-get -y install chdkptp python-hidapi-cffi
    apt-get -y install python-pip build-essential python2.7-dev pkg-config
    pip install tornado
    pip install jpegtran-cffi
    pip install lupa --install-option="--no-luajit"
    pip install hidapi-cffi
    pip install chdkptp.py
    pip install $DELIVERY_DIR/spreads-sdist.tar.gz
    apt-get -y remove --purge --auto-remove build-essential
else
    apt-get -y --force-yes install spreads spreads-web
    # not available in stretch
    # apt-get -y install chdkptp
fi

# Create spreads configuration directoy
mkdir -p /home/spreads/.config/spreads
cp $DELIVERY_DIR/files/config.yaml /home/spreads/.config/spreads
chown -R spreads /home/spreads/.config/spreads

# Install spreads systemd service
cp $DELIVERY_DIR/files/spreads.service /etc/systemd/system/
systemctl enable spreads
