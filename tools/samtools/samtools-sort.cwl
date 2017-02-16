cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools
baseCommand: ["samtools", "sort"]
inputs:
  bam:
    type: File
    inputBinding:
      position: 1
  sortbam:
    type: string
    inputBinding:
      position: 2
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.sortbam).*
