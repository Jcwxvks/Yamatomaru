#!/bin/bash

input_dir=~/samtools_results
output_dir=~/freebayes_results
ref_dir=~/reference_genome

for bam_file in "$input_dir"/*.sorted.bam; do

    base_name=$(basename "$bam_file" .sorted.bam)

    if [[ "$base_name" == *krusei* ]]; then
        ref_genome="${ref_dir}/GCF_003054445.1_ASM305444v1_genomic.fasta"
    elif [[ "$base_name" == *lusitaniae* ]]; then
        ref_genome="${ref_dir}/GCF_014636115.1_ASM1463611v1_genomic.fasta"
    else
        echo "cannot recognise $bam_file, skipping..."
        continue
    fi

    output_vcf="${output_dir}/${base_name}.vcf"

    freebayes -b "$bam_file" -p 1 -f "$ref_genome" -v "$output_vcf" \
              --min-coverage 10 -q 30 -i -X -u
    echo "Processed $bam_file -> $output_vcf"
done

