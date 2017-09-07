cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  fastq1: File
  fastq2: File
  genome_index: File
  gtf: File
  annotation_file: File

  stringtie_result_file: string

  thread: int?

outputs:
  tophat2_version_stdout_result:
    type: File
    outputSource: tophat2_stdout/tophat2_version_stdout
  tophat2_version_result:
    type: File
    outputSource: tophat2_version/version_output
  tophat2_result:
    type: File
    outputSource: tophat2/tophat2_bam
  cufflinks_version_stderr_result:
    type: File
    outputSource: cufflinks_stderr/cufflinks_version_stderr
  cufflinks_version_result:
    type: File
    outputSource: cufflinks_version/version_output
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result
  stringtie_version_stdout_result:
    type: File
    outputSource: stringtie_stdout/stringtie_version_stdout
  stringtie_version_result:
    type: File
    outputSource: stringtie_version/version_output
  stringtie_result:
    type: File
    outputSource: stringtie/stringtie_result

steps:
  tophat2_stdout:
    run: tophat2-version.cwl
    in: []
    out: [tophat2_version_stdout]
  tophat2_version:
    run: ngs-version.cwl
    in:
      infile: tophat2_stdout/tophat2_version_stdout
    out: [version_output]
  tophat2:
    run: tophat2-pe.cwl
    in:
      fq1: fastq1
      fq2: fastq2
      gi: genome_index
      gtf: gtf
      process: thread
    out: [tophat2_bam]
  cufflinks_stderr:
    run: cufflinks-version.cwl
    in: []
    out: [cufflinks_version_stderr]
  cufflinks_version:
    run: ngs-version.cwl
    in:
      infile: cufflinks_stderr/cufflinks_version_stderr
    out: [version_output]
  cufflinks:
    run: cufflinks.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      process: thread
    out: [cufflinks_result]
  stringtie_stdout:
    run: stringtie-version.cwl
    in: []
    out: [stringtie_version_stdout]
  stringtie_version:
    run: ngs-version.cwl
    in:
      infile: stringtie_stdout/stringtie_version_stdout
    out: [version_output]
  stringtie:
    run: stringtie.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      output: stringtie_result_file
    out: [stringtie_result]
