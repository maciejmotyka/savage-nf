# run savage given a list of input files or directory

# Args required to run in de-novo mode
# savage --split patch_num --min_overlap_len M --s singles.fastq --p1 paired1.fastq --p2 paired2.fastq
# add: -ref to run in reference guided mode

"""
TODO:
* calculate coverage for each sample and feed it into savage --split argument
* create a list of files in a directory or make the script operate directly on the files
"""
#---------------------

params.split = 1
params.min_overlap_len =
params.paired1 =
params.paired2 =
params.num_threads = 8
params.overlap_len_stage_c = 100
params.merge_contigs = 0
params.ref = "/home/lejno/Desktop/WDV/WDV_RefSeq.fasta"
params.out_dir = 

process doAssembly {
    input:

    output:

    """
    savage \
    -t $num_threads \
    --split $split \
    -p1 $paired1 \
    -p2 $paired2 \
    -o $out_dir
    """
}
