FROM debian:9 AS build
RUN mkdir /build && mkdir /out
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --yes \
	ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git curl

WORKDIR /build

FROM build AS neovim
ARG NEOVIM_VERSION
RUN git clone https://github.com/neovim/neovim.git
WORKDIR /build/neovim
RUN git checkout "$NEOVIM_VERSION"
RUN make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=..
RUN mkdir -p /out && cp -a build/lib build/bin runtime /out

FROM build AS rust_build
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
	| sh -s -- --profile minimal --default-toolchain stable -y

FROM rust_build AS ripgrep
ARG RIPGREP_VERSION
RUN git clone https://github.com/BurntSushi/ripgrep.git
WORKDIR /build/ripgrep
RUN git checkout "$RIPGREP_VERSION"
RUN . "$HOME/.cargo/env" && cargo build --release
RUN mkdir -p /out && cp -a target/release/rg /out

FROM rust_build AS fd
ARG FD_VERSION
RUN git clone 'https://github.com/sharkdp/fd'
WORKDIR /build/fd
RUN git checkout "$FD_VERSION"
RUN . "$HOME/.cargo/env" && cargo build --release
RUN mkdir -p /out && cp -a target/release/fd /out

FROM build AS yadm
ARG YADM_VERSION
RUN git clone 'https://github.com/TheLocehiliosan/yadm'
WORKDIR /build/yadm
RUN git checkout "$YADM_VERSION"
RUN mkdir -p /out && cp -a yadm /out

FROM alpine:3
COPY --from=neovim /out /out/opt/neovim
COPY neovim-wrapper.sh /out/bin/nvim
COPY --from=ripgrep /out/rg /out/bin/rg
COPY --from=fd /out/fd /out/bin/fd
COPY --from=yadm /out/yadm /out/bin/yadm
CMD cp -a /out/* /binaries
