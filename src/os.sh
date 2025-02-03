#!/usr/bin/env bash
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n ${__STD_OS_SOURCED+x} ]]; then
  __STD_OS_SOURCED=1
fi

function os::arch() {
  local arch=${HOSTTYPE:-$(uname -m)}
  case "$arch" in
  x86_64)
    arch="x86_64"
    ;;
  aarch64 | arm64)
    arch="aarch64"
    ;;
  i386 | i686)
    arch="i686"
    ;;
  *)
    echo "Unknown architecture: $arch"
    exit 1
    ;;
  esac

  echo "${arch}"
}

function os::os() {
  local os="${OSTYPE}"
  case "$os" in
  linux*)
    os="linux"
    ;;
  darwin*)
    os="darwin"
    ;;
  freebsd*)
    os="freebsd"
    ;;
  openbsd*)
    os="openbsd"
    ;;
  netbsd*)
    os="netbsd"
    ;;
  *)
    echo "Unknown OS: $os"
    exit 1
    ;;
  esac

  echo "${os}"
}

function os::target() {
  echo "$(os::arch)-$(os::os)"
}
