
//# publish
module 0xCAFE::ControlAndPatternTest {
    use std::option;

    // Enum with several variants to test pattern matching and guards
    enum ComplexEnum<T> has copy, drop, store {
        A,
        B(u8, u8),
        C { flag: bool, val: T },
        D(T),
        E { nested: ComplexEnum<u8> },
        F,
    }

    // Struct to test common fields and destructure with guards
    struct Data has copy, drop, store {
        a: u8,
        b: bool,
        c: u16,
    }

    // Helper function to create an instance of ComplexEnum<u8>
    public fun make_complex_enum(input: u8): ComplexEnum<u8> {
        if (input < 2) {
            ComplexEnum::A
        } else if (input == 2) {
            ComplexEnum::B(10u8, 20u8)
        } else if (input == 3) {
            ComplexEnum::C { flag: true, val: 42u8 }
        } else if (input == 4) {
            ComplexEnum::D(100u8)
        } else if (input == 5) {
            ComplexEnum::E { nested: ComplexEnum::B(1u8, 2u8) }
        } else {
            ComplexEnum::F
        }
    }

    // Test unreachable code detection using `no` marker in comments for the tester
    // To confirm unreachable, we use if false, expect no branch executed.

    public fun unreachable_code_detection(x: u8): u8 {
        if (false) {
            // no
            return 255u8;
        };
        let a = 0u8; // we mimic mutation with shadowing
        if (x > 0) {
            a = x;
        };
        a
    }

    // Test compound boolean expressions with short-circuit and local mutation in guards
    // embedding local mutations inside && and || operators with side effects.

    public fun short_circuit_with_mutations(x: &mut u8, y: u8): bool {
        // x is mutable reference, we shadow by let for mutation
        let temp_x = *x;
        let result = (temp_x < y) && ({
            // mutation side effect inside block expression within &&
            *x = temp_x + 1;
            true
        }) || ({
            // second branch of || with mutation
            *x = temp_x + 100;
            false
        });
        result
    }

    // Extensive pattern matching tests combining all requested features:
    // guarded conditions with short circuiting and mutation inside guards,
    // nested pattern matching, common fields, wildcards, references, generics.

    public fun complex_pattern_matching(input: ComplexEnum<u8>, data: Data): u8 {
        let local_mut = 1u8;
        let res = match input {
            ComplexEnum::A => {
                // guard with short circuit && and mutation in block
                if (data.b && ({
                    local_mut = local_mut + 10;
                    true
                })) {
                    1u8
                } else {
                    // no
                    0u8
                }
            },
            ComplexEnum::B(x, y) if (x > 0 && {
                local_mut = local_mut + y;
                true
            }) => x + y + local_mut,
            ComplexEnum::C { flag, val } if (flag || {
                // block in guard with mutation inside || short-circuit
                local_mut = local_mut + val;
                false
            }) => val + local_mut,
            ComplexEnum::D(v) => {
                // pattern matching with reference
                let ref_v = &v;
                if (*ref_v == 100) { local_mut = 42u8; };
                *ref_v + local_mut
            },
            ComplexEnum::E { nested } => {
                // nested pattern matching with wildcard and guards
                match nested {
                    ComplexEnum::B(a, b) if (a + b > 2) => a + b + local_mut,
                    _ => {
                        // no
                        0u8
                    },
                }
            },
            ComplexEnum::F => {
                // guard with always false to test unreachable branch
                if (false) {
                    // no
                    99u8
                } else {
                    // no mutation here, just use local_mut
                    local_mut
                }
            },
        };
        res
    }

    // Runner function that calls all tests
    public fun runner(): u8 {
        let x = 0u8;
        let _ = unreachable_code_detection(5u8);

        let _ = short_circuit_with_mutations(&mut x, 10u8);
        // x has been mutated, check x + 1, don't return, just proceed

        let ce = make_complex_enum(3u8);
        let data = Data { a: 10u8, b: true, c: 20u16 };

        complex_pattern_matching(ce, data)
    }
}


//# run 0xCAFE::ControlAndPatternTest::unreachable_code_detection --args 0u8


//# run 0xCAFE::ControlAndPatternTest::short_circuit_with_mutations --args 0u8 10u8


//# run 0xCAFE::ControlAndPatternTest::make_complex_enum --args 3u8


//# run 0xCAFE::ControlAndPatternTest::complex_pattern_matching --args 0xCAFE::ControlAndPatternTest::ComplexEnum::C { flag: true, val: 42u8 }  // complex arg

//# run 0xCAFE::ControlAndPatternTest::runner


// Featurres:
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
// b4067e0a984ec283e8ea35b13b21430a: Test that compound expressions using short-circuiting boolean operators (&&, ||) and local mutation in code blocks evaluate correctly according to Move semantics.
// 88ad55adda6cc00951462b4f5a7eeb94: Test that pattern matching on enums and structs—including nested patterns, wildcards, conditional guards, references, generics, and common fields—works correctly and as expected in Aptos Move.
