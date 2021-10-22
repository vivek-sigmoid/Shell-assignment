#!/bin/bash
file=sig.conf
component=$1
scale=$2
view=$3
count=$4
if [ -z "$view" ] || [ -z "$scale" ] || [ -z "$component" ] || [ -z "$count" ] 
then 
    echo 'Inputs cannot be blank, expecting four inputs!'
    echo '1) Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]'
    echo '2) Scale [MID/HIGH/LOW]'
    echo '3) View [Auction/Bid]'
    echo '4) Count [single digit number]' 
    exit 0 
fi
while ! [[ "$view" =~ ^Auction$|^Bid$ ]]; do
echo "The value of view has to be one of these"
echo "  -> Auction"
echo "  -> Bid"
read -p "please enter a valid value  " view
done
while ! [[ "$scale" =~ ^MID$|^HIGH$|^LOW$ ]]; do
echo "The value of scale has to be one of these"
echo "  -> MID"
echo "  -> HIGH"
echo "  -> LOW"
read -p "please enter a valid value  " scale
done
while ! [[ "$component" =~ ^INGESTOR$|^JOINER$|^WRANGLER$|^VALIDATOR$ ]]; do
echo "The value of view has to be one of these"
echo "  -> INGESTOR"
echo "  -> JOINER"
echo "  -> WRANGLER"
echo "  -> VALIDATOR"
read -p "please enter a valid value  " component
done
while ! [[ "$count" =~ ^[0-9]{1}$ ]]; do
echo "The value of view has to be a single digit +ive integer"
read -p "please enter a valid value  " count
done
if [[ $view == "Bid" ]]; then
view="vdopiasample-bid"
else 
view="vdopiasample"
fi
while read line; do
IFS=';' read current_view current_scale current_component_name ETL var5 <<< $line
IFS='=' read x current_count <<< $var5
if [ "$view" == "$current_view" ] && [ "$component" == "$current_component_name" ]
then
    break
fi
done < $file
new_line=$view";"$scale";"$component";"$ETL";"$x"="$count
$(sed -i "0,/$line/{s/$line/$new_line/}" $file)
