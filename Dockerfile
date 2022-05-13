FROM gcr.io/cloud-marketplace/google/ubuntu2004:latest@sha256:22506a3e9d506180e9bce92e071cb6ef6b4a4956a088efbc0c0e990185f0ef7d
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    gnupg \
    unzip \
    jq
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-focal main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key add \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    fuse \
    gcsfuse \
  && apt-get clean all \
  && rm -rf /var/lib/apt/lists/*
RUN HLEDGER_VERSION=1.25 \
  && HLEDGER_BINARY_SUFFIX=-linux-x64 \
  && HLEDGER_ARCHIVE=hledger$HLEDGER_BINARY_SUFFIX.zip \
  && curl -LO https://github.com/simonmichael/hledger/releases/download/$HLEDGER_VERSION/$HLEDGER_ARCHIVE \
  && unzip $HLEDGER_ARCHIVE \
  && rm -rf $HLEDGER_ARCHIVE \
  && for binary in hledger*$HLEDGER_BINARY_SUFFIX ; \
    do \
      stripped_binary=$(echo $binary | sed "s,$HLEDGER_BINARY_SUFFIX,,") ; \
      mv -v $binary /usr/local/bin/$stripped_binary ; \
      chmod -v +x /usr/local/bin/$stripped_binary ; \
    done
RUN mkdir -p /data
WORKDIR /app
COPY run.sh .
RUN chmod -v +x run.sh
CMD ["/app/run.sh"]
