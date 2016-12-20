#!/bin/bash
#	* bootstrap machine in order to prepare for ansible playbook run
set -e

# Download and install Command Line Tools if no developer tools exist
#       * previous evaluation didn't work completely, due to gcc binary existing for vanilla os x install
#       * gcc output on vanilla osx box:
#       * 'xcode-select: note: no developer tools were found at '/Applications/Xcode.app', requesting install.
#       * Choose an option in the dialog to download the command line developer tools'
#
# Evaluate 2 conditions
#       * ensure dev tools are installed by checking the output of gcc
#       * check to see if gcc binary even exists ( original logic )
# if either of the conditions are met, install dev tools


if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
  defaults write com.apple.finder AppleShowAllFiles YES; # show hidden files
  defaults write com.apple.dock persistent-apps -array; # remove icons in Dock
  defaults write com.apple.dock tilesize -int 36; # smaller icon sizes in Dock
  defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
  defaults write com.apple.dock autohide-delay -float 0; # remove Dock show delay
  defaults write com.apple.dock orientation bottom; # place Dock on the right side of screen
  defaults write com.apple.dock autohide-time-modifier -float 0; # remove Dock show delay
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true; # show all file extensions
  killall Dock 2>/dev/null;
  killall Finder 2>/dev/null;

# install Xcode Command Line Tools
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" --verbose;
fi

if [[ ! -x /usr/local/bin/brew ]]; then
sudo ruby \
  -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
  </dev/null
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Info   | Install   | Ansible"
    brew update
    brew install python
    brew install ansible
fi

# Download and install Mas for AppStore Automation
if [[ ! -x /usr/local/bin/mas ]]; then
    echo "Info   | Install   | Mas"
    brew install mas
fi

# Download and install Java
if ! [[ $(java -version 2>&1) =~ "java version" ]]; then
    echo "Info   | Install   | Java"
    brew tap caskroom/cask
    brew cask install java
fi

# Modify the PATH
# This should be subsequently updated in shell settings
export PATH=/usr/local/bin:$PATH

ansible-playbook desktop.yml -K -e "appleid=$APPLE_ID applepass=$APPLE_PASS"
