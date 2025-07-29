#!/bin/bash

# 设置输入和输出目录
input_dir=~/snp_data/C_krusei
output_dir=~/snp_data/C_krusei_filtered

# 创建输出目录
mkdir -p "$output_dir"

# 遍历所有 SNP 结果文件
for snp_file in "$input_dir"/*_SNPs.txt; do
    # 获取样本名
    sample_name=$(basename "$snp_file" _SNPs.txt)

    # 过滤后的输出文件
    output_file="$output_dir/${sample_name}_SNPs_filtered.txt"

    # 过滤 QUAL < 600，保留表头
    awk 'NR==1 || $5 >= 600' "$snp_file" > "$output_file"

    echo "Filtered: $sample_name"
done

echo "Filtering completed. Filtered files are in $output_dir"

