FROM debian:bullseye-slim

ARG HOST_UID=1000
ARG HOST_GID=1000

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    llvm \
    libssl-dev \
    pkg-config \
    git \
    make \
    cmake \
    zsh \
    curl \
    bc \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Add group and user with host UID/GID
RUN groupadd -g $HOST_GID runner \
    && useradd -m -u $HOST_UID -g $HOST_GID -s /bin/zsh runner


# Switch to the 'runner' user for subsequent commands
USER runner

ENV HOME=/home/runner
ENV CARGO_HOME=$HOME/.cargo
ENV PATH=$CARGO_HOME/bin:$PATH

WORKDIR $HOME

SHELL ["/bin/zsh", "-c"]

# Install rustup and the Rust nightly toolchain for the 'runner' user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo 'source $HOME/.cargo/env' >> $HOME/.zshrc \
    && source $HOME/.cargo/env && rustup install nightly && rustup default nightly

# Install Cargo tools
RUN source $HOME/.cargo/env && cargo install cargo-fuzz \
    cargo-afl \
    cargo-binutils \
    honggfuzz \
    cargo-sort \
    && cargo install cargo-nextest --locked

RUN rustup component add --toolchain nightly llvm-tools-preview clippy

# Install zsh related tools
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && cargo install starship --locked \
    && echo 'eval "$(starship init zsh)"' >> $HOME/.zshrc

# Declare volumes for move-smith and aptos-core
VOLUME ["$HOME/move-smith", "$HOME/aptos-core"]

WORKDIR $HOME/move-smith

# Default command opens zsh for interactive usage
CMD ["/bin/zsh"]
