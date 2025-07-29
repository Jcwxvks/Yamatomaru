#!/bin/bash

# 设置输入和输出目录
input_dir=~/snpeff_results
output_dir=~/snp_data/C_lusitaniae

# 创建输出目录
mkdir -p "$output_dir"

# 定义基因区间（格式："CHROM START END GENE"）
declare -a gene_regions=(
    "NW_027093980.1 604481 606058 ERG11"
    "NW_027093980.1 251548 252651 ERG3"
    "NW_027093982.1 1148654 1149781 ERG6"
    "NW_027093976.1 762643 764292 MDR1"
)

# 清空突变类型统计文件
mutation_summary="$output_dir/mutation_summary.txt"
echo -e "Mutation_Type\tCount" > "$mutation_summary"

# 遍历所有样本的 VCF 文件
for vcf_file in "$input_dir"/*_annotated_C_lusitaniae.vcf; do
    # 获取样本名
    sample_name=$(basename "$vcf_file" _annotated_C_lusitaniae.vcf)

    # 结果输出文件
    output_file="$output_dir/${sample_name}_SNPs.txt"

    # 写入文件头
    echo -e "CHROM\tPOS\tREF\tALT\tQUAL\tGENE\tMUTATION_TYPE" > "$output_file"

    # 遍历基因区域
    for region in "${gene_regions[@]}"; do
        # 解析基因信息
        chrom=$(echo "$region" | awk '{print $1}')
        start=$(echo "$region" | awk '{print $2}')
        end=$(echo "$region" | awk '{print $3}')
        gene=$(echo "$region" | awk '{print $4}')

        # 筛选 SNP，提取需要的信息
        awk -v chrom="$chrom" -v start="$start" -v end="$end" -v gene="$gene" '
        BEGIN {OFS="\t"}
        !/^#/ {
            pos = $2
            if ($1 == chrom && pos >= start && pos <= end) {
                split($8, info, ";")  # 分割 INFO 字段
                mutation = "UNKNOWN"
                for (i in info) {
                    if (info[i] ~ /missense_variant/) mutation = "missense_variant"
                    else if (info[i] ~ /synonymous_variant/) mutation = "synonymous_variant"
                    else if (info[i] ~ /stop_gained/) mutation = "stop_gained"
                    else if (info[i] ~ /frameshift_variant/) mutation = "frameshift_variant"
                }
                print $1, $2, $4, $5, $6, gene, mutation
            }
        }' "$vcf_file" >> "$output_file"
    done

    echo "Processed: $sample_name"
done

# 统计所有样本的突变类型
echo "Summarizing mutation types..."
grep -h -v "GENE\tMUTATION_TYPE" "$output_dir"/*_SNPs.txt | cut -f7 | sort | uniq -c | awk '{print $2"\t"$1}' >> "$mutation_summary"

echo "Analysis completed. Results are stored in $output_dir"

