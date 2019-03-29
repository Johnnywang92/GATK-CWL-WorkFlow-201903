#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: GATK-docker.yml

inputs: # position 0, for java args, 1 for the jar, 2 for the tool itself
  maxIntervalSize:
    type: int?
    inputBinding:
      prefix: --maxIntervalSize
      position: 2
  inputBam_realign:
    type: File
    inputBinding:
      position: 2
      prefix: -I
    secondaryFiles:
    - ^.bai
    doc: bam file
  outputfile_realignTarget:
    type: string
    inputBinding:
      prefix: -o
      position: 2
    doc: name of the output file from realignTargetCreator
  reference:
    type: File
    inputBinding:
      position: 2
      prefix: -R
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
    doc: human reference sequence along with the secondary files.
  minReadsAtLocus:
    type: int?
    inputBinding:
      prefix: --minReadsAtLocus
      position: 2
    doc: minimum reads at a locus to enable using the entropy calculation
  windowSize:
    type: int?
    inputBinding:
      prefix: --windowSize
      position: 2
    doc: window size for calculating entropy or SNP clusters
  mismatchFraction:
    type: int?
    inputBinding:
      prefix: --mismatchFraction
      position: 2
    doc: fraction of base qualities needing to mismatch for a position to have high
      entropy
  known:
    type:
    - 'null'
    - type: array
      items: File
      inputBinding:
        prefix: --known
    inputBinding:
      position: 2
    doc: Any number of VCF files representing known SNPs and/or indels. Could be e.g.
      dbSNP and/or official 1000 Genomes indel calls. SNPs in these files will be
      ignored unless the --mismatchFraction argument is used. optional parameter.
  java_arg:
    type: string
    default: -Xmx4g
    inputBinding:
      position: 0

outputs:
  output_realignTarget:
    type: File
    outputBinding:
      glob: $(inputs.outputfile_realignTarget)

arguments:
- valueFrom: ./tmp
  position: 0
  separate: false
  prefix: -Djava.io.tmpdir=
#- valueFrom: /home/biodocker/bin/GenomeAnalysisTK-2.8-1-g932cd3a/GenomeAnalysisTK.jar
- valueFrom: /GenomeAnalysisTK.jar
  position: 1
  prefix: -jar
- valueFrom: RealignerTargetCreator
  position: 2
  prefix: -T

baseCommand: [java]
doc: |
  GATK-RealignTargetCreator.cwl is developed for CWL consortium
    It accepts 3 input files and produces a file containing list of target intervals to pass to the IndelRealigner.
    Usage: java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R reference.fasta -I input.bam --known indels.vcf -o forIndelRealigner.intervals.
