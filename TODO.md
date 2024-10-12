# TODO
- Stop src/* files from being sourced from anything but nonstdlib.sh's use function
- Re-create all the trivial builders and shell script builders with functions that will source nonstdlib.sh
- tests
- I use corutils in some functions. Either make 100% bash or add as dep in nix package and note in README.md
- Lots of common bolilerplate. Maybe we need codegen?
- add 'assert' function to wrap 'test'?
- It would be nice to always write 'source nonstdlib.sh' instead of having that part get set by nix, for compatibility with non-nix. Is it possible for a nix builder to put the nonstdlib.sh in the nix store dir adjaceant to the script??
