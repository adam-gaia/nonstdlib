if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "$0 must be sourced, not executed."
  exit 2
fi

# Include guard
if [[ -n "${__STD_PATH_SOURCED+x}" ]]; then
  __STD_PATH_SOURCED=1
fi

# TODO: then include guards might be broken for the same reason global vars had to be moved to the 'nonstdlib.sh' file

# Make a path ($1) relative to another ($2)
function path::relative() {
  local path="$1"
  local rel_to="$2"
  realpath --relative-to="${rel_to}" "${path}"
}
