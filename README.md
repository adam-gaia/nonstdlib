# nonstdlib
(non) standard library of bash functions

## Usage

Source the `nonstdlib.sh` script.
```bash
source nonstdlib.sh
```
## Tips and Tricks
- Use aliases to fake shorted paths
```bash
#!/usr/bin/env bash
import nonstdlib.sh
shopt -s expand_aliases # Enables aliases in scripts
use std::log

alias info=std::info 

# These are now equivalent
std::info "message"
info "message"
```
