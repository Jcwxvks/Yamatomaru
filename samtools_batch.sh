
BOWTIE_DIR=~/bowtie_results
SAMTOOLS_DIR=~/samtools_results

for sam_file in $BOWTIE_DIR/*.sam; do
    base_name=$(basename "$sam_file" .sam)

    echo "processing $base_name..."

    bam_file="$SAMTOOLS_DIR/${base_name}.bam"
    sorted_bam_file="$SAMTOOLS_DIR/${base_name}.sorted.bam"
    idx_file="$SAMTOOLS_DIR/${base_name}.sorted.bam.bai"
    idxstats_file="$SAMTOOLS_DIR/${base_name}.idxstats.txt"

    samtools view -h -b "$sam_file" -o "$bam_file"
    if [ $? -ne 0 ]; then
        echo "Failure of transforming $sam_file!"
        continue
    fi

    samtools sort "$bam_file" -o "$sorted_bam_file"
    if [ $? -ne 0 ]; then
        echo "Failure of sorting $bam_file!"
        continue
    fi

    samtools index "$sorted_bam_file"
    if [ $? -ne 0 ]; then
        echo "Failure of indexing $sorted_bam_file!"
        continue
    fi

    samtools idxstats "$sorted_bam_file" > "$idxstats_file"
    if [ $? -ne 0 ]; then
        echo "Failure obtaining statistic information of $sorted_bam_file!"
        continue
    fi

    echo "$base_name successfully processed."
done

echo "Done. Eureka!"

