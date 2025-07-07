// # publish
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
            let _ = (x, a);
        }
    }
}
// # run 0xCAFE::PatternTest::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::PatternTest;

    fun main() {
        PatternTest::runner();
    }
}

// Featurres:
// ef0d8e076c5cee0d7d3002c7d8da1efa: Ensure that variables declared without an initial value can be assigned a value within an if-else statement, and that the variable's value reflects the correct branch taken.
// dfd056b59dd5b954472c6db4a6f22b0b: Use the '..' syntax at the end of a named struct deconstruction pattern to ignore unlisted fields during pattern matching or let bindings.
// 2f4b7338562ca1cec5504769add511df: Specify the address for a module with the 'address' declaration.
