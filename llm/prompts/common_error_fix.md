Below are some tips for the Move on Aptos. You should follow the tips unless the feature you want to test directly require you to violate the tips.

* Unlike Rust, variables in Move doesn't need to be marked `mut`. All variables are mutable by default.
* The syntax to cast integer types is `(expression as Type)`. For example, `(x as u8); (1 + 2 as u32)`. The new type must be large enough to hold the value of the expression.
* If a function has a return value, the return type must be explicitly annotated like `fun f(): Type { ... }`. All paths in this function must return a value of this type.
* The last expression of a function is treated as the return value. `return expr;` can be used to return some value earlier (e.g. in an if statement). However, `return expr;` cannot be used as the last statement. You must use `return expr` or just `expr` as the last expression.
* Tuples cannot be assigned to a single variable. A tuple must be unpacked to the correct number of variables. e.g `let (a, b) = (c, d); let (_, _) = (x, y);`.
* Tuples cannot be assigned to underscore. `let _ = (a, b, c);` is invalid.
* In Move, there are only three function annocations `#[test]`, `#[test_only]`, `#[expected_failure]` which you should rarely use. Never use other Rust-style annotations.
* The syntax for inline functions is: `public inline fun some_function(...)...`
* In Move, each script should have one function that has no return type.
* In script, try not to create and use lambdas.
* Move doesn't have a string type. Strings are special `vector<u8>`. To create a byte string, use `b"Something...\nAnother line."`. To create a hex string, use `x"DEADBEEF"`. The byte/hex string literals are already typed as `vector<u8>` and there is no `to_vec` function.
* Move doesn't support string spanning multiple lines in source code. The `b"..."` or `x"..."` quotes must be in the same line. To include a new line in a byte string, use the `\n` character.
* Move doesn't have characters. Do not use `b'a'` to create a character. Use a string with double quote.
* Unlike in Rust you can use `x.clone()` to make a copy of `x` if `x` implements the `Clone` trait, in Move you can use `copy x` if and only if `x` has the `copy` ability.
* To consume a value without drop, the value can be passed to a function that takes it, or can be unpacked: `let Struct {x, y} = x;` or `match (enum_x) { ... }`.
* When defining structs or enums, no `resource` key word should be used.
* Move has a linear type system, meaning a value cannot be copied or dropped by default. For a struct/enum to be copyable, it needs the `copy` ability annotated. For a struct/enum to be droppable (e.g. unused), it needs the `drop` ability.
* Primitive types like integers and boolean have copy and drop by default.
* For a type to be stored in global storage as "top-level" objects (e.g. by `move_to`), both `store` and `key` abilities are needed. If a type is going to be store in global storage within another type as a field, only `store` ability is needed. The `key` ability is only needed for the outter most type.
* In Move, you cannot define cyclic data types. You also cannot instantiate a concrete data type with some type argument that will create a cycle.
* In Move, operators `+, -, *, /, %, &, |, ^` requires both operands to have the same number type. `+, -, *` should not create over/underflow. `/, %` cannot create divide-by-zero.
* Shift operators `>>,  <<` cannot shift a number more than the number of bits in that number.
* `&&, ||, !` only works for booleans.
* In Move, you can only access fields of struct/enum within the module that define the data type. For other modules to access it, you would need to define public functions to expose the functionality.
* For global storage, some resource/object must be stored by `move_to` under some address before it can be accessed with `borrow_global` or `borrow_global_mut`. If some resource/object is removed by `move_from`, it cannot be accessed anymore.
* The syntax for function type in Move is `|T1, T2, | (RT1, RT2, ...) has Ability1+Ability2+..`.
