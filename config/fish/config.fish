function memo
    set -l BASE_DIR "$HOME/github/memo"
    set -l DATE_PATH (date +%Y/%m/%d)
    set -l TODAY_STR (date +%Y-%m-%d)
    set -l TARGET_DIR "$BASE_DIR/$DATE_PATH"
    set -l INDEX_FILE "$BASE_DIR/README.md"

    set -l PREV_DIR (find "$BASE_DIR" -maxdepth 3 -mindepth 3 -type d ! -path '*/.*' 2>/dev/null | sort -r | grep -v "$TARGET_DIR" | head -n 1)

    mkdir -p "$TARGET_DIR"

    if test -n "$PREV_DIR"
        set -l md_files "$PREV_DIR"/*.md
        if test -f "$md_files[1]"
            cp -n $md_files "$TARGET_DIR/"
        end
    end

    if not grep -q "$DATE_PATH" "$INDEX_FILE" 2>/dev/null
        set -l LINKS (find "$TARGET_DIR" -maxdepth 1 -name "*.md" -exec basename {} .md \; 2>/dev/null | sort | sed "s|^\(.*\)\$|[\1]($DATE_PATH/\1.md)|" | paste -sd "|" - | sed 's/|/ | /g')
        
        if test -z "$LINKS"
             touch "$TARGET_DIR/task.md"
             set LINKS "[task]($DATE_PATH/task.md)"
        end
        
        set -l LINK_TEXT "- **$TODAY_STR** : $LINKS"
        
        if test -f "$INDEX_FILE"
            echo "$LINK_TEXT" | cat - "$INDEX_FILE" 2>/dev/null > "$INDEX_FILE.tmp"
            mv "$INDEX_FILE.tmp" "$INDEX_FILE"
        else
            echo "$LINK_TEXT" > "$INDEX_FILE"
        end
    end

    cd "$BASE_DIR" || return
    nvim "$INDEX_FILE"
end
