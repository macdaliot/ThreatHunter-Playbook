# ThreatHunter Playbook script: Jupyter Environment Dockerfile
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM cyb3rward0g/jupyter-hunt:0.0.3
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Dockerfile ThreatHunter Playbook Project."

ARG NB_USER
ARG NB_UID
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

USER root

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER} \
    # ********* Download and decompress mordor datasets *****************
    && mkdir ${HOME}/datasets \
    && git clone https://github.com/Cyb3rWard0g/mordor.git ${HOME}/mordor \
    # ********* Download ThreatHunter Playbook as a git file *****************
    && git clone https://github.com/Cyb3rWard0g/ThreatHunter-Playbook.git ${HOME}/ThreatHunter-Playbook

COPY scripts/* ${HOME}/

RUN chown ${NB_USER} /usr/local/share/jupyter/kernels/pyspark3/kernel.json \
    && chown -R ${NB_USER}:${NB_USER} ${HOME} ${JUPYTER_DIR}

WORKDIR ${HOME}

ENTRYPOINT ["./playbooks-setup.sh"]

USER ${NB_USER}