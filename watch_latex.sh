#!/bin/bash

# Define the directory and the file to watch
WATCH_DIR="$HOME/wsl-projects/latex-resume"
FILE_TO_WATCH="HenryAsante_Resume_Main.tex"
FULL_PATH_TO_FILE="$WATCH_DIR/$FILE_TO_WATCH"

# Check if the file exists
if [ ! -f "$FULL_PATH_TO_FILE" ]; then
  echo "Error: File not found at $FULL_PATH_TO_FILE"
  exit 1
fi

echo "Watching $FULL_PATH_TO_FILE for changes..."

# Initial compilation in case you just started the script
echo "Performing initial compilation of $FILE_TO_WATCH..."
(cd "$WATCH_DIR" && pdflatex "$FILE_TO_WATCH")
echo "Initial compilation finished."

# Loop indefinitely
while true; do
  # Wait for a 'close_write' event (file saved and closed) or 'modify' event on the specific file
  # -q makes inotifywait quiet unless an event occurs
  # -e specifies the events to watch
  inotifywait -q -e close_write -e modify "$FULL_PATH_TO_FILE"

  echo "Change detected in $FILE_TO_WATCH at $(date)"
  echo "Recompiling..."

  # Change to the directory and run pdflatex
  # Running pdflatex from the directory of the .tex file is important
  # so it can find any auxiliary files, images, etc.
  (cd "$WATCH_DIR" && pdflatex "$FILE_TO_WATCH")
  # The subshell ( ) ensures that 'cd' doesn't affect the script's main working directory if needed elsewhere,
  # though in this simple script it's not strictly necessary.

  echo "Compilation finished. Waiting for next change..."
done