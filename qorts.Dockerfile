FROM rocker/tidyverse:4.1.0
LABEL container.base.image = "rocker:tidyverse"
LABEL software.name = "qorts"
RUN apt-get -y update && apt-get -y install python3-pip zip unzip
RUN pip install awscli boto3
RUN echo 'local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)})' > /.Rprofile
RUN ln -s /usr/local/lib/R/lib/libR.so /lib/x86_64-linux-gnu/libR.so
RUN R -e 'install.packages("png")'
RUN apt-get -y install default-jre
RUN R -e 'install.packages("http://hartleys.github.io/QoRTs/QoRTs_STABLE.tar.gz", repos=NULL, type="source")'
COPY QoRTs.jar /
ENV PATH="/:$PATH"
COPY qortsGenMultiQC.R /
ENV PATH="/:$PATH"
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
COPY example.txt /
ENV PATH="/usr/local/bin/:$PATH"
ENTRYPOINT ["python3", "/run_main.py"]
