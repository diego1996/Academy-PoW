# This is a multi-stage docker file. See https://docs.docker.com/build/building/multi-stage/
# for details about this pattern.
# It is largely copied from Substrate
# https://github.com/paritytech/substrate/blob/master/docker/substrate_builder.Dockerfile

# For the build stage, we use an image provided by Parity
FROM docker.io/paritytech/ci-linux:production as builder
WORKDIR /plenitud-pow
COPY . /plenitud-pow
RUN cargo build --locked --release


# For the second stage, we use a minimal Ubuntu image
# Alpine does't work as explained https://stackoverflow.com/a/66974607/4184410
# Also, surprisingly, `ubuntu:latest` doesn't work and leads to "OS can't spawn worker thread: Operation not permitted"
FROM docker.io/library/ubuntu:20.04
LABEL description="Plenitud Node Template"

COPY --from=builder /plenitud-pow/target/release/plenitud-pow /usr/local/bin
COPY --from=builder /plenitud-pow/init-node-server.sh /init-node-server.sh
COPY --from=builder /plenitud-pow/plenitudSpecRaw.json /plenitudSpecRaw.json
RUN chmod +x /init-node-server.sh

RUN useradd -m -u 1000 -U -s /bin/sh -d /node-dev node-dev && \
  mkdir -p /chain-data /node-dev/.local/share && \
  chown -R node-dev:node-dev /chain-data && \
  ln -s /chain-data /node-dev/.local/share/plenitud-pow && \
  # unclutter and minimize the attack surface
  # rm -rf /usr/bin /usr/sbin && \
  # check if executable works in this container
  /usr/local/bin/plenitud-pow --version

RUN mkdir -p /data/node01 && chown -R node-dev:node-dev /data/node01

USER node-dev

EXPOSE 30333 9933 9944 9615
VOLUME ["/chain-data"]
