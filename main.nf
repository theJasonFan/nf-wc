nextflow.enable.dsl = 2

include {
    validateParameters;
    paramsHelp;
    paramsSummaryLog
} from "plugin/nf-validation"

// Print help message, supply typical command line usage for the pipeline
if (params.help) {
   log.info paramsHelp("nextflow run . --input-file input --output-file output ")
   exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

process wc {
    publishDir params.outdir, mode: 'move', overwrite: true
    input:
        path inputFile
    output:
        path outputFile
    script:
        outputFile = params.outputFile
        """
        wc -l ${inputFile} > ${outputFile}
        """
}

workflow {
    input = file params.inputFile
    wc(input) | view
}
