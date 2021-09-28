#!/bin/bash -ex
# download and install latest chromedriver for linux or mac.
# required for selenium to drive a Chrome browser.

#download and install chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get -y update
apt-get install -y google-chrome-stable firefox-esr

install_dir="/usr/local/bin"
version=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
if [[ $(uname) == "Darwin" ]]; then
    url=https://chromedriver.storage.googleapis.com/$version/chromedriver_mac64.zip
elif [[ $(uname) == "Linux" ]]; then
    url=https://chromedriver.storage.googleapis.com/$version/chromedriver_linux64.zip
else
    echo "can't determine OS"
    exit 1
fi
curl "$url" --output chromedriver.zip
unzip chromedriver.zip
rm chromedriver.zip
chmod +x chromedriver
sudo mv chromedriver "$install_dir"
echo "installed chromedriver binary in $install_dir"

json=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest)
if [[ $(uname) == "Darwin" ]]; then
    url=$(echo "$json" | jq -r '.assets[].browser_download_url | select(contains("macos"))')
elif [[ $(uname) == "Linux" ]]; then
  url=$(echo "$json" | jq -r '.assets[].browser_download_url | select(endswith("linux64.tar.gz"))')
else
    echo "can't determine OS"
    exit 1
fi
curl -s -L "$url" | tar -xz
chmod +x geckodriver
sudo mv geckodriver "$install_dir"
echo "installed geckodriver binary in $install_dir"
