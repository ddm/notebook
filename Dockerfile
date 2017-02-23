FROM python:3-alpine

RUN apk add --update alpine-sdk &&\
    pip install notebook requests &&\
    mkdir -p /work &&\
    mkdir -p $HOME/.jupyter/custom/ &&\
    echo "define(['base/js/namespace'],function(Jupyter){Jupyter._target = '_self';});" > $HOME/.jupyter/custom/custom.js

# prevents kernel crashes by using tini as a process subreaper for jupyter
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 /usr/bin/tini
RUN chmod +x /usr/bin/tini

EXPOSE 8888
WORKDIR /work
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''" ]
