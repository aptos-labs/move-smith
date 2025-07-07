//# publish
module 0x42::m {

  enum Data has drop {
    V1{x: u64},
    V2{y: bool, x: u64},
    V3{z: u8, x: u64}
  }

  // Test that pattern matching correctly accesses fields
  fun test_pattern_match_x(): u64 {
    let d = Data::V2{x: 99, y: true};
    // Match on d to access x
    let result = match d {
      Data::V1{x} => x,
      Data::V2{x, y: _} => x,
      Data::V3{x, z: _} => x,
    };
    result
  }

  // Test that pattern matching to access 'y' in V2 and V1 (which doesn't have y)
  fun test_pattern_match_y(): bool {
    let d1 = Data::V1{x: 10};
    let d2 = Data::V2{x: 20, y: false};

    // For d1, since no y, default to false
    let y1 = match d1 {
      Data::V1{x: _} => false,
      Data::V2{y, ..} => y,
      Data::V3{..} => false,
    };

    // For d2, extract y
    let y2 = match d2 {
      Data::V1{x: _} => false,
      Data::V2{y, ..} => y,
      Data::V3{..} => false,
    };

    // Return combined result (could be used as proxy for test)
    y1 && y2
  }

  // Test that assigning variants dynamically works and fields can be accessed
  fun test_assign_and_access(): bool {
    let mut data: Data;
    data = Data::V3{z: 255, x: 12345};
    let x_value = match data {
      Data::V1{x} => x,
      Data::V2{x, ..} => x,
      Data::V3{z: _, x} => x,
    };
    // Assert that x_value equals 12345
    x_value == 12345
  }

  // Test nested pattern matching with different variant combinations
  fun test_nested_pattern(): u64 {
    let data1 = Data::V2{x: 7, y: true};
    let data2 = Data::V3{z: 2, x: 77};

    let result = match (data1, data2) {
      (Data::V2{x: x1, y: _}, Data::V3{z: _, x: x2}) => x1 + x2,
      _ => 0,
    };
    result
  }

  // Additional test: verify that an enum variant defaulting behaves correctly
  fun test_default_behavior(): u64 {
    let data = Data::V1{x: 50};
    // Assign default value based on variant
    let x_value = match data {
      Data::V1{x} => x,
      Data::V2{x: _, y: _} => 0,
      Data::V3{z: _, x: _} => 0,
    };
    x_value
  }
}

//# run 0x42::m::test_pattern_match_x

//# run 0x42::m::test_pattern_match_y

//# run 0x42::m::test_assign_and_access

//# run 0x42::m::test_nested_pattern

//# run 0x42::m::test_default_behavior