# Initially created 1 February 2017
FROM fedora:24
MAINTAINER Brenton Horne <brentonhorne77@gmail.com>

# Update packages and install minimum packages required for full utility
RUN dnf config-manager --add-repo http://download.opensuse.org/repositories/home:fusion809/Fedora_$(cat /etc/os-release | grep "VERSION_ID" | cut -d "=" -f 2)/home:fusion809.repo && dnf update -y && dnf groupinstall -y "RPM Development Tools" && dnf install -y bsdtar sudo hub wget vim git

# Create user packager, add them to wheel group and edit /etc/sudoers so they can perform any action without entering password
RUN useradd -m -g wheel packager && sed -i -e 's/#%wheel/%wheel/g' /etc/sudoers

# Login to packager account
USER packager

# Install my Fedora shell scripts
RUN /bin/bash -c "$(wget -cqO- https://git.io/vrsNO)"
