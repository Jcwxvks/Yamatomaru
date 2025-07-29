#!/bin/bash
input_dir="/home/kesu001/samtools_results"

for bam_file in "$input_dir"/*.sorted.bam; do

    if [[ ! -e "$bam_file" ]]; then
        echo "No .sorted.bam files found in $input_dir"
        exit 1
    fi

    base_name=$(basename "$bam_file" .sorted.bam)
    output_file="${input_dir}/${base_name}_depth.txt"

    samtools depth "$bam_file" > "$output_file"

    echo "Processed $bam_file -> $output_file"
done

