snippets
Functions
----------------------------------------------

echo -e "\n\e[1m\e[32mDo you wish to restart the system right now?\e[0m" && PS3='
Choose the answer: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            reboot;
            exit
            ;;
        "No")
            break
            ;;
        *) echo -e "\e[1m\e[31mYou have chosen an unexisted option.\e[0m";;
    esac
done && echo -e "\e[1m\e[32mThank you.\e[0m";



# Loops
-----------------------------------------------

# General

IF
# The statement searches for a file and does the rest
if [ -f $tmpth/$atm ]; then
  echo "File does NOT exist";
else
  echo "File exists";
fi


# Verifies if the previous command run successfully (exit status 0) then it does the next thing

# Version 1
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo success
else
  echo failed
fi

# Version 2
RESULT=$?
if [ $RESULT == 0 ]; then
  echo success 2
else
  echo failed 2
fi

# Checking if there is any internet connection by getting ones public IP
if [[ $(curl -s ipinfo.io/ip) ]]; then
  # code
else
netconof_echo;
std_echo;
fi


# Checking if there is NO internet connection by getting ones public IP
if [[ ! $(curl -s ipinfo.io/ip) ]]; then
  echo -e "\e[31mThere is no\e[0m \e[1m\e[31minternet connection\e[0m";
else
  netcon_echo;
  std_echo;
fi


# Checking if the required link is valid
if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then
  xx;
else
  yy;
fi



FOR
# looping the values from a initially declared variable
ufw_ports="80/tcp 443/tcp 53/udp 123/udp 43/tcp 22/tcp";
for a in $ufw_ports; do
  ufw allow out $a > /dev/null;
  echo "Opening outgoing port: $a ...";
done




# Specific


# Downloading an app
if [[ $(shasum -a 256 veracrypt-1.20-setup.tar.bz2 | grep '6ecef017ba826243d934f46da8c34c516d399e85b0716ed019f681d24af7e236') ]]; then
  tar -xvf veracrypt-1.20-setup.tar.bz2;
else
  rm -rf veracrypt-1.20-setup.tar.bz2 && echo "SHA256SUM-ul arhivei descarcate nu corespunde. Arhiva a fost stearsa!" && echo ; fi;




# User interaction

# Type I
echo -e "\n\e[1m\e[32mDo you wish to restart the system right now?\e[0m" && PS3='
Choose the answer: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            reboot;
            exit
            ;;
        "No")
            break
            ;;
        *) echo -e "\e[1m\e[31mYou have chosen an unexisted option.\e[0m";;
    esac
done && echo -e "\e[1m\e[32mThank you.\e[0m";
