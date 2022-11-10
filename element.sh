#!/bin/bash

# echo -e "\n~~~~~ Elements of the Periodic Table ~~~~~\n"

# THIS IMPORT MAY NEED TO BE UNCOMMENTED THE FIRST TIME THE SCRIPT RUNS IN THE VM
# update the database (this has been an issue every time i start up the VM)
# echo "psql -U postgres -f periodic_table.sql"

# assign psql variable
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if there are not arguments
if [[ -z $1 ]]
then 
  # prompt for an argument
  echo "Please provide an element as an argument."
else
  SELECTED_ELEMENT=$1;
  # if input is a number
  if [[ $SELECTED_ELEMENT =~ [0-9]+ ]]
  then 
  # get atomic number from elements table
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $SELECTED_ELEMENT")
  # else if the length is greater than 2
  elif [[ ${#SELECTED_ELEMENT} > 2 ]]
  then 
    # search for element name 
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$SELECTED_ELEMENT'")
  else
    # search for symbol
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$SELECTED_ELEMENT'")
  fi
  
  # if there is no matching element
  if [[ -z $ELEMENT_RESULT ]]
  then
  # print out message
    echo "I could not find that element in the database."
  else
  # get element variables and print out the element properties
    echo "$ELEMENT_RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi