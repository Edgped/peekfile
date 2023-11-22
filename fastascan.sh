if [[ -z $1 ]]; then 
	Folder=$(echo "the current folder ") 
else 
	if [[ $1 == "." ]]; then
		Folder=$(echo "the current folder ")
	else
		Folder=$(echo "the folder '$1' ")
	fi
fi

if [[ -z $2 ]]; then 
	lines=0
else 
	lines=$2
fi

double=$((2 * lines))

report=$(echo "report_fastascan.txt")

Fa_find=$(find . -name "*.fasta" -or -name "*.fa" | grep -v "/\.") #Added a filter to avoid hidden files that generate errors in the output
Fa_find_count=$(echo "$Fa_find" | wc -l)
Fa_ids=$(grep -h ">" $Fa_find | awk '{sub(/^>/, ""); sub(/ .*/, ""); print}')
Fa_ids_count=$(echo "$Fa_ids" | sort | uniq -c | wc -l)
echo "$Fa_ids" > IDs.txt

#TERMINAL MESSAGES
echo ""
echo "NOTE: You selected $Folder& its subfolders to be analyzed"

if [[ $lines -ne 0 ]]; then
	echo "NOTE: You selected a máximum of $double lines (2 x $2) of each file to be displayed in the report."
else
	echo "NOTE: There will be no lines (from each file) displayed in the report."
fi

echo ""
echo "In $Folder& its subfolders there is a total of $Fa_find_count fasta/fa files."
echo ""
echo "Spread across all those files, there are a total of $Fa_ids_count unique fasta IDs."
echo ""
echo "Generating report..."
echo ""

#REPORT
echo "## FASTA FILES REPORT ##" > $report
echo "" >> $report
echo "In $Folder& its subfolders there is a total of $Fa_find_count fasta/fa files." >> $report
echo "" >> $report
echo "Spread across all those files, there are a total of $Fa_ids_count unique fasta IDs." >> $report
echo "" >> $report
echo "FILE BREAKDOWN:" >> $report
echo "(Displaying $double lines of each file)" >> $report
echo "" >> $report
echo "   -----------------------------------------" >> $report

#Start of the loop to get a header for each file:
file_counter=1
for file in $Fa_find; do
	##File name:
	echo "FILE $file_counter: $file" >> $report

	##Symlink check:
	if [[ -L "$file" ]]; then
		echo "SYMLINK (Y/N): Yes" >> $report
	else
		echo "SYMLINK (Y/N): No" >> $report
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
	
	echo "THIS FILE CONTAINS $Seq_count $Seq_type $Seq_number" >> $report 
	
	##Seq. length:
	File_seqs_length=$(echo -n "$File_seqs" | sed 's/[- \n]//g' | wc -c)
	echo "TOTAL SEQUENCE LENGTH IN THE FILE: $File_seqs_length $Seq_unit" >> $report
	
	##File content:
	total_lines=$(wc -l < "$file")
		
	if [[ $total_lines -le $double && $lines -ne 0 ]]; then
		echo "" >> $report
		echo "CONTENT:" >> $report
		echo "" >> $report
		echo "# Warning: File $file_counter contains less lines than the lines requested. Displaying its full content." >> $report
		echo "" >> $report
		cat "$file" >> $report
		echo "" >> $report
	elif [[ $lines -eq 0 ]]; then
		echo "" >> $report
	else
		echo "" >> $report
		echo "CONTENT:" >> $report
		echo "" >> $report
		echo "# Warning: File $file_counter contains more lines than the lines requested. Displaying the requested lines." >> $report
		echo "" >> $report
		head -n $lines $file >> $report
		echo "..." >> $report
		tail -n $lines $file >> $report
		echo "" >> $report
	fi
	
	echo "   -----------------------------------------" >> $report
	
	#TERMINAL MESSAGE
	echo " --> Added FILE $file_counter to the report file"
	((file_counter++))
	
done
((file_counter--))
echo "" >> $report
echo ""
echo " --> $file_counter files added to the report file '$report'"
echo ""
