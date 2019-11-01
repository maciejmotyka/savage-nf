// run savage given a list of input files or directory

// Args required to run in de-novo mode
// savage --split patch_num --min_overlap_len M --s singles.fastq --p1 paired1.fastq --p2 paired2.fastq
// add: -ref to run in reference guided mode

/*
TODO:
* calculate coverage for each sample and feed it into savage --split argument
* create a list of files in a directory or make the script operate directly on the files
*/
// ---------------------
mode = "denovo"   
params.savage_env = "/opt/anaconda2/envs/savage"
//params.reads_dir = "/home/lejno/Desktop/WDV/reads_BBDukTrimmed/fastq"
reads_dir = "/home/lejno/Desktop/nextflow"
params.split = 3 // 3 for sample 10; 2 for sample 11
//params.min_overlap_len =
params.revcomp = "--revcomp"
params.num_threads = 8
//params.overlap_len_stage_c = 100
//params.merge_contigs = 0
params.ref = "/home/lejno/Desktop/WDV/WDV_RefSeq.fasta"
//params.out_dir = "/home/lejno/Desktop/nextflow/output" 
params.out_dir = "."

samples_ch = Channel.fromFilePairs("$reads_dir/*_R{1,2}_clean.fastq")
//    .set { samples_ch }

process doAssembly {
    conda params.savage_env
    input:
    set sampleId, file(reads) from samples_ch 

    script: 
    if( mode == 'ref' ) {

    	"""
    	savage \
	--ref $ref
    	-t $params.num_threads \
    	--split $params.split \
        $params.revcomp\
    	-p1 ${reads[0]} \
    	-p2 ${reads[1]} \
	-o $params.out_dir
	"""
    }
    else if( mode == 'denovo') {

	"""
        savage \
        -t $params.num_threads \
        --split $params.split \
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

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
