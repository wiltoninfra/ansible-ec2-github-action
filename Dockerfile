FROM alpine:3.15.0

ARG BUILD_DATE
ARG ANSIBLE_VERSION
ARG ANSIBLE_LINT_VERSION
ARG MITOGEN_VERSION
ARG VCS_REF

ENV ANSIBLE_VERSION=5.5.0
ENV ANSIBLE_LINT_VERSION=6.0.1
ENV MITOGEN_VERSION=0.3.2
# Metadata
LABEL maintainer="CodeView Consultoria" \
      org.label-schema.url="" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.version=${ANSIBLE_VERSION} \
      org.label-schema.vcs-url="" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        py3-pip \
        py3-cryptography \
        rsync \
        sshpass \
        bash

RUN apk --update add --virtual \
        .build-deps \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base \
        curl \
 && if [ ! -z "${MITOGEN_VERSION+x}" ]; then curl -s -L https://github.com/mitogen-hq/mitogen/archive/refs/tags/v${MITOGEN_VERSION}.tar.gz | tar xzf - -C /opt/ \
 && mv /opt/mitogen-* /opt/mitogen; fi \
 && pip3 install --upgrade \
        pip \
        cffi \
 && pip3 install \
        ansible==${ANSIBLE_VERSION} \
        ansible-lint==${ANSIBLE_LINT_VERSION} \
            && pip3 install \
        awscli \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY ./src/scripts /
COPY ./src/templates /srv/

WORKDIR /ansible

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]  

# default command: display Ansible version
#CMD [ "ansible-playbook", "--version" ]




