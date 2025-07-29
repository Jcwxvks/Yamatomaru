
REF_DIR=~/reference_genome
TRIM_DIR=~/trim_results
RESULTS_DIR=~/bowtie_results


krusei_ref=$REF_DIR/GCF_003054445.1_ASM305444v1_genomic.fna
krusei_prefix=krusei_REF

lusitaniae_ref=$REF_DIR/GCF_014636115.1_ASM1463611v1_genomic.fna
lusitaniae_prefix=lusitaniae_REF


bowtie2-build $krusei_ref $krusei_prefix

bowtie2-build $lusitaniae_ref $lusitaniae_prefix


krusei_samples=("CKRU1" "CKRU2" "CKRU3" "CKRU4_M981" "CKRU5_M991" "CKRU7_S01" "cvcan3_M401" "cvcan43_M451" "cvcan56_M271" "cvcan57_M281" "cvcan59_M301")

lusitaniae_samples=("CLST1_M341" "CLST2_M351" "CLST3_M361" "CLST4_M371" "cvcan20_M221" "cvcan40_M421")


for sample in "${krusei_samples[@]}"; do
    echo "processing $sample..."
    bowtie2 -x $krusei_prefix \
            -1 $TRIM_DIR/${sample}_R1-copy_val_1.fq \
            -2 $TRIM_DIR/${sample}_R2-copy_val_2.fq \
            -S $RESULTS_DIR/${sample}_paired_krusei_REF.sam \
            -p 8 -X 1000 \
            --un $RESULTS_DIR/${sample}_unaligned_krusei.fq
done

for sample in "${lusitaniae_samples[@]}"; do
    echo "processing $sample..."
    bowtie2 -x $lusitaniae_prefix \
            -1 $TRIM_DIR/${sample}_R1-copy_val_1.fq \
            -2 $TRIM_DIR/${sample}_R2-copy_val_2.fq \
            -S $RESULTS_DIR/${sample}_paired_lusitaniae_REF.sam \
            -p 8 -X 1000 \
            --un $RESULTS_DIR/${sample}_unaligned_lusitaniae.fq
done

echo "Done. Eureka!"

