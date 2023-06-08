#!/bin/bash

# Database configuration
DB_HOST="containers-us-west-146.railway.app"
DB_PORT="6886"
DB_USER="root"
DB_PASSWORD="CFLQtzJ1fgs0QGBPSmvS"
DB_NAME="railway"

# Function to check if the wallet table exists
check_wallet_table() {
  local query="SELECT 1 FROM information_schema.tables WHERE table_schema = '$DB_NAME' AND table_name = 'wallet' LIMIT 1"
  local result=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -e "$query" 2>/dev/null)
  if [ $? -eq 0 ] && [ "$result" = "1" ]; then
    return 0 # Wallet table exists
  else
    return 1 # Wallet table does not exist
  fi
}

# Function to create the wallet table
create_wallet_table() {
  local query="CREATE TABLE wallet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    balance DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(id)
  )"
  mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -e "$query"
  if [ $? -eq 0 ]; then
    echo "Wallet table created successfully."
  else
    echo "Error creating wallet table."
  fi
}

# Function to check if the wallet table exists, and create it if necessary
setup_wallet() {
  check_wallet_table
  if [ $? -eq 0 ]; then
    echo "Wallet table already exists."
  else
    create_wallet_table
  fi
}

# Function to check the balance of a user
check_balance() {
  local user_id="$1"
  local query="SELECT balance FROM wallet WHERE user_id = $user_id"
  local balance=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -N -e "$query")
  if [ $? -eq 0 ]; then
    echo "Balance: $balance"
  else
    echo "Error checking balance."
  fi
}

# Function to deposit funds into the wallet
deposit_funds() {
  local user_id="$1"
  local amount="$2"
  local query="UPDATE wallet SET balance = balance + $amount WHERE user_id = $user_id"
  mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -e "$query"
  if [ $? -eq 0 ]; then
    echo "Funds deposited successfully."
  else
    echo "Error depositing funds."
  fi
}

# Function to withdraw funds from the wallet
withdraw_funds() {
  local user_id="$1"
  local amount="$2"
  local query="UPDATE wallet SET balance = balance - $amount WHERE user_id = $user_id"
  mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -e "$query"
  if [ $? -eq 0 ]; then
    echo "Funds withdrawn successfully."
  else
    echo "Error withdrawing funds."
  fi
}

# Function to transfer funds between two wallets
transfer_funds() {
  local sender_id="$1"
  local receiver_id="$2"
  local amount="$3"
  local sender_query="UPDATE wallet SET balance = balance - $amount WHERE user_id = $sender_id"
  local receiver_query="UPDATE wallet SET balance = balance + $amount WHERE user_id = $receiver_id"
  mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --port "$DB_PORT" --protocol=TCP "$DB_NAME" -e "$sender_query; $receiver_query"
  if [ $? -eq 0 ]; then
    echo "Funds transferred successfully."
  else
    echo "Error transferring funds."
  fi
}

# Function to display wallet menu
display_wallet_menu() {
  clear
  echo "Wallet Menu"
  echo "1. Check Balance"
  echo "2. Deposit Funds"
  echo "3. Withdraw Funds"
  echo "4. Transfer Funds"
  echo "5. Exit"
  read -p "Enter your choice: " choice
  case $choice in
    1) read -p "Enter user ID: " user_id
       check_balance $user_id
       ;;
    2) read -p "Enter user ID: " user_id
       read -p "Enter amount to deposit: " amount
       deposit_funds $user_id $amount
       ;;
    3) read -p "Enter user ID: " user_id
       read -p "Enter amount to withdraw: " amount
       withdraw_funds $user_id $amount
       ;;
    4) read -p "Enter sender ID: " sender_id
       read -p "Enter receiver ID: " receiver_id
       read -p "Enter amount to transfer: " amount
       transfer_funds $sender_id $receiver_id $amount
       ;;
    5) exit ;;
    *) echo "Invalid choice." ;;
  esac
}

# Call the function to display the wallet menu
display_wallet_menu
