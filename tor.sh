#!bin/bash

get_ip(){
    url="https://www.myexternalip.com/raw"
    proxy="socks5://127.0.0.1:9050"
    ip=$(curl -sx "$proxy" "$url")
    if [[ "$ip" =~ ^[0-9].*[0-9]$ && "$ip" =~ [.] ]]; then
        echo "$ip"
    else
        :
    fi
}

new_ip(){
    service tor reload
    echo "[-] Your new IP: $(get_ip)"
}

if which tor > /dev/null 2>&1; then
    :
else
    echo -en "[-] Tor not found \n[-] Would you like to intall it? (Y/n)"
    read choice
    if [ "$choice" = "Y" ] || [ "$choice" = "y"] || [ -z "$choice" ]; then
        sudo apt install tor -y
        echo "[-] Tor installed"
    else
        exit
    fi
fi

service tor start
echo "[-] Set your SOCKS to 127.0.0.1:9050"

echo -n "[-] Seconds until your ip changes: "
read second

if [[ "$second" =~ ^[0-9]+$ ]]; then
    while true; do
        sleep "$second"
        new_ip
    done
else
    echo "[-] You only numbers are allowed"
    exit
fi