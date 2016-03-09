#!/usr/bin/env bash
# SCRIPT NAME: howdo.sh
# AUTHOR:      pluskatze 
# CREATED-AT   Tue 1. Mar 10:44:57 CET 2016
# UPDATED-AT   Wed 9. Mar 21:17:00 CET 2016
# 
# DESCRIPTION: This script allows you to do simple stackoverflow 
#              queries quickly.
#              It uses duckduckgo for initial search and then picks
#              the first stackoverflow result and prints the first
#              answer of that. 
#              It will also cache queries you make in ~/.howdo so
#              if you do the same search twice it will use your 
#              local cache instead of making a new request. 
#              This way you build up your own knowledge base for 
#              offline use!
# 
####

# colourstuff
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
NC="$(tput sgr 0)" # No Color

# *You* can change this if you want 
SITE_TO_SEARCH="stackoverflow.com"
SEARCH_ENGINE="https://duckduckgo.com/html/?q="

HOWDO_FOLDER="$HOME/.howdo"

if [[ ! -d $HOWDO_FOLDER ]]; then
    # no chache folder yet, create it!
    mkdir "$HOWDO_FOLDER"
    echo "Here howdo will cache queries you made." > "$HOWDO_FOLDER/README.txt"
fi

# this allows for fourteen word queries
PARAMS="$(echo ${@} | sed -e s/\ /+/g)"

# we got the question, now see if we already know this question:
QUESTION_CACHE_FILE="$(echo $PARAMS | sed -e s/\+/_/g)"
if [[ -f $HOWDO_FOLDER/$QUESTION_CACHE_FILE ]]; then
    # we already made that search! 
    # use the cache:
    cat "$HOWDO_FOLDER/$QUESTION_CACHE_FILE" | more
    exit
fi

# if we come here, the question is new

SEARCHQUERY="$PARAMS+site:$SITE_TO_SEARCH"

SEARCH_LINK="$SEARCH_ENGINE$SEARCHQUERY"
echo $SEARCH_LINK

# call SEARCH_ENGINE to get the STACK_LINK
STACK_LINK=$(curl -s "$SEARCH_LINK" \
             | grep href \
             | grep stackoverflow \
             | head -1 \
             | sed -e 's/.*\(http.*\)".*/\1/g')

# call STACK_LINK to get the answer
# then do some unoptimised dirty sed-foo
ANSWER=$(curl -s "$STACK_LINK" \
         | sed -n -e '/answercell/,$p' \
         | sed -e '/<tr>/,$d' \
         | sed -e "s/<code>/$GREEN/g" \
               -e "s/<\/code>/$NC/g" \
               -e "s/<a/$BLUE<a/g" \
               -e "s/<\/a>/<\/a>$NC/g" \
               -e 's/<[^>]*>//g' \
               -e 's/&lt;/</g' \
               -e 's/&amp;/\&/g' \
               -e 's/&gt;/>/g')
# steps are: 
# cut everthing above the first answer
# cut everthing below firts answer
# tag code open as green
# tag code close to normal colour
# tag link open as blue
# tag link close as normal colour
# remove HTML
# fix <,> and &

# save the result in a cache file
(echo "$BLUE=====================$NC"
echo "$ANSWER"
echo "see: [$YELLOW$STACK_LINK$NC]"
echo "$BLUE=====================$NC") > "$HOWDO_FOLDER/$QUESTION_CACHE_FILE"

# and output it
cat "$HOWDO_FOLDER/$QUESTION_CACHE_FILE" | more
# NOTE: 'more' eats colour code sadly... 

