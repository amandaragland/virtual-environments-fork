#!/bin/bash -e
################################################################################
##  File:  rust.sh
##  Desc:  Installs Rust
################################################################################

# Source the helpers for use with the script
# shellcheck source=/images/linux/scripts/helpers/etc-environment.sh
source "$HELPER_SCRIPTS"/etc-environment.sh
# shellcheck source=/images/linux/scripts/helpers/os.sh
source "$HELPER_SCRIPTS"/os.sh

export RUSTUP_HOME=/etc/skel/.rustup
export CARGO_HOME=/etc/skel/.cargo

curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable --profile=minimal

# Initialize environment variables
source $CARGO_HOME/env

# Install common tools
rustup component add rustfmt clippy

if isUbuntu22; then
    cargo install bindgen cbindgen cargo-audit cargo-outdated
else
    cargo install --locked bindgen cbindgen cargo-audit cargo-outdated
fi

# Cleanup Cargo cache
rm -rf ${CARGO_HOME}/registry/*

# Update /etc/environemnt
# shellcheck disable=SC2016
prependEtcEnvironmentPath '$HOME/.cargo/bin'

invoke_tests "Tools" "Rust"
