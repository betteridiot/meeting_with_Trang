#!/bin/bash
#SBATCH --job-name=star_idx_gencode
#SBATCH --partition=courses
#SBATCH -N 1
#SBATCH -c 17
#SBATCH --mem 128G
#SBATCH -t 8:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=m.sherman@northeastern.edu
#SBATCH --out=/home/%u/logs/%x_%j.log
#SBATCH --error=/home/%u/logs/%x_%j.err
shopt -s expand_aliases
CRN=$( basename $( find /courses -maxdepth 1 -type d -name "BINF6430.*" ) | cut -d "." -f2 )

module load singularity/3.10.3
alias STAR="singularity run -B '/courses:/courses' /courses/BINF6430.${CRN}/shared/singularity_containers/star-latest.sif STAR"

BASE=/courses/BINF6430.${CRN}
DATA=${BASE}/shared/gencode

OUT_DIR=${WORK}/gencode_STAR
mkdir -p ${OUT_DIR}

STAR --runThreadN ${SLURM_CPUS_PER_TASK} \
    --runMode genomeGenerate \
    --genomeDir ${OUT_DIR} \
    --genomeFastaFiles ${DATA}/GRCh38.primary_assembly.genome.fa \
    --sjdbGTFfile ${DATA}/gencode.v46.annotation.gtf\
    --sjdbOverhang 84