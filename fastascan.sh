if [[ -z $1 ]]; then Folder=$(echo "the current FOLDER "); else Folder=$(echo "the FOLDER '$1' ");fi
Fa_find=$(find . -name "*.fasta" -or -name "*.fa" | grep -v "/\.") #Added a filter to avoid hidden files that generate errors in the output
Fa_find_count=$(echo "$Fa_find" | wc -l)
Fa_ids=$(grep -h ">" $Fa_find | sed 's/>//')
Fa_ids_count=$(echo "$Fa_ids" | sort | uniq -c | wc -l)

#echo "$Fa_ids"
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
echo "   -----------------------------------------"

#Start of the loop to get a header for each file:
file_counter=1
for file in $Fa_find; do
	##File name:
	echo "FILE $file_counter: $file"

	##Symlink check:
	if [[ -L "$file" ]]; then
		echo "SYMLINK (Y/N): Yes"
	else
		echo "SYMLINK (Y/N): No"
	fi
	
	##Number of seq.:
	Seq_count=$(grep -c "^>" "$file")
	
	##Nucleotides or Aminoacids?
	File_seqs=$(awk '/^>/{flag=1; next} flag{printf "%s", $0} END{print ""}' "$file")
	#echo "$File_seqs" #To check.
	
	No_nucleotides=$(echo "$File_seqs" | sed '/>/! s/[-NATCGnatcg]//g' )
	No_nucleotides_length=$(echo -n "$No_nucleotides" | wc -c)
	#echo "$No_nucleotides, $No_nucleotides_length" #To check.
	
	if [[ "$No_nucleotides_length" -gt 1 ]]; then
		Seq_type=$(echo "AMINOACIDIC")
		Seq_unit=$(echo "AMINO ACIDS")
	else
		Seq_type=$(echo "NUCLEOTIDE")
		Seq_unit=$(echo "NUCLEOTIDES")
	fi
		
	
	if [[ $Seq_count -gt 1 ]]; then
		Seq_number=$(echo "SEQUENCES")
	elif [[ $Seq_count -eq 1 ]]; then
		Seq_number=$(echo "SEQUENCE")
	else 
		Seq_number=$(echo "SEQUENCES") #In order to get "0 SEQUENCES" in the case of an empty fasta file.
	fi
	
	echo "THIS FILE CONTAINS $Seq_count $Seq_type $Seq_number" 
	
	##Seq. length:
	File_seqs_length=$(echo -n "$File_seqs" | wc -c)
	echo "TOTAL SEQUENCE LENGTH IN THE FILE: $File_seqs_length $Seq_unit"
	
	##File content:
	echo ""
	echo "CONTENT:"
	echo "AAAAAAAAAAA"
	
	echo ""
	echo "   -----------------------------------------"
	((file_counter++))
done
echo ""
