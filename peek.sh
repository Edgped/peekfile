if [[ -z $2 ]]; then lines=3; else lines=$2; fi
	
total_lines=$(wc -l < "$1")
double=$((2 * lines))
	
if [[ $total_lines -le $double ]] 
then 
	echo "Warning: File contains less lines than the lines requested. Displaying its full content:"
	cat "$1"
else 
	echo "Warning: File contains more lines than the lines requested. Displaying the requested lines:"
	head -n $lines $1
	echo "..."
	tail -n $lines $1
fi
