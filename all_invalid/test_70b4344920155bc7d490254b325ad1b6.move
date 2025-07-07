//# publish
module 0xABC::AdvancedTest {

    //# publish
    module 0x42::Test {

        public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
            f(x, y)
        }

        public fun test(): u64 {
            apply(|x, y| x + y, 5, 10)
        }
    }

    //# run 0x42::Test::test

    //# publish
    module 0x42::m {
        use std::vector;

        const KEYS: vector<vector<vector<u8>>> = vector[vector[vector[u8]]> {
            vector[
                vector[ u8 ] { 1, 2, 3 },
                vector[ u8 ] { 4, 5 }
            ],
            vector[
                vector[ u8 ] { 6, 7 }
            ]
        };
        const VALUES: vector<vector<u64>> = vector[
            vector[ u64 ] { 10, 20, 30 },
            vector[ u64 ] { 40, 50 }
        ];

        public entry fun init() {
            let transformed_keys: vector<u64> = vector::map<vector<u8>, u64>(
                *vector::borrow(&KEYS, 0),
                |key: &vector<u8>| { vector::length<U8>(key) + 2 }
            );
            let transformed_vals: vector<u64> = vector::map<u64, u64>(
                *vector::borrow(&VALUES, 1),
                |val: &u64| { val + 100 }
            );
        }
    }

    //# run 0x42::m::init

    //# publish
    module 0xDAVE::Interaction {
        use std::vector;

        public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
            f(x, y)
        }

        public fun run_add(): u64 {
            apply(|a, b| a + b, 42, 58)
        }

        public fun run_subtract(): u64 {
            apply(|a, b| a - b, 100, 37)
        }
    }

    //# run 0xDAVE::Interaction::run_add
    //# run 0xDAVE::Interaction::run_subtract
}