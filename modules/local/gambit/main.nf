process GAMBIT_TAXONOMY {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://rpalcab/gambit:latest' :
        'docker.io/rpalcab/gambit:latest' }"

    input:
    tuple val(meta), path(fasta)
    path db

    output:
    tuple val(meta), path("*.txt"), emit: txt
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    gambit \\
        $args \\
        --db $db \\
        query \\
        -o ${prefix}_gambit.txt \\
        $fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gambit: \$(echo \$(gambit --version 2>&1)  | sed 's/.*gambit //; s/ .*\$//')
    END_VERSIONS
    """
}
