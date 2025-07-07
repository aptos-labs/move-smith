//# publish
module 0xAB::pattern_match_tests {

  enum Response has drop {
    Success{x: u64},
    Error{code: u8},
    Pending
  }

  fun test_response_variant(): bool {
    let r = Response::Success{x: 100};
    (r is Success)
  }

  fun test_response_multiple_variants(): bool {
    let r1 = Response::Error{code: 1};
    let t1 = (r1 is Error | Pending);
    let r2 = Response::Pending;
    let t2 = (r2 is Success | Error | Pending);
    t1 && t2
  }

  fun test_response_mixed(): bool {
    let r = Response::Error{code: 255};
    let is_error_or_pending = (r is Error | Pending);
    let is_success = (r is Success);
    is_error_or_pending && !is_success
  }
}

//# run 0xAB::pattern_match_tests::test_response_variant

//# run 0xAB::pattern_match_tests::test_response_multiple_variants

//# run 0xAB::pattern_match_tests::test_response_mixed


//# publish
module 0xAB::loop_break_test {

  fun test_while_break(): bool {
    let mut count = 0;
    while (true) {
        count = count + 2;
        break
    };
    // Expects count to be 2 after the loop
    (count == 2)
  }

  fun test_multiple_cycles(): bool {
    let mut total = 0;
    let mut i = 0;
    while (i < 3) {
        total = total + i;
        i = i + 1;
        if (i == 2) {
            break
        }
    }
    // After loop, total should be 0 + 0 + 1 = 1, and i should be 2
    (total == 1) && (i == 2)
  }
}

//# run 0xAB::loop_break_test::test_while_break

//# run 0xAB::loop_break_test::test_multiple_cycles