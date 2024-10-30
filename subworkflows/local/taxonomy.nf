include { KLEBORATE } from '../../modules/nf-core/kleborate/main'
include { MLST } from '../../modules/nf-core/mlst/main'
include { ECTYPER } from '../../modules/nf-core/ectyper/main'
include { GAMBIT_TAXONOMY } from '../../modules/local/gambit/main'

workflow TAXONOMY {

    take:
    ch_fasta
    ch_path_gambitdb

    main:
    KLEBORATE (
        ch_fasta
    )
    MLST (
        ch_fasta
    )
    ECTYPER (
        ch_fasta
    )
    GAMBIT_TAXONOMY (
        ch_fasta,
        ch_path_gambitdb    
    )

    emit:
    kleb_txt = KLEBORATE.out.txt
    mlst_tsv = MLST.out.tsv
    ectyper_tsv = ECTYPER.out.tsv
    gambit_txt = GAMBIT_TAXONOMY.out.txt
}
