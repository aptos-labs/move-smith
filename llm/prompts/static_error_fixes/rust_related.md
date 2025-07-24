Remove 'mut' keyword from variable declarations. Move doesn't use 'let mut', only 'let'.

Remove Rust-style attributes like `#[...]`. Move doesn't support Rust attributes.

Remove Rust-style lifetime annotations from references. Move doesn't use lifetime parameters.

Remove Rust-specific method calls which don't exist in Move. For example:
    * `to_vec()`
