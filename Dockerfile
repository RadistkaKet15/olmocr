FROM ubuntu:latest

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y \
        poppler-utils \
        ttf-mscorefonts-installer \
        fonts-crosextra-caladea \
        fonts-crosextra-carlito \
        fontconfig \
        wget \
        git \
        && \
    rm -rf /var/lib/apt/lists/* && \
    fc-cache -fv

# Установка Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH="/opt/conda/bin:$PATH"

# Создание среды Conda
RUN conda create -n olmocr python=3.11 -y

# Активация среды и установка olmocr
SHELL ["/bin/bash", "--login", "-c"]
RUN source activate olmocr && \
    git clone https://github.com/allenai/olmocr.git /opt/olmocr && \
    cd /opt/olmocr && \
    pip install -e . && \
    pip install -e .[gpu] --find-links https://flashinfer.ai/whl/cu124/torch2.4/flash-attn

WORKDIR /workspace
CMD ["/bin/bash"]