#!/bin/bash

echo " ----------------------------------------"
echo " | Installing required tools for allin1 |"
echo " | Please run this script as sudo       |"
echo " ----------------------------------------"
echo ""
echo " --- Craeting directorys ---"
mkdir curl dig httprobe nmap nocf subs virtualh wayback whois
echo ""
echo " --- Installing Owasp Amass ---"
apt install amass
echo ""
echo " --- Installing nmap ---"
apt install nmap
echo ""
echo " --- Installing golang ---"
apt install golang
echo ""
echo " --- Installing assetfinder ---"
go get -u github.com/tomnomnom/assetfinder
cp -r ~/go/bin/assetfinder /usr/bin/assetfinder
echo ""
echo " --- Installing subfinder ---"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
cp -r ~/go/bin/subfinder /usr/bin/subfinder
echo ""
echo " --- Installing httprobe ---"
go get -u github.com/tomnomnom/httprobe
echo ""
echo " --- Installing waybackurls ---"
go get github.com/tomnomnom/waybackurls
sudo cp -r ~/go/bin/waybackurls /usr/bin/waybackurls
echo ""
echo " Done"
