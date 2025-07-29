input_dir="project_data_copies"
output_dir="trim_results"

for r1_file in ${input_dir}/*_R1-copy.fastq; do
r2_file="${r1_file/_R1-copy.fastq/_R2-copy.fastq}"
sample_name=$(basename "$r1_file" "_R1-copy.fastq")
trim_galore --stringency 5 --paired --adapter CTGTCTCTTATACACATCT --output_dir "$output_dir" \
              --length 60 --quality 20 --retain_unpaired -r1 69 -r2 69 --fastqc --phred33 \
              "$r1_file" "$r2_file"
echo "Completed trimming for $sample_name"
done
