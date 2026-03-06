params.allReads = "${params.readsDir}/*.fastq.gz"
Channel
    .fromPath( params.allReads )
    .ifEmpty { error "Cannot find any reads matching: ${params.allReads}" }
    .set {reads_for_fastqc}

process fastQC {
    publishDir params.fastqcDir, mode: 'copy'
    tag { "${reads}" }
    label 'big_mem' 

    input:
    path reads

    output:
   	path "*_fastqc.*"

    container 'biocontainers/fastqc:v0.11.9_cv8'
    script:
    """
        fastqc ${reads} 
    """
}

workflow {
    fastqc_out = fastQC(reads_for_fastqc)
}

