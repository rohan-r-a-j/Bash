

#!/bin/bash

# Function to display the main menu
show_main_menu() {
  while true; do
    # Display the main menu
    clear
    # echo "==== Investing.com - Main Menu ===="
    figlet MAIN   MENU -c
    echo -e
    echo "1. LogIn To The Application"
    echo -e
    echo "2. Not Yet Registered? Register Now."
    echo -e
    echo "3. Exit"
echo -e
    read -p "Enter your choice: " choice
echo -e 
    case $choice in
      1)show_login_form
        if [ $? -eq 0 ]; then
          # User logged in successfully
          show_dashboard_menu
        fi
       
        ;;
      2)
       show_registration_form
        
        ;;
      3)
        break
        ;;
    esac
  done
}
