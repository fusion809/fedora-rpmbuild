# Initially created 1 February 2017
FROM fedora:24
MAINTAINER Brenton Horne <brentonhorne77@gmail.com>

# Installing dnf-plugins-core to provide dnf config-manager
RUN dnf update -y && dnf install -y dnf-plugins-core

# Update packages and install minimum packages required for full utility
RUN dnf config-manager --add-repo http://download.opensuse.org/repositories/home:fusion809/Fedora_$(cat /etc/os-release | grep "VERSION_ID" | cut -d "=" -f 2)/home:fusion809.repo && dnf update -y && dnf groupinstall -y "RPM Development Tools" && dnf install -y bsdtar git hub openssh sudo util-linux-user wget vim zsh

# Create user packager, add them to wheel group and edit /etc/sudoers so they can perform any action without entering password
RUN useradd -m -g wheel packager && sed -i -e 's/# %wheel/%wheel/g' /etc/sudoers

# Login to packager account
USER packager

# Install my Fedora shell scripts
ENV SCR $HOME/GitHub/mine/scripts
ENV FS $SCR/fedora-scripts
ENV ZSH $SCR/zsh-theme
ENV OH $HOME/.oh-my-zsh
ENV PLG $OH/plugins
ENV TH $OH/themes
RUN mkdir -p $SCR && git clone https://github.com/fusion809/fedora-scripts $FS && cp -a $FS/{Shell,.bashrc,.zshrc} $HOME/ && sudo cp -a $FS/root/{Shell,.bashrc,.zshrc} /root/
RUN git clone https://github.com/robbyrussell/oh-my-zsh $HOME/.oh-my-zsh
RUN git clone https://github.com/fusion809/zsh-theme $ZSH && cp -a $ZSH/*.zsh-theme $TH
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting $PLG/zsh-syntax-highlightinig
RUN git clone https://github.com/zsh-users/zsh-history-substring-search $PLG/zsh-history-substring-search

RUN rpmdev-setuptree
