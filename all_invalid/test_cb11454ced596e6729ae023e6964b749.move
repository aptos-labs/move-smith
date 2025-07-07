//# publish
module 0x42::m {

  enum Status has drop {
    Idle,
    Busy{x: u64},
    Waiting{reason: vector<u8>},
  }

  fun test_idle(): bool {
    let s = Status::Idle;
    (s is Idle)
  }

  fun test_busy_and_waiting(): bool {
    let s1 = Status::Busy{x: 100};
    let s2 = Status::Waiting{reason: b"awaiting".to_vec()};

    // Match for Busy or Waiting variants
    let res1 = (s1 is Busy | Waiting);
    let res2 = (s2 is Busy | Waiting);

    res1 && res2
  }

  fun test_partial_matching(): bool {
    let s = Status::Waiting{reason: b"time out".to_vec()};

    // Test matching only Waiting
    let match_waiting = s is Waiting;

    // Test negative match for Idle
    let not_idle = !(s is Idle);

    match_waiting && not_idle
  }

  fun test_mixed_matching(): bool {
    let s1 = Status::Idle;
    let s2 = Status::Busy{x: 42};
    let s3 = Status::Waiting{reason: b"retry".to_vec()};

    // Match Idle or Busy
    let match1 = (s1 is Idle | Busy);
    // Match Busy or Waiting
    let match2 = (s2 is Busy | Waiting);
    // Match Idle or Waiting
    let match3 = (s1 is Idle | Waiting);
    // Match all three (should be false for s3)
    let match4 = (s3 is Idle | Busy | Waiting);

    match1 && match2 && match3 && match4
  }
}

//# run 0x42::m::test_idle

//# run 0x42::m::test_busy_and_waiting

//# run 0x42::m::test_partial_matching

//# run 0x42::m::test_mixed_matching