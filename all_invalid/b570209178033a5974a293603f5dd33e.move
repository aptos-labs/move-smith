//# publish
address 0x1 {
    module LintTest {
        use std::signer;

        // Skip some lint checks here
        #[skip(["unused-variable", "dead-code"])]
        struct R has key {
            value: u64,
        }

        public fun new_r(val: u64): R {
            R { value: val }
        }

        public fun do(r: &mut R, v: u64) {
            if (v % 2 == 0) {
                r.value = r.value + v;
            } else {
                r.value = r.value * v;
            }
        }

        // "runner" function to test do()
        public fun run_do() {
            let mut r = R { value: 10 };
            do(&mut r, 4); // even, add: 10 + 4 = 14
            do(&mut r, 3); // odd, mul: 14 * 3 = 42
        }
    }
}
//# run 0x1::LintTest::run_do

//# publish
package PkgAlpha {
    address 0x2 {
        module OptionalPkgMod {
            // Just an empty module to test optional package name/address

            public fun dummy() {}
        }
    }
}

//# publish
address 0x3 {
    module ArithmeticTest {
        use std::error;
        use std::signer;

        public fun add(a: u32, b: u32): u32 {
            a + b
        }

        public fun sub(a: u32, b: u32): u32 {
            assert!(a >= b, 1); // underflow check
            a - b
        }

        public fun mul(a: u32, b: u32): u32 {
            let result = a * b;
            // Check overflow by reverse division if b != 0
            if (b != 0) {
                assert!(result / b == a, 2); // overflow detected
            }
            result
        }

        public fun div(a: u32, b: u32): u32 acquires {
            assert!(b != 0, 3); // division by zero check
            a / b
        }

        public fun mod_(a: u32, b: u32): u32 {
            assert!(b != 0, 4); // modulus by zero check
            a % b
        }

        public fun run_tests() {
            // normal arithmetic
            assert!(add(2, 3) == 5, 101);
            assert!(sub(5, 3) == 2, 102);
            assert!(mul(2, 3) == 6, 103);
            assert!(div(6, 3) == 2, 104);
            assert!(mod_(7, 4) == 3, 105);

            // boundary cases
            let max = 0xffffffff;
            assert!(add(max, 0) == max, 106);
            assert!(sub(max, max) == 0, 107);
            assert!(mul(max, 1) == max, 108);
            assert!(div(max, 1) == max, 109);
            assert!(mod_(max, 1) == 0, 110);

            // overflow and underflow detection (expect aborts)
            // These aborts can't be caught here, so we just test the checks by comments:
            // sub(3,5); // underflow - should assert
            // mul(max, 2); // overflow - should assert
            // div(5,0); // div by zero - should assert
            // mod_(5,0); // mod by zero - should assert
        }
    }
}
//# run 0x3::ArithmeticTest::run_tests

//# publish
address 0x4 {
    module FeatureFlags {
        use std::vector;
        use std::option;
        use std::errors;

        const E_DIV_ZERO: u64 = 1;
        // Represent features as bits in u64
        struct Features has key {
            bitset: u64,
        }

        public fun new(): Features {
            Features { bitset: 0 }
        }

        public fun enable(features: &mut Features, f: u64) {
            features.bitset = features.bitset | f;
        }

        public fun disable(features: &mut Features, f: u64) {
            features.bitset = features.bitset & (!f);
        }

        public fun contains(features: &Features, f: u64): bool {
            (features.bitset & f) == f
        }

        // feature flags constants
        const FEATURE_A: u64 = 0x1;
        const FEATURE_B: u64 = 0x2;
        const FEATURE_C: u64 = 0x4;

        public fun run_feature_tests() {
            let mut f = new();

            // enable FEATURE_A and FEATURE_C
            enable(&mut f, FEATURE_A);
            enable(&mut f, FEATURE_C);

            assert!(contains(&f, FEATURE_A), 201);
            assert!(!contains(&f, FEATURE_B), 202);
            assert!(contains(&f, FEATURE_C), 203);

            // disable FEATURE_A
            disable(&mut f, FEATURE_A);
            assert!(!contains(&f, FEATURE_A), 204);
            assert!(contains(&f, FEATURE_C), 205);
        }
    }
}
//# run 0x4::FeatureFlags::run_feature_tests

//# run
script {
    use 0x1::LintTest;
    use 0x3::ArithmeticTest;
    use 0x4::FeatureFlags;

    fun main() {
        let mut r = LintTest::new_r(5);
        LintTest::do(&mut r, 10); // even, add
        LintTest::do(&mut r, 3);  // odd, mul

        // Arithmetic tests (some normal, some boundary)
        let _ = ArithmeticTest::add(1, 2);
        let _ = ArithmeticTest::sub(10, 5);
        let _ = ArithmeticTest::mul(7, 6);
        // The following two lines just run to test div and mod with non-zero
        let _ = ArithmeticTest::div(10, 2);
        let _ = ArithmeticTest::mod_(10, 3);

        // FeatureFlags tests
        let mut f = FeatureFlags::new();
        FeatureFlags::enable(&mut f, FeatureFlags::FEATURE_B);
        assert!(FeatureFlags::contains(&f, FeatureFlags::FEATURE_B), 301);
    }
}