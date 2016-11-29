filename=$1

newfile=$(echo "$1.formatted.xml" | sed 's/[.]xml[.]gz//')
gunzip --stdout $filename | xmllint --format - > $newfile
