#!/usr/bin/env bash
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n "${__NONSTDLIB_SOURCED+x}" ]]; then
  __NONSTDLIB_SOURCED=1
fi

__NONSTDLIB_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/src"


function std::echoerr() {
  # Echoing '-e' or '-n' as the first arg will cause the flag to be enabled, like with regular echo

  local newline=true;
  local escape=false;

  # Stupid way to check the first arg, but it works with so few options
  case "$1" in
    -n)
      newline=false
      shift
      ;;
    -e)
      escape=true
      shift
      ;;
    -ne)
      newline=false
      escape=true
      shift
      ;;
    -en)
      newline=false
      escape=true
      shift
      ;;
  esac

  local message="$*"

  if [[ "${escape}" == "true"  ]]; then
    echo -ne "${message}" >&2
  else
    echo -n "${message}" >&2
  fi

  if [[ "${newline}" == "true" ]]; then
    echo >&2
  fi
}


# Global variables must be declared here, since we source this script in our scripts, but the 'use' function sources scripts in the 'use' function.
# If we didn't declare them here, they would be local to the 'use' function's scope

SUCCESS=0
FAILURE=1
USAGE_ERROR=2
CANNOT_EXECUTE=126
COMMAND_NOT_FOUND=127


# Map log level names to value
declare -A __LOG_LEVELS=(
  ["TRACE"]=1
  ["DEBUG"]=2
  ["INFO"]=3
  ["WARN"]=4
  ["ERROR"]=5
)
declare -r __LOG_LEVELS

__DEFAULT_LOG_LEVEL="INFO"
__DEFAULT_LOG_FORMAT="[%level]"

# Log level changed by 'log::init' function
__LOG_LEVEL="${__DEFAULT_LOG_LEVEL}"



STD_COLOR_RED='\033[0;31m'
STD_COLOR_GREEN='\033[0;32m'
STD_COLOR_YELLOW='\033[0;33m'
STD_COLOR_BLUE='\033[0;34m'
STD_COLOR_CYAN='\033[0;36m'
STD_COLOR_NC='\033[0m' # No Color
# Store all color options
declare -A __COLORS=(
  ["RED"]="${STD_COLOR_RED}"
  ["GREEN"]="${STD_COLOR_GREEN}"
  ["YELLOW"]="${STD_COLOR_YELLOW}"
  ["BLUE"]="${STD_COLOR_BLUE}"
  ["CYAN"]="${STD_COLOR_CYAN}"
  ["NO_COLOR"]="${STD_COLOR_NC}"
)
declare -r __COLORS


STD_FORMAT_BOLD='\033[1m'
STD_FORMAT_NORMAL='\033[0m' # Not bold
# Store all formatting options
declare -A __FORMATS=(
  ["BOLD"]="${STD_FORMAT_BOLD}"
  ["NORMAL"]="${STD_FORMAT_NORMAL}"
)
declare -r __FORMATS


# Apply color+format to a string
function __color_string() {
  local color="$1"
  local format="$2"
  local string="$3"

    if [ -z ${NO_COLOR+x} ]; then
      echo -e "${color}${format}${string}${STD_FORMAT_NORMAL}${STD_COLOR_NC}"
    else
      # Do not allow any colors
      echo "${string}"
    fi
}

# Settings set by 'status::init' functions
__STATUS_PREFIX='> '
__STATUS_FORMAT="${STD_FORMAT_BOLD}"
__STATUS_COLOR="${STD_COLOR_NC}"
__SUBSTATUS_INDENT='  '
__SUBSTATUS_PREFIX='- '
__SUBSTATUS_FORMAT="${STD_FORMAT_NORMAL}"
__SUBSTATUS_COLOR="${STD_COLOR_NC}"
__SEPARATOR_CHAR='='
__SEPARATOR_FORMAT="${STD_FORMAT_NORMAL}"
__SEPARATOR_COLOR="${STD_COLOR_NC}"
__SEPARATOR_LENGTH=0


# Associative array to hold modules imported by the 'use' function
declare -A __IMPORTED_MODULES

function use() {
  local input="$1"

  if [[ -v __IMPORTED_MODULES["${input}"] ]]; then
    std::echoerr "Module ${input} already imported"
    exit "${USAGE_ERROR}"
  fi

  local path="${input}"
  # Replace '::' with '/'
  path="${path//:://}"

  # Replace 'std' prefix with path to library
  path="${path//std/$__NONSTDLIB_DIR}"

  if [[ -f "${path}.sh" ]]; then
    path="${path}.sh"
    source "${path}"
    
    # Add this module to array of imported modules
    __IMPORTED_MODULES["${input}"]="${path}"
  else
    # TODO: we could try to check if the path is a directory and consider sourcing all files in the directory
    
    std::echoerr "No such module: ${input}"
    # TODO: add a 'did you mean ...?' message
    exit "${USAGE_ERROR}"
  fi
}




