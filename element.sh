#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if given argument
if [[ $1 ]]
then

  # check if given argument is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then

  # assign values based on name
  SELECTION=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1';")

    # check if data assigned
    if [[ -z $SELECTION ]]
    then

      # assign values based on symbol
      SELECTION=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1';")
    fi

  else

  # assign values based on atomic number
  SELECTION=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1;")
  fi

  # check if data assigned
  if [[ -z $SELECTION ]] 
  then 
    echo "I could not find that element in the database."
  else

    #output selected data
    echo $SELECTION | while IFS='|' read TYPEID ATOMIC_NUMBER SYMBOL NAME MASS MELT BOIL TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi

else

    # output prompt for valid argument
    echo "Please provide an element as an argument."
fi
