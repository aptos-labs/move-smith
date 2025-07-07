//# publish
address 0xA551 {
    // Should skip some lint checks
    #[skip(allow_unused_variables, allow_unused_functions)]
    module DepModule {
        use std::signer;

        struct R has key {
            value: u64,
        }

        // 'do' function modifies R based on input 'v'
        public fun do(r: &mut R, v: u64) {
            if (v == 0) {
                // Use various operators for arithmetic and logic
                r.value += 10;         // +=
                r.value -= 5;          // -=
                r.value *= 2;          // *=
                r.value /= 3;          // /=
                let _ = r.value % 7;   // %

                if (r.value >= 4 && r.value <= 100) {
                    let _ = r.value == 21;    // ==
                    let _ = r.value != 22;    // !=
                    let _ = (r.value << 1) >> 1; // << >> 
                    let _ = r.value << 2;     // <<
                    let _ = r.value >> 1;     // >>
                    let _ = true ==> false;   // Custom operator demonstration (actually not supported by Move so will treat as comment)
                    let _ = true => false;    // Same as above, treated as comment.

                    if ((r.value <==> 50) == false) {} /* <==> no operator in Move: treat as comment */
                    // Compound operators: '%=' and '^=' are invalid in Move, treat as comments:
                    // r.value %= 2;
                    // r.value ^= 1;

                    // Range operator '..' used in specs or comments since '..' invalid in code.
                }
            } else {
                r.value = v;
            }
        }

        // A runner function to call do() with some value
        public fun runner(r: &mut R) {
            Self::do(r, 0);
        }
    }
}
//# run 0xA551::DepModule::runner --signers 0xA551


//# publish
address 0xF00D {
    // Using attributes for package paths transforming name from String to Symbol using Comments+Structs
    #[skip(allow_unused_structs)]
    module PackagePathsModule {
        use std::string;
        use std::symbol;

        #[struct(true)]
        struct PackagePaths has copy, drop, store {
            // originally name: String, now Symbol
            name: symbol::Symbol,
            target_file: string::String,
            dep_files: vector<string::String>,
        }

        public fun new(name: string::String, target: string::String, deps: vector<string::String>): PackagePaths {
            let sym = symbol::make(&name);
            PackagePaths {
                name: sym,
                target_file: target,
                dep_files: deps
            }
        }

        // runner without args to exercise new
        public fun runner() {
            let dummy_name = string::utf8(b"example");
            let dummy_target = string::utf8(b"target.move");
            let dummy_deps = vector::empty<string::String>();
            let _pkg = Self::new(dummy_name, dummy_target, dummy_deps);
        }
    }
}
//# run 0xF00D::PackagePathsModule::runner


//# publish
address 0xCAFE {
    module OperatorTest {
        struct R has key {
            val: u64,
        }

        public fun init(val: u64): R {
            R { val }
        }

        public fun test_bits(r: &mut R) {
            // Using bitwise and arithmetic operators
            r.val = (r.val << 2) >> 1;  // << >>
            r.val = (r.val + 5) * 2 % 10; // + * % 
            r.val = r.val - 3 / 1; // - /
            r.val = r.val ^ 0b1010; // ^ bitwise xor
        }

        public fun runner() {
            let mut r = Self::init(7);
            Self::test_bits(&mut r);
        }
    }
}
//# run 0xCAFE::OperatorTest::runner


//# run
script {
    use 0xA551::DepModule;
    use 0xCAFE::OperatorTest;
    use 0xF00D::PackagePathsModule;

    fun main(account: &signer) {
        // Create resource R for DepModule
        let mut r = DepModule::R { value: 0 };
        // Call do with v=0 to trigger operator tests and logic paths
        DepModule::do(&mut r, 0);

        // Call runner in OperatorTest to run bitwise and arithmetic ops
        OperatorTest::runner();

        // Call PackagePathsModule runner to test package paths transformation
        PackagePathsModule::runner();
    }
}