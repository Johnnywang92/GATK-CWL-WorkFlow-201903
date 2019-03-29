#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
#- $import: envvar-global.yml
- $import: SAMTOOLS-docker.yml
- class: InlineJavascriptRequirement

inputs:
  compression_level:
    type: int?
    inputBinding:
      prefix: -l
    doc: |
      Set compression level, from 0 (uncompressed) to 9 (best)
  alignments:
    type: File
    inputBinding:
      position: 1
    doc: Input bam file.
  sort_by_name:
    type: boolean?
    inputBinding:
      prefix: -n
  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: -o
outputs:
  samtools-sort_output:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

#outputs:
#  sorted_alignments: stdout
  
stdout: $(inputs.output_name)

baseCommand: [samtools, sort]
