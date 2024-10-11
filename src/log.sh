if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n "${__STD_LOG_SOURCED+x}" ]]; then
  __STD_LOG_SOURCED=1
fi

# TODO: then include guards might be broken for the same reason global vars had to be moed to the 'nonstdlib.sh' file

__THIS_FILE="$(realpath "${BASH_SOURCE[0]}")"
__DIR="$(dirname "${__THIS_FILE}")"
source "${__DIR}/color.sh"


function log::init() {
  local level="${1:-$__DEFAULT_LOG_LEVEL}"
  format="${2:-$__DEFAULT_LOG_FORMAT}"

  # TODO: do something with $format

  if [[ -n __LOG_LEVELS[$level] ]]; then
    __LOG_LEVEL="${level}"
  else
    std::echoerr "'${level}' is not a valid log level"
    std::echoerr "Valid levels are ${!__LOG_LEVELS[@]}"
    exit "${USAGE_ERROR}"
  fi
}


function _log() {
  local level="$1"
  local message="$2"

  local prefix="[$level]"
  local color

  case "$level" in
    TRACE)
        color="${STD_COLOR_CYAN}"
      ;;
    DEBUG)
      color="${STD_COLOR_BLUE}"
      ;;
    INFO)
      color="${STD_COLOR_GREEN}"
      ;;
    WARN)
      color="${STD_COLOR_YELLOW}"
      ;;
    ERROR)
      color="${STD_COLOR_RED}"
      ;;
    *)
      std::echoerr "Unknown log level '${level}'"
      exit "${USAGE_ERROR}"
      ;;
  esac

  # Filter log messages to __LOG_LEVEL and above
  local numeric_current_level="${__LOG_LEVELS[$level]}"
  local numeric_min_level="${__LOG_LEVELS[$__LOG_LEVEL]}"
  if [[ $numeric_current_level -ge $numeric_min_level ]]; then
    if [ -z ${NO_COLOR+x} ]; then
     std::echoerr -e "${color}${STD_COLOR_BOLD}${prefix}${STD_COLOR_NORMAL}${STD_COLOR_NC} ${message}"
    else
      std::echoerr "${prefix} ${message}"
    fi
  fi
}

function log::trace() {
  _log TRACE "$*"
}

function log::debug() {
  _log DEBUG "$*"
}

function log::info() {
  _log INFO "$*"
}

function log::warn() {
  _log WARN "$*"
}

function log::error() {
  _log ERROR "$*"
}
