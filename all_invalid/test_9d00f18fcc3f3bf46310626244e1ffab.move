//# publish
module 0x51::test_module {

  enum DataVariant has drop {
    V1{x: u64},
    V2{y: bool, x: u64},
    V3{z: u8, x: u64}
  }

  fun get_x_from_v1(): u64 {
    let d = DataVariant::V1{x: 100};
    d.x
  }

  fun get_x_from_v2(): u64 {
    let d = DataVariant::V2{x: 200, y: true};
    d.x
  }

  fun get_x_from_v3(): u64 {
    let d = DataVariant::V3{z: 5, x: 300};
    d.x
  }

  fun get_y_from_v1(): bool {
    let d = DataVariant::V1{x: 150};
    // DataVariant::V1 does not contain y, but pattern matching as in Move isn't directly supported, so we simulate by creating functions.
    // For the purpose of testing, assume pattern matching is done manually or via functions, but in the test, directly instantiate and access fields.
    false
  }

  fun get_y_from_v2(): bool {
    let d = DataVariant::V2{x: 250, y: false};
    d.y
  }

  fun get_y_from_v3(): bool {
    let d = DataVariant::V3{z: 7, x: 400};
    // Similarly, V3 does not contain y, so we return false to simulate absence or mismatch.
    false
  }

  // Function to test nested pattern matching
  fun pattern_match_test(val: DataVariant): bool {
    if (match val {
        DataVariant::V1{x} => false,
        DataVariant::V2{y, x: _} => y,
        DataVariant::V3{z: _, x: _} => false,
    }) {
        true
    } else {
        false
    }
  }

  fun test_pattern_match(): bool {
    let v1 = DataVariant::V1{x: 1};
    let v2 = DataVariant::V2{x: 2, y: true};
    let v3 = DataVariant::V3{z: 3, x: 3};
    pattern_match_test(v1) == false && pattern_match_test(v2) == true && pattern_match_test(v3) == false
  }

  // Functions to test nested function closures with captures and arithmetic

  fun create_add_closure(addend: u64): |u64|u64 {
    |x| addend + x
  }

  fun create_multiply_closure(factor: u64): |u64|u64 {
    |x| factor * x
  }

  fun test_closure_arithmetic() {
    let add_five = create_add_closure(5);
    assert!(add_five(10) == 15, 0);
    let multiply_by_3 = create_multiply_closure(3);
    assert!(multiply_by_3(4) == 12, 1);

    // Compose closures
    let add_two = create_add_closure(2);
    let multiply_then_add = |x| add_five(add_two(x)); // (x + 2) + 5 = x + 7
    assert!(multiply_then_add(8) == 15, 2);

    // Nested closures with captures
    let outer_capture = 10;
    let inner_closure = |x| |y| outer_capture + x + y;
    let inner_func = inner_closure(5);
    assert!(inner_func(7) == 22, 3); // 10 + 5 + 7 = 22
  }

  // Function to test functional composition with captures and arithmetic
  fun test_function_composition(): u64 {
    let base = 4;
    let adder = |x| |y| base + x + y;
    let multiplier = |x| |y| base * x * y;

    let composed = |x| |y| multiplier(x)(adder(x)(y));
    // expected: 4 * x * (4 + x + y)
    let x_val = 3;
    let y_val = 2;
    composed(x_val)(y_val)
  }
}

//# run 0x51::test_module::get_x_from_v1
//# run 0x51::test_module::get_x_from_v2
//# run 0x51::test_module::get_x_from_v3
//# run 0x51::test_module::get_y_from_v2
//# run 0x51::test_module::test_pattern_match
//# run 0x51::test_module::test_closure_arithmetic
//# run 0x51::test_module::test_function_composition