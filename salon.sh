#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
main_menu(){
echo "Welcome to My Salon, how can I help you?"
mostrar_serv
echo "What's your phone number?"
pedir_num
pedir_hora
mensj_conf




}

mostrar_serv(){
IDYSERV=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo "$IDYSERV" | while read SERV_ID BAR SERV_NAME
do
echo "$SERV_ID) $SERV_NAME"
done
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
echo "I could not find that service. What would you like today?"
mostrar_serv
else
SERVELEGIDO=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVELEGIDO ]]
then
echo "I could not find that service. What would you like today?"
mostrar_serv
fi
fi
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
SERVICE_NAME=$(echo "$SERVICE_NAME" | sed -E 's/^ *| *$//g')
}

pedir_num(){
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
echo "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
$PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
fi
CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -E 's/^ *| *$//g')
}

pedir_hora(){
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
$PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)"
  }

mensj_conf(){
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    }



main_menu