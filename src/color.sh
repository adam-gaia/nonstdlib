if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n "${__STD_COLOR_SOURCED+x}" ]]; then
  __STD_COLOR_SOURCED=1
fi

STD_COLOR_RED='\033[0;31m'
STD_COLOR_GREEN='\033[0;32m'
STD_COLOR_YELLOW='\033[0;33m'
STD_COLOR_BLUE='\033[0;34m'
STD_COLOR_CYAN='\033[0;36m'
STD_COLOR_NC='\033[0m' # No Color

STD_COLOR_BOLD='\033[1m'
STD_COLOR_NORMAL='\033[0m' # Not bold
