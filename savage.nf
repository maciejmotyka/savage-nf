// run savage given a list of input files or directory

// Args required to run in de-novo mode
// savage --split patch_num --min_overlap_len M --s singles.fastq --p1 paired1.fastq --p2 paired2.fastq
// add: -ref to run in reference guided mode

/*
TODO:
*/

// ---------------------
mode = params.mode 
samples_ch = Channel.fromFilePairs("$params.reads_dir/*_R{1,2}_clean.fastq")

process doAssembly {
//    publishDir "./output/$sampleId", mode: 'copy', pattern: "{contigs_stage_c.fasta,contigs_stage_b.fasta}"
    publishDir "./savage_contigs", pattern: "contigs_stage_c.fasta", saveAs: {"$sampleId" + ".fasta"}
    conda params.savage_env
    input:
    set sampleId, file(reads) from samples_ch
    output:
    file "*"
    script: 
    if( mode == 'ref' ) {
    """
    SPLIT_VAL="\$(calculate_split.py \
    --ref_len $params.ref_len \
    -p1 ${reads[0]} \
    -p2 ${reads[1]})";\
    savage \
    --ref $params.ref_file \
    -t $params.num_threads \
    --split "\$SPLIT_VAL" \
    $params.revcomp\
    -p1 ${reads[0]} \
    -p2 ${reads[1]} \
    -o $params.out_dir
	"""
    }
    else if( mode == 'denovo') {
    """
    SPLIT_VAL="\$(calculate_split.py \
    --ref_len $params.ref_len \
    -p1 ${reads[0]} \
    -p2 ${reads[1]})";\
    savage \
    -t $params.num_threads \
    --split "\$SPLIT_VAL" \
    $params.revcomp\
    -p1 ${reads[0]} \
    -p2 ${reads[1]} \
    -o $params.out_dir
    """
    }
    else {
        println "Select proper mode"
    }
}
