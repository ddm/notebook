FROM python:3-alpine

RUN apk add --update alpine-sdk &&\
    pip install notebook requests &&\
    mkdir -p /work

# prevents kernel crashes by using tini as a process subreaper for jupyter
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 /usr/bin/tini
RUN chmod +x /usr/bin/tini

# allow embedding into iframes by relaxing CSP
RUN sed -i "s/\"frame-ancestors 'self'\",//g" /usr/local/lib/python$(python --version | egrep -o ' [[:digit:]]{1}.[[:digit:]]+' | cut -d ' ' -f 2)/site-packages/notebook/base/handlers.py

EXPOSE 8888
WORKDIR /work
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''" ]
