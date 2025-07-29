#!/bin/bash

GENE_FILE="C_krusei_gene.txt"
VCF_DIR=~/snpeff_results
OUT_DIR=~/snp_data_krusei

mkdir -p "$OUT_DIR"

# 构建 GeneID -> GeneName 映射
declare -A gene_map
while IFS=$'\t' read -r gene_name gene_id; do
  gene_map["$gene_id"]="$gene_name"
done < "$GENE_FILE"

# 遍历每个 VCF 文件
for vcf in "$VCF_DIR"/*_annotated_C_krusei.vcf; do
  sample_name=$(basename "$vcf" "_annotated_C_krusri.vcf")
  out_file="$OUT_DIR/${sample_name}_snps.tsv"
  echo -e "CHROM\tPOS\tGENE\tREF\tALT\tQUAL\tCODING\tPROTEIN\tTYPE" > "$out_file"

  grep -v "^#" "$vcf" | while IFS=$'\t' read -r chrom pos id ref alt qual filter info format rest; do
    # 如果 QUAL 不是数字或为空，跳过
    if ! [[ "$qual" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
      continue
    fi
    # 筛选 QUAL > 600
    if (( $(echo "$qual <= 600" | bc -l) )); then
      continue
    fi

    # 提取 ANN 字段
    ann_field=$(echo "$info" | grep -oP "ANN=[^;]*" | sed 's/ANN=//')
    IFS=',' read -ra annotations <<< "$ann_field"

    for ann in "${annotations[@]}"; do
      IFS='|' read -ra ann_parts <<< "$ann"

      # 防止数组越界
      [[ ${#ann_parts[@]} -lt 11 ]] && continue

      effect="${ann_parts[1]}"
      gene_id_raw="${ann_parts[4]}"             # 例：gene-C5L36_0B00930
      gene_id=$(echo "$gene_id_raw" | sed 's/^gene-//')

      coding_change="${ann_parts[9]}"
      protein_change="${ann_parts[10]}"

      gene_name="${gene_map[$gene_id]}"

      # 若 gene_id 匹配成功，则记录
      if [[ -n "$gene_name" ]]; then
        echo -e "${chrom}\t${pos}\t${gene_name}\t${ref}\t${alt}\t${qual}\t${coding_change}\t${protein_change}\t${effect}" >> "$out_file"
        break  # 一条记录只输出一次
      fi
    done
  done
done


