echo -e "\e[1m\e[32m"
echo " 📌 Jangan Lupa di follow biar semangat bantu kalian 😅"
echo " 📌 Twitter  : @rehan_ssf"
echo " 📌 Telegram : @paperhang"
echo -e "\e[0m"
echo " seperti biasa di update dulu ya bang biar gak eror nanti "
echo -n " klik enter aja bang 😂 !"
read user
echo
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Install pendukung.. \e[0m" && sleep 1
echo
sudo apt install curl build-essential git wget jq make gcc tmux -y
echo