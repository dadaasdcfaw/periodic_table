#!/bin/bash

#
#
#~~~~~ Periodic table ~~~~~
#
#

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  re='^[0-9]+$'

  # Look for atomic number
  if [[ $1 =~ $re ]] ; then
    RESULT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius,\
    boiling_point_celsius, symbol, name, type FROM properties\
    FULL JOIN elements USING(atomic_number)\
    FULL JOIN types USING(type_id)

    WHERE \
    atomic_number=$1")

  # Look for name or symbol
  else
    RESULT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, \
    boiling_point_celsius, symbol, name, type FROM properties \
    FULL JOIN elements USING(atomic_number) \
    FULL JOIN types USING(type_id) \

    WHERE symbol='$1' OR name='$1'")
  fi
  
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    #element is found
    echo "$RESULT" | while read \
    A_NUMBER BAR A_MASS BAR MELT BAR BOIL BAR SYMBOL BAR NAME BAR TYPE 
    do
      echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi