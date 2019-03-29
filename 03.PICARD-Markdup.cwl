#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: PICARD-docker.yml 
- class: InlineJavascriptRequirement

inputs:
  comment:
    type: File[]?
    inputBinding:
      position: 17
    doc: Comments to include in the outputs files header. default value null.This option may be specificified 0 or more times
  groupCommandName:
    type: string?
    inputBinding:
      position: 16
      prefix: PROGRAN_GROUP_NAME=
    doc: Value of PN tag of PG record tode created
  inputFileName_markDup:
    type: File
    inputBinding:
      position: 4
      prefix: INPUT=
      separate: false
    doc: one or more input SAM or BAM file to analyze, must be coordinate sorted
  groupVersion:
    type: string?
    inputBinding:
      position: 14
      prefix: PROGRAM_GROUP_VERSION=
    doc: Value of VN tag of PG record to be created
  readSorted:
    type: boolean?
    inputBinding:
      position: 22
      prefix: ASSUME_SORTED= TRUE
    doc: Default value false.
  readOneBarcodeTag:
    type: string?
    inputBinding:
      position: 11
      prefix: READ_ONE_BARCODE_TAG=
    doc: Read one barcode SAM tag
  metricsFile:
    type: string?
    inputBinding:
      position: 6
      prefix: METRICS_FILE=
      separate: false
    doc: File to write duplication metrics to required
  regularExpression:
    type: string?
    inputBinding:
      position: 18
      prefix: READ_NAME_REGEX=
    doc: 
  pixeDistance:
    type: int?
    inputBinding:
      position: 19
      prefix: OPTICAL_DUPLICATE_PIXEL_DISTANCE
    doc: 
  tmpdir:
    type: string?
    inputBinding:
      position: 21
      prefix: TMP_DIR=
    doc: Default value null
  java_arg:
    type: string
    default: -Xmx4g
    inputBinding:
      position: 1
  recordId:
    type: string?
    inputBinding:
      position: 13
      prefix: PROGRAM_RECORD_ID=
    doc: 
  maxFileHandles:
    type: int?
    inputBinding:
      position: 8
      prefix: MAX_FILE_HANDLES_FOR_READ_MAP=
  sortRatio:
    type: double?
    inputBinding:
      position: 9
      prefix: SORTING_COLLECTION_SIZE_RATIO=
  groupCommandLine:
    type: string?
    inputBinding:
      position: 15
      prefix: PROGRAM_GROUP_COMMAND_LINE=
  removeDuplicates:
    type: boolean?
    inputBinding:
      position: 7
      prefix: REMOVE_DUPLICATES=true
  createindex:
    type: boolean?
    inputBinding:
      position: 20
      prefix: CREATE_INDEX=true
  readTwoBarcodeTag:
    type: string?
    inputBinding:
      position: 12
      prefix: READ_TWO_BARCODE_TAG=
  outputFileName_markDup:
    type: string
    inputBinding:
      position: 5
      prefix: OUTPUT=
      separate: false
  barcodetag:
    type: string?
    inputBinding:
      position: 10
      prefix: BARCODE_TAG=

outputs:
  mark-Dups_output:
    type: File
    outputBinding:
      glob: $(inputs.outputFileName_markDup)
    secondaryFiles: 
      - ^.bai
  metrics_output:
    type: File
    outputBinding:
      glob: $(inputs.metricsFile)
baseCommand: [java]

arguments:
- valueFrom: /picard.jar
  position: 2
  prefix: -jar
- valueFrom: MarkDuplicates
  position: 3

doc: |
  Usage: 
