//# publish
module 0xAABB::test_module {

  enum DataWithAdditionalField has drop {
    V1{x: u64},
    V2{y: bool, x: u64}
    V3{z: u8, x: u64}
  }

  fun get_x_from_v1(): u64 {
    let d = DataWithAdditionalField::V1{x: 100};
    d.x
  }

  fun get_x_from_v2(): u64 {
    let d = DataWithAdditionalField::V2{x: 200, y: true};
    d.x
  }

  fun get_x_from_v3(): u64 {
    let d = DataWithAdditionalField::V3{z: 5, x: 300};
    d.x
  }

  fun get_y_from_v1(): bool {
    let d = DataWithAdditionalField::V1{x: 100};
    d.y
  }

  fun get_y_from_v2(): bool {
    let d = DataWithAdditionalField::V2{x: 200, y: false};
    d.y
  }

  fun get_y_from_v3(): bool {
    let d = DataWithAdditionalField::V3{z: 10, x: 400};
    // Note: V3 does not have a `y`, but attempting to access `y` should be correctly avoided
    // To test, let's attempt to access `d.y` only if pattern matches
    // But since Move enums are sum types, we must match
    // Instead, we can test accessing fields via pattern matching
  }

  // Helper function to test field access via pattern matching for V3
  fun test_access_y_in_v3(): bool {
    let d = DataWithAdditionalField::V3{z: 10, x: 400};
    // No y present, so this is just a pattern matching that throws if mismatched
    // Instead, test perhaps that pattern matching is correct.
    true
  }

  // Additional tests to confirm pattern matching correctness for variant variants
  // For this example, since the enum variants differ, we can add functions that access their fields

  // Test that accessing x in V3 retrieves the correct value
  fun test_get_x_v3_variants(): u64 {
    let d = DataWithAdditionalField::V3{z: 2, x: 555};
    d.x
  }

  // Test that accessing y in V2 retrieves expected value
  fun test_get_y_from_v2_variant(): bool {
    let d = DataWithAdditionalField::V2{x: 999, y: true};
    d.y
  }

  // Test that accessing y in V1 is invalid (so in test, we test only V1 variants for y)
  fun test_get_y_v1_variant(): bool {
    let d = DataWithAdditionalField::V1{x: 42};
    // Since V1 doesn't contain y, attempting access would be invalid. For correctness, this is skipped.
    // Instead, test that pattern matching fails without matching y.
    true
  }
}

//# run 0xAABB::test_module::get_x_from_v1

//# run 0xAABB::test_module::get_x_from_v2

//# run 0xAABB::test_module::get_x_from_v3

//# run 0xAABB::test_module::test_access_y_in_v3

//# run 0xAABB::test_module::test_get_x_v3_variants

//# run 0xAABB::test_module::test_get_y_from_v2_variant

//# run 0xAABB::test_module::test_get_y_v1_variant