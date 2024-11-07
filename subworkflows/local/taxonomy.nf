include { KLEBORATE } from '../../modules/nf-core/kleborate/main'
include { MLST } from '../../modules/nf-core/mlst/main'
include { ECTYPER } from '../../modules/nf-core/ectyper/main'
include { GAMBIT_TAXONOMY } from '../../modules/local/gambit/main'

workflow TAXONOMY {

    take:
    ch_fasta
    ch_path_gambitdb

    main:
    ch_fasta
        .collect{it[1]}
        .map{ fasta -> tuple([id:'report'], fasta)}
        .set{ ch_fasta_all}

    KLEBORATE (
        ch_fasta_all
    )
    MLST (
        ch_fasta_all
    )
    ch_fasta
        .collect{it[1]}
        .map { files ->
            def fileString = files.join(',')
            [ [id: 'report'], fileString ]
        }
        .set { ch_ectyper }

    ECTYPER (
        ch_ectyper
    )
    GAMBIT_TAXONOMY (
        ch_fasta_all,
        ch_path_gambitdb    
    )

    emit:
    kleb_txt = KLEBORATE.out.txt
    mlst_tsv = MLST.out.tsv
    ectyper_tsv = ECTYPER.out.tsv
    gambit_txt = GAMBIT_TAXONOMY.out.txt
}
