#!/bin/bash

RED="\e[31m"
NOCOLOR="\e[0m"

while true
do

curl -s https://api.denodes.xyz/logo.sh | bash && sleep 1
echo ""
echo "Welcome to the Namada One-Liner Script! 🛠

Our goal is to simplify the process of running a Namada node.
With this script, you can effortlessly select additional options right from your terminal. 
"
echo ""

PS3=$'\nPlease select an option from the list provided: '

options=(
"Run a Node (Public Testnet-15)"
"Run a Node (Campfire Testnet)"
"Shielded Expedition (Soon. Stay tuned!)"
"Namada Monitoring Tool"
"Exit"
)
COLUMNS=1
select opt in "${options[@]}"
do
case $opt in

"Run a Node (Public Testnet-15)")

touch $HOME/.bash_profile
source $HOME/.bash_profile
#if [ ! $NAMADA_WALLET ]; then
#	read -p $"Enter wallet name: " NAMADA_WALLET
#fi

if [ ! $NAMADA_ALIAS ]; then
	read -p "Enter validator name: " NAMADA_ALIAS
fi
NAMADA_WALLET=$NAMADA_ALIAS"_wallet"
if [ ! $EMAIL ]; then
	read -p "Enter yout email address:" EMAIL
fi	

echo "export NAMADA_ALIAS="$NAMADA_ALIAS"" >> $HOME/.bash_profile
echo "export NAMADA_WALLET="$NAMADA_WALLET"" >> $HOME/.bash_profile
echo "export EMAIL="$EMAIL"" >> $HOME/.bash_profile
echo "export PUBLIC_IP=$(wget -qO- eth0.me)" >> $HOME/.bash_profile
echo "export TM_HASH="v0.1.4-abciplus"" >> $HOME/.bash_profile
echo "export CHAIN_ID="shielded-expedition.88f17d1d14"" >> $HOME/.bash_profile
echo "export BASE_DIR="$HOME/.local/share/namada"" >> $HOME/.bash_profile
source $HOME/.bash_profile

apt update && sudo apt upgrade -y
apt install jq -y

mkdir -p $HOME/cometbft && cd $HOME/cometbft
wget -O cometbft.tar.gz https://github.com/cometbft/cometbft/releases/download/v0.37.2/cometbft_0.37.2_linux_amd64.tar.gz
tar -xvf cometbft.tar.gz
cp cometbft /usr/local/bin
cd $HOME
rm -rf ./cometbft

mkdir -p $HOME/namada && cd $HOME/namada
#wget -O namada.tar.gz "$(curl -s "https://api.github.com/repos/anoma/namada/releases/latest" | grep "browser_download_url" | cut -d '"' -f 4 | grep "Linux")"
wget -O namada.tar.gz https://github.com/anoma/namada/releases/download/v0.31.4/namada-v0.31.4-Linux-x86_64.tar.gz
tar -xzvf namada*.tar.gz --strip-components 1
cp ./namada* /usr/local/bin/
cd $HOME
rm -rf ./namada

namada client utils join-network --chain-id $CHAIN_ID

sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=Namada
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$BASE_DIR
Environment=CMT_LOG_LEVEL=p2p:none,pex:error
Environment=NAMADA_CMT_STDOUT=true
ExecStart=$(which namada) node ledger run
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable namadad
systemctl restart namadad

if [[ `service namadad status | grep active` =~ "running" ]]; then
        echo -e "Your namada node installed and works"
        echo -e "You can check logs by the command: journalctl -fu namadad -o cat"
    else
        echo -e "Your namada node was not installed correctly. Please reinstall"
fi

exit
;;

"Run a Node (Campfire Testnet)")
echo -e "\n${RED}"
echo -e "This network is currently not available. Please select another network. Thank you!"
echo -e "${NOCOLOR}"
break
;;

"Shielded Expedition (Soon. Stay tuned!)")
echo -e "\n${RED}"
echo -e "This network is currently not available. Please select another network. Thank you!"
echo -e "${NOCOLOR}"
break
;;

"Namada Monitoring Tool")
cat << 'EOF'

NamTool is a solution is an open-source solution that provides updates 
on your node status and key network insights, enhancing your network 
monitoring experience.

Begin using the NamTool by setting up your node monitoring and checking 
the network status. Additionally, consider setting up an X alert to stay
updated with Namada updates. You can also select your native language 
through the settings.

Try it out now: https://namtool.denodes.xyz/
EOF
break
;;

"Exit")
exit 8
;;

*) echo "invalid option $REPLY";;
esac
done
done
