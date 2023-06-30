FROM ethereum/solc:0.6.4-alpine

ARG OS_ARCH

RUN apk add --d --no-cache ca-certificates npm nodejs bash alpine-sdk git bash

RUN git clone https://github.com/bnb-chain/canonical-upgradeable-bep20.git /usr/app/canonical-upgradeable-bep20

WORKDIR /usr/app/canonical-upgradeable-bep20
COPY truffle-config.js /usr/app/canonical-upgradeable-bep20

RUN npm install -g n

# # RUN n 12.18.3 && node -v
RUN if [ "$OS_ARCH" == "arm64" ] ; then \
        n --arch arm64 12.18.3 && node -v; \
    else \
        n 12.18.3 && node -v; \
    fi

RUN npm install -g truffle@v5.1.14
RUN npm install

ENTRYPOINT [ "/bin/bash" ]