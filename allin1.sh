#!/bin/bash

echo " -------------------------------"
echo " | ALLIN1 full automated recon |"
echo " |       YouTube: B4GG3R       |"
echo " -------------------------------"
echo ""
echo " --- Finding subdomains for $1 ---"
echo ""
echo " --- Using Owasp Amass ---"
amass enum -d $1 -o subs/$1_amass
echo ""
echo " --- Using crt.sh ---"
curl -s https://crt.sh/?q=%25.$1 | grep "$1" | grep "<TD>" | cut -d">" -f2 | cut -d"<" -f1 | sed s/*.//g | sort -u | tee subs/$1_crtsh
echo ""
echo " --- Using assetfinder ---"
assetfinder --subs-only $1 | grep $1 | sort -u | tee subs/$1_assetfinder
echo ""
echo " --- Using subfinder ---"
subfinder -all -d $1 -nC -nW -silent | sort -u | tee subs/$1_subfinder
cat subs/* | sort -u >> subs/$1_allsubs
echo ""
echo " --- Collecting $1 subdomain ip addresses ---"
for sub in $(cat subs/$1_allsubs); do echo "Subdomain: $sub" && dig +short $sub | tail -n1 ; done | tee dig/$1_subips
echo ""
echo " --- Trying whois for $1 ip adresses ---"
for ip in $(cat dig/$1_subips | grep -v S | sort -u); do whois -h whois.cymru.com " -v $ip"; done | tee whois/$1_ipswhois
echo ""
echo " --- Cleaning $1 ip adresses from cloudflare & incapsula ---"
cat whois/$1_ipswhois |  grep -v -e CLOUDFLARE -e INCAPSULA -e "| IP" | awk '{print $3}' | tee nocf/$1_nocfips
echo ""
echo " --- Scaning $1 ip adresses for top ports with nmap ---"
for ip in $(cat nocf/$1_nocfips); do nmap $ip -T5; done | tee nmap/$1_iports
echo ""
echo " --- Using httprobe to resolve browsable $1 subdomains ---"
cat subs/$1_allsubs | httprobe | tee httprobe/$1_https
echo ""
echo " --- Using curl to collecting $1 httprobed responses ---"
for httpr in $(cat httprobe/$1_https); do curl $httpr -I --max-time 20
echo "URL: $httpr"; done | tee curl/$1_curls
echo ""
echo " --- Using wayback machine for $1 ---"
waybackurls $1 >> wayback/$1_wayback
echo " *Saved in wayback/$1_wayback"
echo ""
echo " --- Using curl to find origin ip with virtual host ---"
for server in $(cat httprobe/$1_https); do curl $server -H "Host: $1" -I | grep -e "HTTP/" -e "Content-Length"
echo "Server: $server";done | tee virtualh/$1_virtuals
echo ""
echo " --- Done ---"
