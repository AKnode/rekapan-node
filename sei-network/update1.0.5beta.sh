
#!/bin/sh


echo -e "\033[0;34m"
echo "  ▄▄▄       ██ ▄█▀ ███▄    █  ▒█████  ▓█████▄ ▓█████ "; 
echo " ▒████▄     ██▄█▒  ██ ▀█   █ ▒██▒  ██▒▒██▀ ██▌▓█   ▀ "; 
echo " ▒██  ▀█▄  ▓███▄░ ▓██  ▀█ ██▒▒██░  ██▒░██   █▌▒███   "; 
echo " ░██▄▄▄▄██ ▓██ █▄ ▓██▒  ▐▌██▒▒██   ██░░▓█▄   ▌▒▓█  ▄ ";
echo "  ▓█   ▓██▒▒██▒ █▄▒██░   ▓██░░ ████▓▒░░▒████▓ ░▒████▒";
echo "  ▒▒   ▓▒█░▒ ▒▒ ▓▒░ ▒░   ▒ ▒ ░ ▒░▒░▒░  ▒▒▓  ▒ ░░ ▒░ ░";
echo "   ▒   ▒▒ ░░ ░▒ ▒░░ ░░   ░ ▒░  ░ ▒ ▒░  ░ ▒  ▒  ░ ░  ░";
echo "   ░   ▒   ░ ░░ ░    ░   ░ ░ ░ ░ ░ ▒   ░ ░  ░    ░   ";
echo "       ░  ░░  ░            ░     ░ ░     ░       ░  ░";
echo "                                       ░             ";
echo -e "\e[0m"
echo -e "\033[0;32m"
echo "Telegram : @Paperhang                                ";
echo "Twitter  : @rehan_ssf                                ";
echo -e "\e[0m"
sleep 2
echo
# Set Vars

cd $HOME && rm $HOME/sei-chain -rf
git clone https://github.com/sei-protocol/sei-chain.git && cd $HOME/sei-chain
git checkout 1.0.5beta
git fetch --tags --force
sleep 2
make install
mv ~/go/bin/seid /usr/local/bin/seid
source $HOME/.bash_profile
seid version --long | head
echo
echo
sleep 2
systemctl restart seid && journalctl -fu seid -o cat