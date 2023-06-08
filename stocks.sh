#!/bin/bash

# Function to fetch the stock data from the database
fetch_stock_data() {
  local query="SELECT identifier, symbol, open FROM stocks"
  local stocks=$(mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -e "$query")
  echo "$stocks"
}

# Function to display the stocks and allow buying
show_stock_list() {
  local stocks

  # Fetch the stock data from the database
  stocks=$(fetch_stock_data)

  # Check if the database query was successful
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch stock data from the database."
    return
  fi

  # Define rainbow color codes
  local color_red='\e[31m'
  local color_orange='\e[91m'
  local color_yellow='\e[93m'
  local color_green='\e[32m'
  local color_blue='\e[34m'
  local color_indigo='\e[35m'
  local color_violet='\e[95m'
  local color_reset='\e[0m'

  toilet STOCKS

  # Print the stock data in a tabular format with numbers and colors
  echo "-------------------------------------------------------------"
  printf "${color_yellow}%-4s %-20s %-20s %-20s${color_reset}\n" "No." "Identifier" "Symbol" "Price"
  echo "-------------------------------------------------------------"

  local count=1
  while IFS= read -r stock_entry; do
    local identifier=$(echo "$stock_entry" | awk '{print $1}')
    local symbol=$(echo "$stock_entry" | awk '{print $2}')
    local open=$(echo "$stock_entry" | awk '{print $3}')
    printf "%-4s ${color_green}%-20s %-20s %-20s${color_reset}\n" "$count." "$identifier" "$symbol" "$open"
    count=$((count + 1))
  done <<< "$stocks"

  # Read user input for stock selection
  read -p "Enter the number of the stock to buy (or 'q' to quit): " selection

  # Check if the user chose to quit
  if [ "$selection" = "q" ]; then
    return
  fi

  # Validate the user input
  if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
    echo "Invalid selection. Please enter a valid number."
    return
  fi

  # Check if the selected number is within the range of available stocks
  local total_stocks=$(echo "$stocks" | wc -l)
  if [ "$selection" -lt 1 ] || [ "$selection" -gt "$total_stocks" ]; then
    echo "Invalid selection. Please enter a number within the range of available stocks."
    return
  fi

  # TODO: Implement the logic for buying the selected stock
  echo "You selected stock number $selection"
}

# Check the user's login status
if [ "$USER_LOGGED_IN" = "true" ]; then
  # User is logged in, display the stock list
  show_stock_list
else
  # User is not logged in, run the main command
  source src/main_menu.sh
fi














# #!/bin/bash

# # Function to fetch the stock data from the database
# fetch_stock_data() {
#   local query="SELECT identifier, symbol, open FROM stocks"
#   local stocks=$(mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -e "$query")
#   echo "$stocks"
# }

# # Function to display the stocks and allow buying
# show_stock_list() {
#   local stocks

#   # Fetch the stock data from the database
#   stocks=$(fetch_stock_data)

#   # Check if the database query was successful
#   if [ $? -ne 0 ]; then
#     echo "Error: Failed to fetch stock data from the database."
#     return
#   fi

#   # Define rainbow color codes
#   local color_red='\e[31m'
#   local color_orange='\e[91m'
#   local color_yellow='\e[93m'
#   local color_green='\e[32m'
#   local color_blue='\e[34m'
#   local color_indigo='\e[35m'
#   local color_violet='\e[95m'
#   local color_reset='\e[0m'


# # figlet STOCKS | lolcat

#  toilet STOCKS

#   # Print the stock data in a tabular format with numbers and colors
#   echo "-------------------------------------------------------------"
#   printf "${color_yellow}%-4s %-20s %-20s %-20s${color_reset}\n" "No." "Identifier" "Symbol" "Price"
#   echo "-------------------------------------------------------------"

#   local count=1
#   while IFS= read -r stock_entry; do
#     local identifier=$(echo "$stock_entry" | awk '{print $1}')
#     local symbol=$(echo "$stock_entry" | awk '{print $2}')
#     local open=$(echo "$stock_entry" | awk '{print $3}')
#     printf "%-4s ${color_green}%-20s %-20s %-20s${color_reset}\n" "$count." "$identifier" "$symbol" "$open"
#     count=$((count + 1))
#   done <<< "$stocks"

#   # Read user input for stock selection
#   read -p "Enter the number of the stock to buy (or 'q' to quit): " selection

#   # Check if the user chose to quit
#   if [ "$selection" = "q" ]; then
#     return
#   fi

#   # Validate the user input
#   if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
#     echo "Invalid selection. Please enter a valid number."
#     return
#   fi

#   # Check if the selected number is within the range of available stocks
#   local total_stocks=$(echo "$stocks" | wc -l)
#   if [ "$selection" -lt 1 ] || [ "$selection" -gt "$total_stocks" ]; then
#     echo "Invalid selection. Please enter a number within the range of available stocks."
#     return
#   fi

#   # TODO: Implement the logic for buying the selected stock
#   echo "You selected stock number $selection"
# }

# # Call the function to display the stock list
# show_stock_list

