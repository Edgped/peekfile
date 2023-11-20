Fa_find=$(find . -name "*.fasta" -or -name "*.fa" | wc -l)
		
#REPORT
echo 'In this FOLDER "" & SUBFOLDERS there is a total of $Fa_find fasta/fa files.'
echo ''
echo 'There are a total of Y unique fasta IDs, spread across the following files:'
