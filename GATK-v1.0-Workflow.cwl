cwlVersion: v1.0
class: Workflow

inputs:

  reads:
    type:
      type: array
      items: File
  
  output_bwamem: string
  
  samtools-view-isbam: boolean

  output_samtools-view: string

  samtools-view-threads: string
  
  output_samtools-sort: string
  
  tmp: string

  output_markDuplicates: string

  metricsFile_markDuplicates: string

  readSorted_markDuplicates: boolean

  removeDuplicates_markDuplicates: boolean

  createIndex_markDuplicates: boolean

  output_RealignTargetCreator: string

  reference:
    type: File  
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  known:
    type:
      type: array
      items: File

  output_IndelRealigner: string

  output_BaseRecalibrator: string

  covariate:
    type:
      type: array
      items: string

  output_PrintReads: string

  output_HaplotypeCaller: string

  dbsnp: File


outputs:

  bwa_mem:
    type: File
    outputSource: bwa-mem/bwa-mem_output

  samtoolsview:
    type: File
    outputSource: samtools-view/samtools-view_output

  samtoolssort:
    type: File
    outputSource: samtools-sort/samtools-sort_output

  mark_Duplicates:
    type: File
    outputSource: markDuplicates/mark-Dups_output

  realign_Target:
    type: File
    outputSource: realignTarget/output_realignTarget

  indel_Realigner:
    type: File
    outputSource: indelRealigner/output_indelRealigner

  base_Recalibrator:
    type: File
    outputSource: baseRecalibrator/output_baseRecalibrator

  print_Reads:
    type: File
    outputSource: printReads/output_printReads

  haplotype_Caller:
    type: File
    outputSource: haplotypeCaller/output_haplotypeCaller


steps:
  bwa-mem:
    run: 00.BWA-Mem.cwl
    in:
      reads: reads
      reference: reference
      output_bwamem: output_bwamem
    
    out: [bwa-mem_output]

  samtools-view:
    run: 01.SAMTOOLS-View.cwl
    in:
      input: bwa-mem/bwa-mem_output
      isbam: samtools-view-isbam
      output_name: output_samtools-view
      threads: samtools-view-threads

    out: [samtools-view_output]

  samtools-sort:
    run: 02.SAMTOOLS-Sort.cwl
    in:
      alignments: samtools-view/samtools-view_output
      output_name: output_samtools-sort

    out: [samtools-sort_output]

  markDuplicates:
    run: 03.PICARD-Markdup.cwl
    in:

      outputFileName_markDup: output_markDuplicates

      inputFileName_markDup: samtools-sort/samtools-sort_output
      metricsFile: metricsFile_markDuplicates
      readSorted: readSorted_markDuplicates
      removeDuplicates: removeDuplicates_markDuplicates
      createindex: createIndex_markDuplicates
      tmpdir: tmp
    out: [mark-Dups_output]

  realignTarget:
    run: 04.GATK-RealignTargetCreator.cwl
    in:
      outputfile_realignTarget: output_RealignTargetCreator
      inputBam_realign: markDuplicates/mark-Dups_output
      reference: reference
      known: known

    out: [output_realignTarget]

  indelRealigner:
    run: 05.GATK-IndelRealigner.cwl
    in:
      outputfile_indelRealigner: output_IndelRealigner
      inputBam_realign: markDuplicates/mark-Dups_output
      intervals: realignTarget/output_realignTarget
      reference: reference
      known: known

    out: [output_indelRealigner]

  baseRecalibrator:
    run: 06.GATK-BaseRecalibrator.cwl
    in:
      outputfile_BaseRecalibrator: output_BaseRecalibrator
      inputBam_BaseRecalibrator: indelRealigner/output_indelRealigner
      reference: reference
      covariate: covariate
      known: known

    out: [output_baseRecalibrator]

  printReads:
    run: 07.GATK-PrintReads.cwl
    in:
      outputfile_printReads: output_PrintReads
      inputBam_printReads: indelRealigner/output_indelRealigner
      reference: reference
      input_baseRecalibrator: baseRecalibrator/output_baseRecalibrator

    out: [output_printReads]

  haplotypeCaller:
    run: 08.GATK-HaplotypeCaller.cwl
    in:
      outputfile_HaplotypeCaller: output_HaplotypeCaller
      inputBam_HaplotypeCaller: printReads/output_printReads
      reference: reference
      dbsnp: dbsnp

    out: [output_haplotypeCaller]
