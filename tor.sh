#!bin/bash

get_ip(){
    url="https://www.myexternalip.com/raw"
    proxy="socks5://127.0.0.1:9050"
    ip=$(curl -s "$proxy" "$url")
    echo "$ip"
}

new_ip(){
    service tor reload
    echo "[-] Your new IP: $(get_ip)"
}

echo "[-] Checking for updates"
sudo apt update && sudo apt upgrade -y > /dev/null

if which tor; then
    :
else
    echo -e "[-] Tor not found \n[-] Would you like to intall it? (Y/n)"
    read choice
    if [ "$choice" = "Y" ] || [ "$choice" = "y"] || [ -z "$choice" ]; then
        sudo apt install tor -y
        echo "[-] Tor installed"
    else
        exit
    fi
fi

service start tor
echo "[-] Set your SOCKS to 127.0.0.1:9050"

echo "[-] Seconds until your ip changes: "
read second

if [[ "$second" =~ ^[0-9]+$ ]]; then
    while true; do
        sleep "$second"
        service reload tor
    done
else
    echo "[-] You only numbers are allowed"
    exit
fi