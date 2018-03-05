# gochat-docker
FROM fedora

ENV GOPATH=/opt/gopath/
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:/opt/go/bin:$GOBIN
ENV HOME=/opt/

RUN yum clean all && \
    yum install -y tar \
                   git-remote-bzr \
                   golang && \
    yum clean all && rm -rf /var/cache/yum/*

RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default && \
    mkdir -p /opt/gopath/ && \ 
    chown -R 1001:0 $HOME && \
    chmod -R og+rwx ${HOME}

RUN go get github.com/kevensen/openshift-gochat-client

RUN chown -R 1001:1001 $GOPATH


WORKDIR ${HOME}
USER 1001
EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "openshift-gochat-client -host=0.0.0.0:8080 -chatServer $CHAT_SERVER -templatePath=/opt/gopath/src/github.com/kevensen/openshift-gochat-client/templates/ -logtostderr"]


