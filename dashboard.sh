#!/bin/bash

# Function to display the dashboard menu
show_dashboard_menu() {
  # Check if the user is logged in
  if [ "$USER_LOGGED_IN" != "true" ]; then
    echo "Error: You must be logged in to access the dashboard."
    return 1
  fi

  while true; do
  
    # Display the dashboard menu
    clear
    figlet DASHBOARD | lolcat 
    # echo "==== Investing.com - Dashboard ===="
    echo -e
    echo "1. View Latest Stocks"
    echo -e
    echo "2. Your Portfolio"
    echo -e
    echo "3. Wallet"
    echo -e
    echo "4. Watchlist"
    echo -e
    echo "5. Investment Analysis"
    echo -e
    echo "6. Notifications and Alerts"
    echo -e
    echo "7. User Settings and Preferences"
    echo -e
    echo "8. Logout"
echo -e
    read -p "Enter your choice: " choice

    case $choice in
      1)
      source src/stocks.sh
     
        ;;
      2)
           source src/portfolio.sh
        ;;
      3)
        source src/wallet.sh
        ;;
      4)
        # Implement Investment Analysis functionality
        ;;
      5)
        # Implement Notifications and Alerts functionality
        ;;
      6)
        # Implement User Settings and Preferences functionality
        ;;

        7) 
        ;;
      8)
        break  # Logout and go back to the main menu
        ;;
    esac
  done
}
