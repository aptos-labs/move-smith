
//# publish
module 0xCAFE::SpecAndMatchTesting {
    use std::signer;

    struct Data has copy, drop, store {
        val: u8
    }

    // test]
    // expected_failure]
    public fun test_expected_failure() {
        assert!(false, 100);
    }

    // test]
    public fun test_expected_success() {
        assert!(true, 101);
    }

    spec module {
        invariant forall d: Data :: d.val < 255;
    }

    spec schema DataSchema {
        val_spec: u8;
    }

    public fun create_data(x: u8): Data {
        Data { val: x }
    }

    public fun pattern_match_example(x: u8): u8 {
        let d = create_data(x);
        let y = match (d) {
            Data { val } => val + 1,
        };
        y
    }

    public fun pattern_match_with_multiple_arms(x: u8): u8 {
        let d = create_data(x);
        let res = match (d) {
            Data { val } if val < 10 => val + 100,
            Data { val } => val + 200,
        };
        res
    }

    // test]
    public fun runner() {
        let _ = pattern_match_example(5u8);
        let _ = pattern_match_with_multiple_arms(5u8);
        let _ = pattern_match_with_multiple_arms(20u8);
    }
}



//# run 0xCAFE::SpecAndMatchTesting::runner
