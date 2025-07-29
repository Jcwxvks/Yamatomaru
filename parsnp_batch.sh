#!/bin/bash


SPADES_DIR=~/spades_results
OUTPUT_DIR=~/parsnp_results
REFERENCE=~/reference_genome/GCF_003054445.1_ASM305444v1_genomic.fasta


mkdir -p ${OUTPUT_DIR}/C_krusei
mkdir -p ${OUTPUT_DIR}/C_lusitaniae


echo "Processing C. krusei samples..."
parsnp -r ${REFERENCE} \
       -d ${SPADES_DIR}/C_krusei/ \
       -p 16 \
       -c \
       -o ${OUTPUT_DIR}/C_krusei


REFERENCE=~/reference_genome/GCF_014636115.1_ASM1463611v1_genomic.fasta


echo "Processing C. lusitaniae samples..."
parsnp -r ${REFERENCE} \
       -d ${SPADES_DIR}/C_lusitaniae/ \
       -p 16 \
       -o ${OUTPUT_DIR}/C_lusitaniae

echo "Parsnp analysis completed!"

