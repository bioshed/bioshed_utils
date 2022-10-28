FROM continuumio/miniconda3
LABEL container.base.image = "miniconda3:python3.9"
LABEL software.name = "STAR"
RUN apt-get -y update && apt-get -y install python3-pip zip unzip
RUN pip install awscli boto3
RUN conda install -c bioconda bedtools
RUN conda install -c bioconda bcftools
RUN wget https://github.com/alexdobin/STAR/archive/2.7.10a.tar.gz
RUN tar -xzvf 2.7.10a.tar.gz -C /
ENV PATH="/STAR-2.7.10a/bin/Linux_x86_64/:$PATH"
RUN alias star='STAR'
RUN mkdir /samtools
ENV PATH="/samtools/:$PATH"
COPY samtools/bin/* /samtools/
WORKDIR /
COPY program_utils.py /
COPY file_utils.py /
COPY aws_s3_utils.py /
COPY quick_utils.py /
COPY aws_config_constants.json /
COPY specs.json /
COPY run_main.py /
ENV PATH="/usr/local/bin/:$PATH"
ENTRYPOINT ["python", "/run_main.py"]
