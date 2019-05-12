note.sh
=======
Probably the simplest and lightest note taking tool on your terminal.

Usage
-----
Download [note.sh](https://github.com/sayanarijit/note.sh/releases)

```bash
wget https://github.com/sayanarijit/note.sh/releases/download/${version}/note.sh
```

Give execute permission

```bash
chmod +x note.sh
```

Create your 1st note (Tip: default editor is vi; to change it, edit $EDITOR variable in note.sh)

```bash
./note.sh my first note
```

Write "I love cheese" and close editor. Note is created. Now lets find the note

```bash
./note.sh cheese
```

or

```bash
./note.sh first note
```

Customization
-------------
Change default editor or notes directory using followig environment variables.

```bash
export EDITOR="vim"   			# Or you favourite text editor
export NOTESDIR="$HOME/mynotes"   	# Or any location you have write access to
```
