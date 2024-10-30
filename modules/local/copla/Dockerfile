# Usa una imagen base de Miniconda
FROM continuumio/miniconda3

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el archivo environment.yml al contenedor
COPY environment.yml /tmp/environment.yml

# Instala el entorno desde environment.yml
RUN conda env create -f /tmp/environment.yml -n copla

# Instala dependencias adicionales para soporte gráfico (Gtk y Gdk)
RUN apt-get update && \
    apt-get install -y libgtk-3-0 libgdk-pixbuf2.0-0 libglib2.0-0 libgirepository1.0-dev gir1.2-gtk-3.0 && \
    rm -rf /var/lib/apt/lists/*

# Activa el entorno de Conda y establece el entorno como predeterminado
RUN echo "source activate copla" > ~/.bashrc
ENV PATH /opt/conda/envs/copla/bin:$PATH

# Copia el script de Python y la base de datos al contenedor
COPY  copla/ /app/copla

# Configura el comando de inicio (opcional, puede ser bash u otro script)
CMD ["bash", "-c", "source activate copla"]
