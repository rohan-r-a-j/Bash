#!/bin/bash

# Function to display the greeting message

figlet INVESTING.COM  -c | lolcat

show_greeting() {

echo -e

echo "             Investing.com - Your Partner in Wealth Creation               "
  
  local message="

Please note the following terms & conditions before going forward:

\033[1;32m- Investing involves market risk. Be aware of the potential risks and rewards.

- It is important to do thorough research and analysis before making any investment decisions.

- Read all related documents and disclosures carefully.

- Past performance is not indicative of future results.

- Consult with a financial advisor or professional for personalized investment advice.

By using this application, you agree to the above terms and conditions.\033[0m"

echo -e
  
  printf "$message\n"
}
