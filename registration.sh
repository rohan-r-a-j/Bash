
# Function to display the registration form
show_registration_form() {
  local name
  local email
  local password

  # Use zenity to create the registration form
  name=$(zenity --forms --title="Registration Form For Investing.com" --text="Enter your registration details:" \
    --add-entry="Name:" \
    --add-entry="Email:" \
    --add-password="Password:")
    
  if [ $? -ne 0 ]; then
    return 1  # User canceled the form
  fi

  email=$(echo "$name" | awk -F'|' '{print $2}')
  name=$(echo "$name" | awk -F'|' '{print $1}')
  password=$(echo "$name" | awk -F'|' '{print $3}')
  
  # Validate if the user already exists in the database (MySQL)
  existing_user=$(mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -se "SELECT * FROM users WHERE email='$email'")

  if [ -n "$existing_user" ]; then
    zenity --error --title="Error" --text="Error: User with email $email already exists."
    return 1
  fi

  # Escape special characters in the password
  password_escaped=$(printf '%s' "$password" | sed -e 's/[]\/$*.^[]/\\&/g')

  # Insert the user details into the database
  mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -e "INSERT INTO users (name, email, password) VALUES ('$name', '$email', '$password_escaped')"

  zenity --info --title="Registration Successful" --text="Registration successful!" --width=300 --height=100
}













# #!/bin/bash

# # Function to display the registration form
# show_registration_form() {
#   local name
#   local email
#   local password

#   # Prompt the user for registration details
#   read -p "Enter your name: " name

#   read -p "Enter your email: " email

#   read -s -p "Enter your password: " password
#   echo

#   # Validate if the user already exists in the database (MySQL)
#   existing_user=$(mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -se "SELECT * FROM users WHERE email='$email'")

#   if [ -n "$existing_user" ]; then
#     echo "Error: User with email $email already exists."
#     return 1
#   fi

#   # Escape special characters in the password
#   password_escaped=$(printf '%s' "$password" | sed -e 's/[]\/$*.^[]/\\&/g')

#   # Insert the user details into the database
#   mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -e "INSERT INTO users (name, email, password) VALUES ('$name', '$email', '$password_escaped')"

#   echo "Registration successful!"
# }
