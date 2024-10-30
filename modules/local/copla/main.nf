process COPLA {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://rpalcab/copla:latest' :
        'docker.io/rpalcab/copla:latest' }"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.txt"), emit: txt
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def is_compressed = fasta.getName().endsWith(".gz") ? true : false
    def fasta_name = fasta.getName().replace(".gz", "")
    """
    if [ "$is_compressed" == "true" ]; then
        gzip -c -d $fasta > $fasta_name
    fi

    python3 /app/copla.py \\
        $args \\
        --db $db \\
        query \\
        -o ${prefix}_gambit.txt \\
        $fasta_name

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gambit: \$(echo \$(gambit --version 2>&1)  | sed 's/.*gambit //; s/ .*\$//')
    END_VERSIONS
    """
}
