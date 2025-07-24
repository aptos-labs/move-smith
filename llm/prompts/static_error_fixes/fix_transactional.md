Each module declaration MUST have a `//# publish` immediately above it, add if missing.

Remove orphaned `//# publish` commands that don't precede a module declaration.

Each script block MUST have a `//# run` immediately above it, add if missing.

Remove orphaned `//# run` commands that don't precede a script block.

Remove any `//# publish` and `//# run` that are inside of a module or script.
