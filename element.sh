#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then 
echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]; then 
# check if there is a matching atomic_number
ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
# if not found
if [[ -z $ATOMIC_NUMBER_RESULT ]]
then 
echo "I could not find that element in the database."
else 
# print element statment 
ELEMENT_FROM_ATOMIC_NUMBER=$($PSQL "SELECT name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
echo "$ELEMENT_FROM_ATOMIC_NUMBER" | while IFS='|' read -r NAME SYMBOL ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
do 
echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." 
done
fi
elif [[ $1 =~ ^.{1,2}$ ]]; then 
  # Check if there is a matching symbol  
  SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
if [[ -z $SYMBOL_RESULT ]]
then
echo "I could not find that element in the database."
else
# find matching element 
ELEMENT_FROM_SYMBOL=$($PSQL "SELECT atomic_number, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
# print element statement 
echo "$ELEMENT_FROM_SYMBOL" | while IFS='|' read ATOMIC_NUMBER NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
 done
 fi 
 else
  # Check if there is a matching name 
NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE name ='$1'")
if [[ -z $NAME_RESULT ]] 
then 
 echo "I could not find that element in the database."
 else 
 #find matching element 
 ELEMENT_FROM_NAME=$($PSQL "SELECT atomic_number, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
 #print element statement
 echo "$ELEMENT_FROM_NAME" | while IFS='|' read ATOMIC_NUMBER SYMBOL ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
 do
 echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
fi
fi
