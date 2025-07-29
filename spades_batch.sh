
input_dir=~/trim_results
output_dir=~/spades_results

source ~/miniconda3/etc/profile.d/conda.sh
conda activate spades_env


for r1_file in "$input_dir"/*_R1-copy_val_1.fq; do

    sample_name=$(basename "$r1_file" _R1-copy_val_1.fq)

    r2_file="$input_dir/${sample_name}_R2-copy_val_2.fq"

    if [[ -f "$r2_file" ]]; then
        echo "Processing sample: $sample_name"

        sample_output_dir="$output_dir/${sample_name}_spades"

        spades.py -1 "$r1_file" -2 "$r2_file" -o "$sample_output_dir"

        echo "Sample $sample_name assembly completed and stored in $sample_output_dir."
    else
        echo "R2 file for sample $sample_name not found. Skipping."
    fi
done

echo "All samples processed."

conda deactivate
