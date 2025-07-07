//# publish
module 0xCAFE::EnumTest {
    use std::error;
    use std::signer;

    // Define an enum with copy, drop, store abilities
    enum Color has copy, drop, store {
        Red,
        Green,
        Blue,
    }

    // Another enum with raw u8 values (testing discriminants)
    enum Number has copy, drop, store {
        Zero = 0,
        One = 1,
        Two = 2,
    }

    // Test variant matching for Color enum
    public fun test_variants(): bool {
        let c1 = Color::Red;
        let c2 = Color::Green;
        let c3 = Color::Blue;

        // is operator for pattern matching
        let r1 = c1 is Color::Red;
        let r2 = c2 is Color::Green;
        let r3 = c3 is Color::Blue;

        // multiple variant matching using |
        let r4 = (c1 is Color::Red | Color::Blue);
        let r5 = (c2 is Color::Red | Color::Blue);
        let r6 = (c3 is Color::Red | Color::Blue);

        // Check casting numerical discriminants works (cast enum to u8 and back)
        let n0 = Number::Zero;
        let n1 = Number::One;
        let n2 = Number::Two;
        let n1_val: u8 = (1 as u8);
        let _c = n1_val;

        // Unary operations: not applicable on enums directly, but test on bool
        let not_r1 = !r1;

        r1 && r2 || !not_r1 && r4 && !r5 && r6
    }

    // Function demonstrating return, abort, deref, borrow, cast, and control flow
    public fun test_control_flow(addr: signer): bool {
        // borrow reference from signer
        let ref_addr = &signer::address_of(&addr);

        // cast address to u64 (addresses are u8[32], so cast of first byte)
        let first_byte = (*ref_addr)[0];
        let cast_byte = (first_byte as u64);

        // Use if statement and return
        if cast_byte == 0 {
            return false;
        };

        // Abort if address first byte == 0xff (some never happens for testing)
        if cast_byte == 0xff {
            abort 1234;
        };

        // Dereference and unary operation (~ not operator for bitwise not is ^ in Move)
        let not_byte = !((first_byte as u8) != 0);

        // Cast bool to u8 (true -> 1, false -> 0)
        let num = if not_byte { 1u8 } else { 0u8 };

        // Control test: ensure num is 0 or 1 only
        if num > 1 {
            abort error::invalid_argument(1);
        };

        true
    }

    // Runner function to test both above without args (returns bool)
    public fun run(): bool {
        let v = test_variants();
        // For a signer, we create a dummy signer with address 0xCAFE
        let dummy_signer = signer::spec_signer_address(0xCAFE);
        let c = test_control_flow(dummy_signer);
        v && c
    }
}
//# run 0xCAFE::EnumTest::run

//# publish
module 0xCAFE::EnumPattern {
    use std::error;

    enum Status has copy, drop, store {
        Ok,
        Warning,
        Error,
        Unknown,
    }

    public fun is_ok_or_warning(s: &Status): bool {
        // test is operator for multiple variants with borrow & reference
        *s is Status::Ok | Status::Warning
    }

    public fun test_abort_on_error(s: &Status): bool {
        if *s is Status::Error {
            abort 777;
        };
        true
    }

    public fun runner(): bool {
        let s1 = Status::Ok;
        let s2 = Status::Warning;
        let s3 = Status::Error;
        let s4 = Status::Unknown;

        let r1 = is_ok_or_warning(&s1);
        let r2 = is_ok_or_warning(&s2);
        let r3 = !is_ok_or_warning(&s4);

        let r4 = test_abort_on_error(&s1);
        let r5 = test_abort_on_error(&s2);
        let r6 = test_abort_on_error(&s4);

        // We'll run test_abort_on_error on s3 expecting abort
        r1 && r2 && r3 && r4 && r5 && r6
    }
}
//# run 0xCAFE::EnumPattern::runner
//# run 0xCAFE::EnumPattern::test_abort_on_error --args 2u8 --signers 0xCAFE