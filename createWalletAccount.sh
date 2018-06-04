echo "What would you like to name your wallet?"
read WALLET_NAME
if [ -f ./walletInfo.txt ]; then
  > walletInfo.txt
else
  touch walletInfo.txt
fi
cleos wallet create -n $WALLET_NAME >> walletInfo.txt
MASTER_WALLET_PASSWORD=$(sed -n '4p' walletInfo.txt | sed 's/\"//g')
echo "Wallet created: $MASTER_WALLET_PASSWORD"
cleos create key >> walletInfo.txt
PRIVATE_KEY="$(sed -n '5p' walletInfo.txt | awk '{print $NF}')"
PUBLIC_KEY="$(sed -n '6p' walletInfo.txt | awk '{print $NF}')"
echo $PRIVATE_KEY
echo $PUBLIC_KEY
echo "What would you like to name your account?"
read ACCOUNT_NAME
cleos create account eosio $ACCOUNT_NAME $PUBLIC_KEY

if [[ ! -e test-wallets-accounts ]]; then
    mkdir test-wallets-accounts
fi

# Create file with master password, private, public key, and account name
TIMESTAMP=$(date +"%T")
FILENAME_PATH=("./test-wallets-accounts/wallet-account-$TIMESTAMP.txt")
touch $FILENAME_PATH
echo "Wallet Name: $WALLET_NAME
Master Wallet Password: $MASTER_WALLET_PASSWORD
Private Key: $PRIVATE_KEY
Public Key: $PUBLIC_KEY
Account Name: $ACCOUNT_NAME" > $FILENAME_PATH

rm walletInfo.txt

echo "createWalletAccount script ended."
