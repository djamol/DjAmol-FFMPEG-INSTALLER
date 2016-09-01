dstring="test,POWer,TODAY, Fres styel,netwo.in"
IFS=', ' read -r -a array <<< "$dstring"
for element in "${array[@]}"
do
    echo "$element"
done
