#!/bin/bash

# V1.0 by Arijit Basu

EDITOR="vi"
notesDir=$HOME/notes

cols=$(tput cols)
hr=$(for((i=0;$i<$cols;i++));do echo -ne ─; done)
 
createNote ()
{
        file=$(echo $1|tr " " "_")
        clear
        $EDITOR "$notesDir/$file"
        if [ -f "$notesDir/$file" ]; then
                echo "Note saved: $notesDir/$file"
        else
                echo "Note discarded !"
        fi
        echo
        return 0
}
displayNote ()
{
        file=$(echo $1|tr " " "_")
        clear
        echo "File name 	: $notesDir/$file"
	echo "Created on 	: $(ls -l $notesDir/$file | awk '{print $6" "$7", "$8}') by $(ls -l $notesDir/$file | awk '{print $3}')"
        echo $hr
        echo
        cat "$notesDir/$file"
        echo
        echo $hr
        read -p "> \"e\" to edit, \"r\" to rename, \"d\" to delete [ default: do nothing ] : " ans
        [ "$ans" = "e" ] && $EDITOR "$notesDir/$file" && clear && echo "Note saved: $notesDir/$file"
        [ "$ans" = "r" ] && clear && read -p "Enter new name: " ans && clear && mv -vi "$notesDir/$file" "$notesDir/$(echo $ans|tr ' ' '_')"
        [ "$ans" = "d" ] && clear && rm -vi "$notesDir/$file"
        return 0
}
 
[ ! -d "$notesDir" ] && mkdir -p "$notesDir" && echo "Created dir: $notesDir"
[ ! -d "$notesDir" ] && exit 1
 
if [ "$*" ]; then
        clear
        echo "Searching keywords : $*"
else
        echo
        echo "Usage:   ./note.sh KEYWORDS [e.g. ./notes.sh patching rhel kernel]"
        echo
        exit 1
fi
 
echo
 
files=$(grep -iwR $1 $notesDir|cut -d: -f1)
for arg in $*; do
        for file in $files; do
                [ "$(grep -iw $arg $file)" ] || files=$(echo -e "$files"|grep -iwv $file)
        done
done
 
fileNames=$(ls $notesDir|tr "\t" "\n")
for arg in $*; do
        for fileName in $fileNames;do
                filex=$(echo -e "$filex\n$notesDir/$fileName")
                [ "$(echo $fileName | tr '_' ' ' | grep -iw $arg)" ] || filex=$(echo -e "$filex"|grep -iwv "$notesDir/$fileName")
        done
done
files=$(echo -e "$files\n$filex"|sort -u)
 
if [ "$files" ]; then
        clear
        echo "Select option:"
        echo
        opts="<CREATE-NEW-NOTE>"
        for file in $files; do
                opts=$(echo -e "$opts\n$(basename $file)")
        done
        opts=$(echo "$opts <EXIT>")
 
        select opt in $opts; do
                [ "$opt" = "<EXIT>" ] && break
                [ "$opt" = "<CREATE-NEW-NOTE>" ] && createNote "$*" && break
                if [ "$opt" ]; then
                        displayNote "$opt"
                        break
                fi
        done
else
        clear
        read -p "No note found. Create new note? [ y/N ] : " ans
        if [ "$ans" = "y" ]||[ "$ans" = "Y" ]; then
                createNote "$*"
        else
                clear
        fi
fi
