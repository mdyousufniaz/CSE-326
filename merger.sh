#!/bin/bash

search_dir="out/puml_files"
temp_dir="temp_pdfs"
mkdir -p "$temp_dir"

# 1. Get the sorted files
mapfile -t svg_files < <(find "$search_dir" -type f -name "*.svg" ! -name "0.svg" | \
    awk -F/ '{print $NF, $0}' | \
    sort -V | \
    cut -d' ' -f2-)

pdf_list=()

for i in "${!svg_files[@]}"; do
    input_svg="${svg_files[$i]}"
    abs_svg_path=$(realpath "$input_svg")
    output_pdf="$temp_dir/page_$i.pdf"
    
    # Create a temporary HTML wrapper with Landscape and Centering logic
    tmp_html="$temp_dir/temp_$i.html"
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
                justify-content: center; /* Center horizontally */
                align-items: center;     /* Center vertically */
                height: 100vh;           /* Take full height of page */
                background: white;
            }
            img { 
                max-width: 95%;          /* Leave a tiny 5% safety margin */
                max-height: 95%; 
                object-fit: contain;     /* Keep aspect ratio */
            }
        </style>
    </head>
    <body>
        <img src=\"file://$abs_svg_path\">
    </body>
    </html>" > "$tmp_html"

    echo "Processing (Landscape + Centered): $input_svg"
    
    # Print to PDF
    google-chrome --headless --disable-gpu --print-to-pdf="$output_pdf" --no-pdf-header-footer "$tmp_html"
    
    pdf_list+=("$output_pdf")
done

# 2. Merge with Ghostscript
if [ ${#pdf_list[@]} -gt 0 ]; then
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=combined.pdf "${pdf_list[@]}"
    echo "---"
    echo "Success! 'combined.pdf' created in landscape orientation."
else
    echo "No files found."
fi

# Clean up
rm -rf "$temp_dir"