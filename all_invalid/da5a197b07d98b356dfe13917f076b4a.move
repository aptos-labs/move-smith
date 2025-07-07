//# publish
address 0xCAFE {
    module PatternTest {
        struct SampleStruct has store, copy, drop, key {
            a: u8,
            b: u16,
            c: bool,
            d: u64,
        }

        public fun runner() {
            let condition = true;

            // 1. Variable declared without initial value, assigned within if-else
            let x: u64;
            if (condition) {
                x = 10;
            } else {
                x = 20;
            };

            // We don't assert, just exercise variable assignment flow

            // 2. Use '..' syntax for named struct deconstruction ignoring some fields
            let s = SampleStruct { a: 1, b: 2, c: true, d: 3 };
            let SampleStruct { a, .. } = s;
            // `a` taken, `b,c,d` ignored by ..

            // dummy use to prevent warnings
            let _ = x;
            let _ = a;
        }
    }
}
//# run 0xCAFE::PatternTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::PatternTest;

    fun main() {
        PatternTest::runner();
    }
}