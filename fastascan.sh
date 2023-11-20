Fa_find=$(find . -name "*.fasta" -or -name "*.fa" | wc -l)
if [[ -z $1 ]]; then Folder=$(echo "the current FOLDER "); else Folder=$(echo "the FOLDER '$1' ");fi
		
#REPORT
echo ''
echo '## FASTA FILES REPORT ##'
echo ''
echo "In $Folder& its SUBFOLDERS there is a total of $Fa_find fasta/fa files."
echo ''
echo 'Spread across all that files, there are a total of Y unique fasta IDs'
