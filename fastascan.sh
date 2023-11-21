if [[ -z $1 ]]; then Folder=$(echo "the current FOLDER "); else Folder=$(echo "the FOLDER '$1' ");fi
Fa_find=$(find . -name "*.fasta" -or -name "*.fa")
Fa_find_count=$(echo "$Fa_find" | wc -l)
Fa_ids=$()

		
#REPORT
echo ""
echo "## FASTA FILES REPORT ##"
echo ""
echo "In $Folder& its SUBFOLDERS there is a total of $Fa_find_count fasta/fa files."
echo ""
echo "Spread across all those files, there are a total of $Fa_ids unique fasta IDs."
echo ""
echo "FILE BREAKDOWN:"
echo ""
echo "--------------------------------------"
echo "FILE: A"
echo "SYMLINK (Y/N): B"
echo "IT CONTAINS X C SEQUENCE/S" #nucleotide or aminoacid (Put if nº is > than 1...) 
echo "TOTAL SEQUENCE LENGTH: D"
echo ""
echo "CONTENT:"
echo "AAAAAAAAAAA"
echo ""
echo "--------------------------------------"
echo ""
