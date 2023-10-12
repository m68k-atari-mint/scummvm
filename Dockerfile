ARG BUILD_DIR=/build

FROM mikrosk/m68k-atari-mint-gemlib:master as gemlib
FROM mikrosk/m68k-atari-mint-mintlib-dlmalloc:master as mintlib-dlmalloc
FROM mikrosk/m68k-atari-mint-zlib:master as zlib

FROM mikrosk/m68k-atari-mint-base:master as base
RUN apt -y update && apt -y upgrade
RUN apt -y install git

WORKDIR /src
COPY build.sh .
COPY --from=mintlib-dlmalloc ${SYSROOT_DIR} ${SYSROOT_DIR}/
COPY --from=gemlib ${SYSROOT_DIR} ${SYSROOT_DIR}/
COPY --from=zlib ${SYSROOT_DIR} ${SYSROOT_DIR}/

# renew the arguments
ARG BUILD_DIR

ENV SCUMMVM_BRANCH      master
ENV SCUMMVM_URL         https://github.com/scummvm/scummvm/archive/refs/heads/${SCUMMVM_BRANCH}.tar.gz
ENV SCUMMVM_FOLDER      scummvm-${SCUMMVM_BRANCH}
RUN wget -q -O - ${SCUMMVM_URL} | tar xzf -

RUN git clone https://github.com/mikrosk/atari_sound_setup.git atari_sound_setup.git

RUN cd ${SCUMMVM_FOLDER} \
    && ../build.sh ${BUILD_DIR}

FROM scratch

# renew the arguments
ARG BUILD_DIR

COPY --from=base ${BUILD_DIR} /
