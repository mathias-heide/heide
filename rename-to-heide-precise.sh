#!/bin/bash

# More precise ryOS to heideOS rename script
# This version uses word boundaries and specific contexts to avoid breaking code

echo "🔄 Starting precise ryOS → heideOS rename process..."

# Create backup
backup_dir="backup-precise-$(date +%Y%m%d-%H%M%S)"
echo "📁 Creating backup in $backup_dir/"
mkdir -p "$backup_dir"
cp -r . "$backup_dir/" 2>/dev/null

# Function to safely replace with word boundaries
safe_replace() {
    local search="$1"
    local replace="$2"
    local file="$3"
    
    # Use perl for better regex support with word boundaries
    perl -pi -e "s/\\b$search\\b/$replace/g" "$file" 2>/dev/null
}

# Function to replace in quotes only
quote_replace() {
    local search="$1"
    local replace="$2"
    local file="$3"
    
    # Replace only when surrounded by quotes
    perl -pi -e "s/([\"'])$search\\1/\$1$replace\$1/g" "$file" 2>/dev/null
}

# Get list of text files to process
files_to_process=$(find . -type f \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./dist/*" \
    -not -path "./build/*" \
    -not -path "./backup*/*" \
    -not -name "*.webp" \
    -not -name "*.png" \
    -not -name "*.jpg" \
    -not -name "*.jpeg" \
    -not -name "*.gif" \
    -not -name "*.mp3" \
    -not -name "*.mp4" \
    -not -name "*.jsdos" \
    -not -name "*.woff*" \
    -not -name "*.ttf" \
    -not -name "*.otf" \
    -not -name "bun.lock*" \
    -not -name "rename-to-heide*.sh")

total_changes=0

echo "📝 Processing files..."

for file in $files_to_process; do
    if [[ -f "$file" ]]; then
        file_changed=false
        
        # 1. Replace OS name variations
        if grep -q "ryOS" "$file" 2>/dev/null; then
            sed -i.bak 's/ryOS/heideOS/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 2. Replace GitHub repo references
        if grep -q "ryokun6/ryos" "$file" 2>/dev/null; then
            sed -i.bak 's|ryokun6/ryos|mathias-heide/heide|g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 3. Replace domain references
        if grep -q "os\.ryo\.lu" "$file" 2>/dev/null; then
            sed -i.bak 's|os\.ryo\.lu|heide.ai|g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        if grep -q "ryo\.lu" "$file" 2>/dev/null; then
            sed -i.bak 's|ryo\.lu|heide.ai|g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 4. Replace creator name references
        if grep -q "Ryo Lu" "$file" 2>/dev/null; then
            sed -i.bak 's/Ryo Lu/Mathias Heide/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 5. Replace AI name in context (more careful)
        if grep -q "Ryo AI" "$file" 2>/dev/null; then
            sed -i.bak 's/Ryo AI/Heide AI/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 6. Replace store prefixes
        if grep -q "ryos:" "$file" 2>/dev/null; then
            sed -i.bak 's/ryos:/heide:/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 7. Replace quoted username references (more precise)
        if grep -q '"ryo"' "$file" 2>/dev/null; then
            sed -i.bak 's/"ryo"/"heide"/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        if grep -q "'ryo'" "$file" 2>/dev/null; then
            sed -i.bak "s/'ryo'/'heide'/g" "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 8. Replace specific variable patterns
        if grep -q "isRyo" "$file" 2>/dev/null; then
            sed -i.bak 's/isRyo/isHeide/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 9. Replace @mentions
        if grep -q "@ryo" "$file" 2>/dev/null; then
            sed -i.bak 's/@ryo/@heide/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 10. Replace specific comment patterns
        if grep -q "privileged user (ryo)" "$file" 2>/dev/null; then
            sed -i.bak 's/privileged user (ryo)/privileged user (heide)/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 11. Replace voice names
        if grep -q "Ryo v[0-9]" "$file" 2>/dev/null; then
            sed -i.bak 's/Ryo v\([0-9]\)/Heide v\1/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 12. Replace specific context patterns (be very careful)
        if grep -q "identifier === \"ryo\"" "$file" 2>/dev/null; then
            sed -i.bak 's/identifier === "ryo"/identifier === "heide"/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        if grep -q "username === \"ryo\"" "$file" 2>/dev/null; then
            sed -i.bak 's/username === "ryo"/username === "heide"/g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        # 13. Replace email references
        if grep -q "me@ryo\.lu" "$file" 2>/dev/null; then
            sed -i.bak 's|me@ryo\.lu|contact@heide.ai|g' "$file"
            rm -f "$file.bak"
            file_changed=true
            ((total_changes++))
        fi
        
        if [[ "$file_changed" == true ]]; then
            echo "✏️  Updated: $file"
        fi
    fi
done

echo ""
echo "✅ Precise rename complete!"
echo "📊 Total replacements made: $total_changes"
echo "💾 Backup created in: $backup_dir/"
echo ""
echo "🔧 Test the app at: http://localhost:3000"
echo ""