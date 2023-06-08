# Function to display the login form
show_login_form() {
  local email
  local password

  # Use Zenity to create the login form
  login_info=$(zenity --forms --title="Login To Investing.com" \
    --text="Enter your login credentials:" \
    --add-entry="Email" \
    --add-password="Password")
  
  if [ $? -ne 0 ]; then
    return 1  # User canceled the form
  fi

  email=$(echo "$login_info" | awk -F '|' '{print $1}')
  password=$(echo "$login_info" | awk -F '|' '{print $2}')

  # Retrieve the user details from the database (MySQL)
  user=$(mysql -hcontainers-us-west-146.railway.app -uroot -pCFLQtzJ1fgs0QGBPSmvS --port 6886 --protocol=TCP railway -se "SELECT * FROM users WHERE email='$email'")

  if [ -z "$user" ]; then
    zenity --error --title="Error" --text="Error: User with email $email does not exist."
    return 1
  fi

  # Get the stored password from the user details
  stored_password=$(echo "$user" | awk '{print $4}')

  # Compare the entered password with the stored password
  if [ "$password" = "$stored_password" ]; then
    # Set the login status to true
    USER_LOGGED_IN="true"
    zenity --info --title="Login Successful" --text="Login successful!"
  else
    zenity --error --title="Error" --text="Error: Invalid password."
  fi
}
