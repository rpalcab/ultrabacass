/*
    Run PITIS screening tools
*/

include { MOBSUITE_RECON  } from '../../modules/nf-core/mobsuite/recon/main'
include { COPLA           } from '../../modules/local/copla/main'
include { INTEGRON_FINDER } from '../../modules/local/integronfinder/main'

workflow PITIS {
    take:
    fastas      // tuple val(meta), path(contigs)

    main:
    ch_versions = Channel.empty()

    // MOBsuite
    MOBSUITE_RECON (
        fastas
    )
    ch_versions = ch_versions.mix( MOBSUITE_RECON.out.versions )

    // Verificar y canalizar plásmidos para COPLA
    // plasmids_for_copla = MOBSUITE_RECON.out.plasmids
    //                      .filter { it.plasmids.exists() }           // Solo si existen plásmidos
    //                      .map { tuple(it.meta, it.plasmids) }       // Estructura tuple val(meta), path(plasmids)

    // COPLA
    // COPLA(
    //     plasmids_for_copla
    // )

    // integron_finder
    INTEGRON_FINDER (
        fastas
    )

    emit:
    mobsuite_chr = MOBSUITE_RECON.out.chromosome
    mobsuite_report = MOBSUITE_RECON.out.contig_report
    mobsuite_pl = MOBSUITE_RECON.out.plasmids
    mobsuite_results = MOBSUITE_RECON.out.mobtyper_results

    versions = ch_versions
}
