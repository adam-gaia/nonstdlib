if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n "${__STD_STATUS_SOURCED+x}" ]]; then
  __STD_STATUS_SOURCED=1
fi

# TODO: the include guards might be broken for the same reason global vars had to be moved to the 'nonstdlib.sh' file

function print::init() {
  while [[ $# -gt 0 ]]; do
    arg="$1"
    case "${arg}" in
      --prefix=*)
        value="${arg#*=}"
        __STATUS_PREFIX="${value}"
        ;;

      --format=*)
        setting="${arg#*=}"
        value="${__FORMATS[$setting]}"
        __STATUS_FORMAT="${value}"
        ;;

      --color=*)
        setting="${arg#*=}"
        value="${__COLORS[$setting]}"
        __STATUS_COLOR="${value}"
        ;;
                 
      --sub-prefix=*)
        value="${arg#*=}"
        __SUBSTATUS_PREFIX="${value}"
        ;;                                    

      --sub-format=*)
        setting="${arg#*=}"
        value="${__FORMATS[$setting]}"
        __SUBSTATUS_FORMAT="${value}"
        ;;

      --sub-color=*)
        setting="${arg#*=}"
        value="${__COLORS[$setting]}"
        __SUBSTATUS_COLOR="${value}"
        ;;

      --sub-indent=*)
        value="${arg#*=}"
        __SUBSTATUS_INDENT="${value}"
        ;;

      --separator-char=*)
        value="${arg#*=}"
        __SEPARATOR_CHAR="${value}"
        ;;

      --separator-format=*)
         setting="${arg#*=}"
         value="${__FORMATS[$setting]}"
         __SEPARATOR_FORMAT="${value}"
        ;;
                                                  
      --separator-color=*)
         setting="${arg#*=}"
         value="${__COLORS[$setting]}"
         __SEPARATOR_COLOR="${value}"
        ;;

      --separator-len*)
        value="${arg#*=}"
        __SEPARATOR_LENGTH="${value}"
        ;;

      *)
        echo "Unknown option: ${arg}"
        exit 2
        ;;
      esac
      shift
  done  
}

# Print a status message
function print::status() {
  local message
  message="$(__color_string "${__STATUS_COLOR}" "${__STATUS_FORMAT}" "$*")"
  echo -e "${__STATUS_PREFIX}${message}"
}

# Print a stubstatus message
function print::substatus() {
  local message
  message="$(__color_string "${__SUBSTATUS_COLOR}" "${__SUBSTATUS_FORMAT}" "$*")"
  echo -e "${__SUBSTATUS_INDENT}${__SUBSTATUS_PREFIX}${message}"
}

function print::separator() {
  local length
  local line=""

  if [[ ${__SEPARATOR_LENGTH} -gt 0 ]]; then
    length="${__SEPARATOR_LENGTH}"
  else
    # Full width of terminal
    length="$(tput cols|| echo 80)"
  fi

  for((i=0; i<length; i++)); do
    line+="${__SEPARATOR_CHAR}"
  done

  local formatted_line 
  formatted_line="$(__color_string "${__SEPARATOR_COLOR}" "${__SEPARATOR_FORMAT}" "${line}")"
  echo -e "${formatted_line}"
}

