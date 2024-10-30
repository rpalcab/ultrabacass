# Usa una imagen base de Miniconda
FROM continuumio/miniconda3

# Copia el archivo environment.yml al contenedor
COPY environment.yml /tmp/environment.yml

# Instala el entorno desde environment.yml
RUN conda env create -f /tmp/environment.yml -n gambit

# Activa el entorno de Conda y establece el entorno como predeterminado
RUN echo "source activate gambit" > ~/.bashrc
ENV PATH /opt/conda/envs/gambit/bin:$PATH

# Configura el comando de inicio (opcional, puede ser bash u otro script)
CMD ["bash"]
