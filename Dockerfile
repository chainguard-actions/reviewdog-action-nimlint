FROM nimlang/nim:alpine

ENV REVIEWDOG_VERSION=v0.20.2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

RUN wget -O /tmp/install-reviewdog.sh -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh \
    && sha256sum /tmp/install-reviewdog.sh \
    && sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && rm /tmp/install-reviewdog.sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
