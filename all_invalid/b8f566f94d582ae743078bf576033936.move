
//# publish
module 0xCAFE::TestModulehex {
    use std::debug;

    // Define an enum with a guard
    enum EnumWithGuard {
        ValueA,
        ValueB,
        ValueC,
    }

    // Struct containing an enum
    struct StructWithEnum {
        e: EnumWithGuard,
        value: u64,
    }

    // Function to create and return enum variant
    public fun create_enum_a(): EnumWithGuard {
        EnumWithGuard::ValueA
    }

    // Function to create and return enum variant with value
    public fun create_enum_b(): EnumWithGuard {
        EnumWithGuard::ValueB
    }

    // Runner function to test various features
    public fun run_tests() {
        // --- Test 1: Hexadecimal number assignment ---
        let hex_number: u64 = 0xDEADBEEFCAFEBABE_u64;

        // --- Test 2: Tuple assignment with side effects ---
        // Declare a mutable variable for side effect
        let side_effect_value: u64 = 0;
        // Assign to a tuple, evaluating right to left
        let (a, b, c): (u64, u64, u64) = {
            // Side effect: modify side_effect_value
            side_effect_value = 42;
            // Return tuple with hexadecimal constants
            (0xABCD_EF01_u64, 0x1234_5678_u64, 0xDEAD_BEEF_u64)
        };
        // For verification, debug print (not necessary, just for demonstration)
        debug::print(&b"Tuple values: \n"[0]);
        debug::print(&a);
        debug::print(&b);
        debug::print(&c);
        // Ensure side effect occurred before tuple assignment

        // --- Test 3: Match guards with enums and struct containing enums ---
        let enum_value: EnumWithGuard = create_enum_b();

        // Match with guard and rebinding
        match enum_value {
            EnumWithGuard::ValueA => {
                debug::print(&b"Matched ValueA"[0]);
            },
            e @ EnumWithGuard::ValueB => {
                // Inside arm, e is bound, but since enum_value is ValueB,
                // the guard is satisfied, and e is bound to enum_value.
                debug::print(&b"Matched ValueB with guard"[0]);
                // Can mutate or access 'e' here if desired
            },
            EnumWithGuard::ValueC => {
                debug::print(&b"Matched ValueC"[0]);
            },
        }

        // Struct containing enum, mutable access and field modification
        let s = StructWithEnum {
            e: create_enum_a(),
            value: 100,
        };

        // Match with guard and handle control flow
        match &mut s {
            StructWithEnum { e: e_ref, value: ref mut v } if *v > 50 => {
                // Rebinding the enum field via mutable reference
                match e_ref {
                    EnumWithGuard::ValueA => {
                        // Mutate the enum field
                        *e_ref = create_enum_b();
                        *v = 200;
                        debug::print(&b"Struct match arm with enum ValueA"[0]);
                    },
                    _ => {
                        debug::print(&b"Struct match arm with other enum value"[0]);
                    },
                }
            },
            _ => {
                debug::print(&b"No match or value <= 50"[0]);
            },
        }

        // Ensure that the enum field has been changed if matching
        debug::print(&b"Final enum in struct: "[0]);
        match &s.e {
            EnumWithGuard::ValueA => debug::print(&b"ValueA"[0]),
            EnumWithGuard::ValueB => debug::print(&b"ValueB"[0]),
            EnumWithGuard::ValueC => debug::print(&b"ValueC"[0]),
        }
    }
}



//### run 0xCAFE::TestModulehex::run_tests --signers 0xBEEF

// Features:
// e5cb8f13d3374839ceb4a7791b5ce2a8: Write hexadecimal numbers (with optional underscores for readability) in Move code.
// 262331dd465223cf1168aefcba6ed961: Test that tuple assignment correctly evaluates right-hand side expressions from left to right, ensuring side effects (like variable mutations) happen in the expected order.
// c54fa6e949a1bba42f9a1744d0d6300a: Test that match guards on enum fields—including fields of structs containing enums—correctly handle both direct value-matching and rebinding via let assignments within match arms, and allow safe and correct mutable references and assignments to fields regardless of arm control flow or moves.
