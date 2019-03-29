#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: GATK-docker.yml

inputs: # position 0, for java args, 1 for the jar, 2 for the tool itself
  inputBam_realign:
    type: File
    inputBinding:
      position: 2
      prefix: -I
    secondaryFiles:
    - ^.bai
    doc: bam file produced after markDups execution
  maxReadsForConsensuses:
    type: int?
    inputBinding:
      prefix: --maxReadsForConsensuses
      position: 2
    doc: Max reads used for finding the alternate consensuses (necessary to improve
      performance in deep coverage)
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
  LODThresholdForCleaning:
    type: double?
    inputBinding:
      prefix: --LODThresholdForCleaning
      position: 2
    doc: LOD threshold above which the cleaner will clean
  maxConsensuses:
    type: int?
    inputBinding:
      prefix: --maxConsensuses
      position: 2
    doc: Max alternate consensuses to try (necessary to improve performance in deep
      coverage)
  outputfile_indelRealigner:
    type: string
    inputBinding:
      position: 2
      prefix: -o
    doc: name of the output file from indelRealigner
  maxReadsInMemory:
    type: int?
    inputBinding:
      prefix: --maxReadsInMemory
      position: 2
    doc: max reads allowed to be kept in memory at a time by the SAMFileWriter
  maxIsizeForMovement:
    type: int?
    inputBinding:
      prefix: --maxIsizeForMovement
      position: 2
    doc: maximum insert size of read pairs that we attempt to realign. For expert
      users only!
  maxPositionalMoveAllowed:
    type: int?
    inputBinding:
      prefix: --maxPositionalMoveAllowed
      position: 2
    doc: Maximum positional move in basepairs that a read can be adjusted during realignment.
      For expert users only!
  bamout:
    type: File?
    inputBinding:
      prefix: --out
      position: 2
    doc: The realigned bam file. Optional parameter
  intervals:
    type: File
    inputBinding:
      position: 2
      prefix: -targetIntervals
    doc: list of intervals created by realignerTargetCreataor
  entropyThreshold:
    type: double?
    inputBinding:
      prefix: --entropyThreshold
      position: 2
    doc: Percentage of mismatches at a locus to be considered having high entropy
      (0.0 < entropy <= 1.0)
  maxReadsForRealignment:
    type: int?
    inputBinding:
      prefix: --maxReadsForRealignment
      position: 2
    doc: Max reads allowed at an interval for realignment
  known:
    type: File[]?
    doc: Any number of VCF files representing known SNPs and/or indels. Could be e.g.
      dbSNP and/or official 1000 Genomes indel calls. SNPs in these files will be
      ignored unless the --mismatchFraction argument is used. optional parameter.
  consensusDeterminationModel:
    type: string?
    inputBinding:
      prefix: --consensusDeterminationModel
      position: 2
    doc: Percentage of mismatches at a locus to be considered having high entropy
      (0.0 < entropy <= 1.0)
  noOriginalAlignmentTags:
    type: boolean?
    inputBinding:
      prefix: --noOriginalAlignmentTags
      position: 2
    doc: Dont output the original cigar or alignment start tags for each realigned
      read in the output bam
  java_arg:
    type: string
    default: -Xmx4g
    inputBinding:
      position: 0

  nWayOut:
    type: string?
    inputBinding:
      prefix: '--nWayOut '
      position: 2
    doc: Generate one output file for each input (-I) bam file (not compatible with
      -output). See the main page for more details.
outputs:
  output_indelRealigner:
    type: File
    outputBinding:
      glob: $(inputs.outputfile_indelRealigner)
    secondaryFiles:
      - ^.bai
arguments:
- valueFrom: ./tmp
  position: 0
  separate: false
  prefix: -Djava.io.tmpdir=
#- valueFrom: /home/biodocker/bin/GenomeAnalysisTK-2.8-1-g932cd3a/GenomeAnalysisTK.jar
- valueFrom: /GenomeAnalysisTK.jar
  position: 1
  prefix: -jar
- valueFrom: IndelRealigner
  position: 2
  prefix: -T
baseCommand: [java]
doc: |
  GATK-RealignTargetCreator.cwl is developed for CWL consortium
  It performs local realignment of reads around indels.
    Usage: java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R reference.fasta -I input.bam --known indels.vcf -o forIndelRealigner.intervals.
