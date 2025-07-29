#!/bin/bash


ASSEMBLY_DIR=~/spades_results
REFERENCE_DIR=~/reference_genome
OUTPUT_DIR=~/quast_results/contigs


KRUSEI_REF="$REFERENCE_DIR/GCF_003054445.1_ASM305444v1_genomic.fasta"
LUSITANIAE_REF="$REFERENCE_DIR/GCF_014636115.1_ASM1463611v1_genomic.fasta"


mkdir -p $OUTPUT_DIR


for SAMPLE_DIR in "$ASSEMBLY_DIR"/*; do
    if [[ -d "$SAMPLE_DIR" ]]; then
        SAMPLE_NAME=$(basename "$SAMPLE_DIR")

        if [[ "$SAMPLE_NAME" == CKRU* || "$SAMPLE_NAME" == cvcan[345]* ]]; then
            REFERENCE=$KRUSEI_REF
            SPECIES="krusei"
        elif [[ "$SAMPLE_NAME" == CLST* || "$SAMPLE_NAME" == cvcan[204]* ]]; then
            REFERENCE=$LUSITANIAE_REF
            SPECIES="lusitaniae"
        else
            echo "unrecognized $SAMPLE_NAME, skipping..."
            continue
        fi

        ASSEMBLY_FILE="$SAMPLE_DIR/contigs.fasta"
        SAMPLE_OUTPUT_DIR="$OUTPUT_DIR/${SAMPLE_NAME}_quast_${SPECIES}"

        quast "$ASSEMBLY_FILE" -r "$REFERENCE" -o "$SAMPLE_OUTPUT_DIR"

        echo "Done quast for $SAMPLE_NAME, stored at $SAMPLE_OUTPUT_DIR"
    fi
done

