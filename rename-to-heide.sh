#!/bin/bash

# Script to rename ryOS to heideOS throughout the codebase

echo "🔄 Starting ryOS → heideOS rename process..."

# Define replacement patterns (order matters - more specific first)
declare -A replacements=(
    # Main OS name
    ["ryOS"]="heideOS"
    ["RYOS"]="HEIDE"
    
    # Creator name references (do these first to avoid conflicts)
    ["Ryo Lu"]="Mathias Heide"
    ["Ryo (Ryo Lu)"]="Heide (Mathias Heide)"
    ["ryo (ryo lu)"]="heide (mathias heide)"
    
    # Domain references (using your heide.ai domain)
    ["https://os.ryo.lu"]="https://heide.ai"
    ["os.ryo.lu"]="heide.ai"
    ["https://ryo.lu"]="https://heide.ai"
    ["ryo.lu"]="heide.ai"
    
    # GitHub references
    ["ryokun6/ryos"]="mathias-heide/heide"
    ["https://github.com/ryokun6/ryos"]="https://github.com/mathias-heide/heide"
    
    # Email and social 
    ["me@ryo.lu"]="contact@heide.ai"
    ["https://x.com/ryolu_"]="https://x.com/mathiasheide"
    
    # Voice names
    ["Ryo v3"]="Heide v3"
    ["Ryo v2"]="Heide v2"
    
    # DJ references
    ["ryOS FM DJ Ryo"]="heideOS FM DJ Heide"
    ["DJ Ryo"]="DJ Heide"
    
    # Time references  
    ["Ryo Time"]="Heide Time"
    
    # AI assistant name (broader patterns)
    ["Ryo AI"]="Heide AI"
    
    # Store prefixes and keys
    ["ryos:"]="heide:"
    ["ryOS:"]="heideOS:"
    
    # Database names
    ["\"ryOS\""]="\"heideOS\""
    
    # Chat mentions and commands - specific patterns first
    ["username === \"ryo\""]="username === \"heide\""
    ["username?.toLowerCase() !== \"ryo\""]="username?.toLowerCase() !== \"heide\""
    ["username.toLowerCase() !== \"ryo\""]="username.toLowerCase() !== \"heide\""
    ["identifier === \"ryo\""]="identifier === \"heide\""
    ["normalizedUsername !== \"ryo\""]="normalizedUsername !== \"heide\""
    ["username?.toLowerCase() === \"ryo\""]="username?.toLowerCase() === \"heide\""
    ["username.toLowerCase() === \"ryo\""]="username.toLowerCase() === \"heide\""
    
    # Variable names
    ["isRyo"]="isHeide"
    ["generateRyoReply"]="generateHeideReply"
    ["Ryo reply"]="Heide reply"
    
    # Comments and text with ryo
    ["privileged user (ryo)"]="privileged user (heide)"
    ["admin (\"ryo\")"]="admin (\"heide\")"
    ["user is 'ryo'"]="user is 'heide'"
    ["claims* to be ryo"]="claims to be heide"
    ["request is from ryo"]="request is from heide"
    
    # General quoted ryo references
    ["\"ryo\""]="\"heide\""
    ["'ryo'"]="'heide'"
    
    # Chat mentions
    ["@ryo"]="@heide"
    
    # General Ryo with space (be careful with order)
    ["Ryo "]="Heide "
    [" Ryo "]=" Heide "
    [" Ryo."]=" Heide."
    [" Ryo,"]=" Heide,"
    [" Ryo!"]=" Heide!"
    [" Ryo?"]=" Heide?"
    
    # Backup file names
    ["ryOS-backup"]="heideOS-backup"
    ["ryOS-generated"]="heideOS-generated"
    
    # Launcher and kiosk
    ["ryOS Kiosk"]="heideOS Kiosk"
    ["Launches ryOS"]="Launches heideOS"
    
    # Terminal prompts and commands
    ["\"ryo <prompt>\""]="\"heide <prompt>\""
    ["'ryo <prompt>'"]="'heide <prompt>'"
    ["ryo <"]="heide <"
    
    # Message context where ryo appears standalone
    ["you are ryo"]="you are heide"
    ["are ryo"]="are heide"
    ["is ryo"]="is heide"
    ["from 'ryo'"]="from 'heide'"
    ["as 'ryo'"]="as 'heide'"
    ["username: \"ryo\""]="username: \"heide\""
)

# Files to exclude from replacement (binary files, large data files, etc.)
exclude_patterns=(
    "*.webp"
    "*.png" 
    "*.jpg"
    "*.jpeg"
    "*.gif"
    "*.mp3"
    "*.mp4"
    "*.jsdos"
    "*.woff*"
    "*.ttf"
    "*.otf"
    "bun.lock*"
    ".git/*"
    "node_modules/*"
    "dist/*"
    "build/*"
)

# Build find exclude arguments
exclude_args=""
for pattern in "${exclude_patterns[@]}"; do
    exclude_args="$exclude_args -not -path \"*/$pattern\""
done

# Create backup directory
backup_dir="backup-$(date +%Y%m%d-%H%M%S)"
echo "📁 Creating backup in $backup_dir/"
mkdir -p "$backup_dir"

# Find all text files for replacement
echo "🔍 Finding files to process..."
files_to_process=$(find . -type f \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./dist/*" \
    -not -path "./build/*" \
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
    -not -name "rename-to-heide.sh")

echo "📝 Processing $(echo "$files_to_process" | wc -l) files..."

# Counter for changes
total_changes=0

# Process each file
for file in $files_to_process; do
    if [[ -f "$file" ]]; then
        # Create backup of original file
        mkdir -p "$backup_dir/$(dirname "$file")"
        cp "$file" "$backup_dir/$file" 2>/dev/null
        
        # Apply replacements
        temp_file=$(mktemp)
        cp "$file" "$temp_file"
        file_changed=false
        
        for search in "${!replacements[@]}"; do
            replace="${replacements[$search]}"
            if grep -q "$search" "$temp_file" 2>/dev/null; then
                sed -i.bak "s|$search|$replace|g" "$temp_file" 2>/dev/null
                rm -f "$temp_file.bak"
                file_changed=true
                ((total_changes++))
            fi
        done
        
        # Only update file if changes were made
        if [[ "$file_changed" == true ]]; then
            mv "$temp_file" "$file"
            echo "✏️  Updated: $file"
        else
            rm "$temp_file"
        fi
    fi
done

echo ""
echo "✅ Rename complete!"
echo "📊 Total replacements made: $total_changes"
echo "💾 Backup created in: $backup_dir/"
echo ""
echo "🔧 Next steps:"
echo "   1. Update your domain/hosting settings"
echo "   2. Update any API keys or external service references"  
echo "   3. Test the application thoroughly"
echo "   4. Update your git remote if needed:"
echo "      git remote set-url origin https://github.com/mathias-heide/heide.git"
echo ""
echo "⚠️  Note: Some manual updates may still be needed for:"
echo "   - External service configurations"
echo "   - Domain DNS settings"
echo "   - API endpoint URLs"
echo ""