#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Welcome to my salon ~~~\n"


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "How may I help you?" 
  SERVICES=$($PSQL "select service_id,name from services order by service_id")
  # echo -e "\n1) cut\n2) Hair cut for woman\n3) Hair cut for kid"

  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo "4) EXIT"

  read SERVICE_ID_SELECTED
  

  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) CUT ;;
    3) CUT ;;
    4) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

CUT() {
  # get customer phone number
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_PHONE_RESULT=$($PSQL "select phone from customers where phone = '$CUSTOMER_PHONE'")
  # if phone number doesn't exist
  if [[ -z $CUSTOMER_PHONE_RESULT ]]
  then
    # read name
    echo -e "\nI don't have the record of your phone, What is your name?"
    read CUSTOMER_NAME

    # read service time
    echo -e "\n when would you like your cut?"
    read SERVICE_TIME
  
    CUSTOMER_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME') ")

  # if phone exist
  else
    # get customer name
    CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")

    # read service time
    echo -e "\nHi$CUSTOMER_NAME, when would you like your cut?"
    read SERVICE_TIME
  fi

  # get customer_ID
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")

  # set up appointment
  APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  # get service
  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

  if [[ -z APPOINTMENT_RESULT ]]
  then
    echo "UNSUCESSFUL"
  else
    echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  fi
}

# WOMAN() {
# }

# KID() {
# }

EXIT() {
  echo -e "\nThank you!"
}

MAIN_MENU