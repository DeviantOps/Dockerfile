FROM debian:stretch-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Anaconda3 from continuumio
RUN set -x && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        libglib2.0-0 \
        libsm6 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        mercurial \
        openssh-client \
        procps \
        subversion \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    UNAME_M="$(uname -m)" && \
    if [ "${UNAME_M}" = "x86_64" ]; then \
        ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh"; \
        SHA256SUM="fedf9e340039557f7b5e8a8a86affa9d299f5e9820144bd7b92ae9f7ee08ac60"; \
    elif [ "${UNAME_M}" = "aarch64" ]; then \
        ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-aarch64.sh"; \
        SHA256SUM="4daacb88fbd3a6c14e28cd3b37004ed4c2643e2b187302e927eb81a074e837bc"; \
    fi && \
    wget "${ANACONDA_URL}" -O anaconda.sh -q && \
    echo "${SHA256SUM} anaconda.sh" > shasum && \
    sha256sum --check --status shasum && \
    /bin/bash anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh shasum && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    mkdir /swapzone

# from May2021
RUN apt-get update
# Born2Code
RUN apt-get install -y golang-go julia
#
# Maths
RUN apt-get install -y octave
RUN /opt/conda/bin/conda create --name gt -c conda-forge graph-tool 
# Net and DBs
RUN apt-get install -y ssh
RUN mkdir /opt2
WORKDIR /opt2
RUN apt-get -y install curl gnupg build-essential libssl-dev
#
RUN apt-get -y install sudo vim unzip unrar-free graphviz
EXPOSE 22 8443 8888
# Lisp
COPY ./lisp.sh .
RUN ["chmod","+x","./lisp.sh"]
RUN ./lisp.sh
#
# Cloning some repos
RUN mkdir repos
COPY ./repos.sh repos/.
WORKDIR /opt2/repos
RUN ["chmod","+x","./repos.sh"]
#RUN ./repos.sh
WORKDIR /opt2
# Jupyter
COPY ./jupyter.sh .
RUN ["chmod","+x","./jupyter.sh"]
RUN ./jupyter.sh

# Autostart
# Interact remotely with da Box
COPY ./rem0te.sh .
RUN ["chmod", "+x", "./rem0te.sh"]
#
CMD ["./rem0te.sh"]
#
