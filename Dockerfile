FROM debian:bullseye

COPY . /rmats_build/rmats-turbo

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       cmake \
       curl \
       cython3 \
       g++ \
       gfortran \
       git \
       libblas-dev \
       libgsl-dev \
       liblapack-dev \
       make \
       python-is-python3 \
       python3-dev \
       r-base \
       r-cran-doparallel \
       r-cran-dosnow \
       r-cran-foreach \
       r-cran-getopt \
       r-cran-ggplot2 \
       r-cran-iterators \
       r-cran-mixtools \
       r-cran-nloptr \
       r-cran-rcpp \
       zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    # Use a build dir to be removed after artifacts are extracted
    && cd /rmats_build/rmats-turbo \
    # The build will source setup_environment.sh which will source ~/.bashrc.
    # Skip that by truncating setup_environment.sh
    && echo '' > setup_environment.sh \
    && ./build_rmats \
    # Copy the build results
    && mkdir /rmats \
    && cd /rmats \
    && cp /rmats_build/rmats-turbo/rmats.py ./ \
    && cp /rmats_build/rmats-turbo/cp_with_prefix.py ./ \
    && cp /rmats_build/rmats-turbo/*.so ./ \
    && mkdir rMATS_C \
    && cp /rmats_build/rmats-turbo/rMATS_C/rMATSexe ./rMATS_C \
    && mkdir rMATS_P \
    && cp /rmats_build/rmats-turbo/rMATS_P/*.py ./rMATS_P \
    && mkdir rMATS_R \
    && cp /rmats_build/rmats-turbo/rMATS_R/*.R ./rMATS_R \
    && cp /rmats_build/rmats-turbo/rmats ./ \
    && ln -s /rmats/rmats /usr/local/bin/rmats \
    # Build STAR
    && mkdir /star_build \
    && cd /star_build \
    && curl -L -O https://github.com/alexdobin/STAR/archive/refs/tags/2.7.9a.tar.gz \
    && tar -xvf 2.7.9a.tar.gz \
    && cd STAR-2.7.9a/source \
    && make STAR \
    && cp STAR /usr/local/bin

# Set defaults for running the image
#WORKDIR /rmats
#ENTRYPOINT ["python", "/rmats/rmats.py"]
#CMD ["--help"]
