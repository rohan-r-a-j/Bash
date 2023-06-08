#!/bin/bash

# Function to reset terminal settings and exit gracefully
cleanup() {
  # Reset terminal settings
  reset
  exit
}

# Set signal handler to call the cleanup function on script exit
trap cleanup EXIT

# Source the required files
source src/greeting.sh
source src/registration.sh
source src/login.sh
source src/main_menu.sh
source src/dashboard.sh
source src/stocks.sh

# Show the greeting message

show_greeting

echo -e

while true; do
  # Prompt the user to confirm understanding and proceed
  read -p "Do you understand and wish to proceed? [Y/n]: " choice

  # Convert user's choice to lowercase
  choice=${choice,,}

  if [[ $choice == "y" || $choice == "yes" ]]; then
    # User understood and wants to proceed
    echo "User selected 'I Understand'"
    # Proceed with the application logic here
    show_main_menu
    break
  elif [[ $choice == "n" || $choice == "no" ]]; then
    # User chose to cancel and exit
    echo "User selected 'Cancel and Exit'"
    exit
  else
    # User entered an invalid choice
    echo "Invalid choice. Please enter 'Y' or 'N'."
  fi
done
