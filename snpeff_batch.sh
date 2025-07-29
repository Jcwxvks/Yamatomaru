#!/bin/bash


INPUT_DIR=~/freebayes_results
OUTPUT_DIR=~/snpeff_results
SNPEFF_DIR=~/softwares/snpEff
SNPEFF_JAR=$SNPEFF_DIR/snpEff.jar


mkdir -p "$OUTPUT_DIR"


for vcf_file in "$INPUT_DIR"/*.vcf; do

    filename=$(basename "$vcf_file")
    sample_name=${filename%_paired_*}

    if [[ "$filename" == *_krusei_REF.vcf ]]; then
        species="C_krusei"
    elif [[ "$filename" == *_lusitaniae_REF.vcf ]]; then
        species="C_lusitaniae"
    else
        echo "UNABLE RECOGNIZING: $filename"
        continue
    fi


    output_file="$OUTPUT_DIR/${sample_name}_annotated_${species}.vcf"


    echo "FILE: $filename (SPECIES: $species)"
    java -Xmx4g -jar "$SNPEFF_JAR" -v "$species" "$vcf_file" > "$output_file"

    if [[ $? -eq 0 ]]; then
        echo "DONE: $output_file"
    else
        echo "FAILED: $filename"
    fi
done

echo "ALL DONE. STORED AT $OUTPUT_DIR"

