if [[ -z $1 ]]; then Folder=$(echo "the current FOLDER "); else Folder=$(echo "the FOLDER '$1' ");fi
Fa_find=$(find . -name "*.fasta" -or -name "*.fa")
Fa_find_count=$(echo "$Fa_find" | wc -l)
Fa_ids_count=$(grep -h ">" $Fa_find | sed 's/>//' | sort | uniq -c | wc -l)


#REPORT
echo ""
echo "## FASTA FILES REPORT ##"
echo ""
echo "In $Folder& its SUBFOLDERS there is a total of $Fa_find_count fasta/fa files."
echo ""
echo "Spread across all those files, there are a total of $Fa_ids_count unique fasta IDs."
echo ""
echo "FILE BREAKDOWN:"
echo ""
echo "--------------------------------------"

#Start of the loop to get a header for each file:
file_counter=1
for file in $Fa_find; do
	
	echo "FILE $file_counter: $file"


	#Symlink check:
	if [[ -L "$file" ]]; then
		echo "SYMLINK (Y/N): Yes"
	else
		echo "SYMLINK (Y/N): No"
	fi
	
	
	echo "IT CONTAINS X C SEQUENCE/S" #nucleotide or aminoacid (Put if nº is > than 1...) 
	echo "TOTAL SEQUENCE LENGTH: D"
	echo ""
	echo "CONTENT:"
	echo "AAAAAAAAAAA"
	echo ""
	echo "--------------------------------------"
	((file_counter++))
done
echo ""
