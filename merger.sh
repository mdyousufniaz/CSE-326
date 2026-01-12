#!/bin/bash

# Configuration
search_dir="out/puml_files"
output_dir="pdf_files"

# Create the output directory
mkdir -p "$output_dir"

# 1. Get the files
# This find command will look into subdirectories
mapfile -t svg_files < <(find "$search_dir" -type f -name "*.svg" ! -name "0.svg" | sort -V)

echo "--- Starting Parent-Folder Named PDF Conversion ---"

for input_svg in "${svg_files[@]}"; do
    # 1. Get the Parent Directory Name (e.g., Review&RatingSystem)
    parent_dir_name=$(basename "$(dirname "$input_svg")")
    
    # 2. Construct the output path using the folder name
    output_pdf="$output_dir/$parent_dir_name.pdf"
    
    abs_svg_path=$(realpath "$input_svg")
    tmp_html="$output_dir/tmp_render.html"
    
    # Create a temporary HTML wrapper for centering and landscape orientation
    echo "<html>
    <head>
        <style>
            @page { 
                size: landscape; 
                margin: 0; 
            }
            body { 
                margin: 0; 
                display: flex; 
                justify-content: center; 
                align-items: center;     
                height: 100vh;           
                background: white;
            }
            img { 
                max-width: 95%;          
                max-height: 95%; 
                object-fit: contain;     
            }
        </style>
    </head>
    <body>
        <img src=\"file://$abs_svg_path\">
    </body>
    </html>" > "$tmp_html"

    echo "Converting: $input_svg -> $output_pdf"
    
    # Print to PDF using Headless Chrome
    google-chrome --headless --disable-gpu --no-sandbox --print-to-pdf="$output_pdf" --no-pdf-header-footer "$tmp_html"
    
    # Clean up the single temporary HTML file
    rm "$tmp_html"
done

echo "---"
echo "Success! PDFs are named after their parent folders in '$output_dir'."