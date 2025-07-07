//# publish
module 0x1::Helper {
    public fun f2(): u64 {
        42
    }
}

// test_only]
//# publish
module 0x1::TestHelper {
    use 0x1::Helper;

    // test]
    fun test_f2() {
        let val = Helper::f2();
        assert!(val == 42, 1);
    }
}
