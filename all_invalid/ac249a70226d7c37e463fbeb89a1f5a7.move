//# publish
module 0xCAFE::ReferenceAndStringTest {
    use std::string;
    use std::vector;

    struct R has copy, drop, store {
        a: u8,
        b: u8,
    }

    /// Returns string representation like "0xCAFE::ReferenceAndStringTest::R"
    public fun type_as_string(): vector<u8> {
        // Compose by concatenation
        let addr_str = string::utf8(b"0xCAFE");
        let module_str = string::utf8(b"ReferenceAndStringTest");
        let struct_str = string::utf8(b"R");

        let sep_colon = string::utf8(b"::");

        let temp1 = string::concat(addr_str, sep_colon);
        let temp2 = string::concat(temp1, module_str);
        let temp3 = string::concat(temp2, sep_colon);
        let full_str = string::concat(temp3, struct_str);
        full_str
    }

    // Method to demonstrate usage of & and &mut references with struct R
    public fun modify_and_read(r_ref: &mut R, r_ref_imm: &R): u8 {
        // Modify through mutable reference
        r_ref.a = r_ref.a + 1;
        r_ref.b = r_ref.b + 2;

        // Read through immutable reference
        let sum = r_ref_imm.a + r_ref_imm.b;

        // sum plus modified a field
        sum + r_ref.a
    }

    // Function that iterates a variable from 0..10 with break and continue
    // Adds i to total except skips on even numbers, breaks when i==7
    public fun loop_test(): u8 {
        let mut total = 0u8;
        for (i in 0..10) {
            if (i == 7) {
                break;
            };
            if (i % 2 == 0) {
                continue;
            };
            total = total + i as u8;
        };
        total
    }
}

//# run 0xCAFE::ReferenceAndStringTest::type_as_string

//# run 0xCAFE::ReferenceAndStringTest::loop_test

//# publish
script {
    use std::signer;
    use 0xCAFE::ReferenceAndStringTest;

    fun main(s: signer) {
        let r = ReferenceAndStringTest::R {a: 10, b: 20};
        let mut r_mut = r;
        let r_imm_ref = &r_mut;
        let r_mut_ref = &mut r_mut;

        let _res = ReferenceAndStringTest::modify_and_read(r_mut_ref, r_imm_ref);

        let _type_str = ReferenceAndStringTest::type_as_string();

        let final_total = ReferenceAndStringTest::loop_test();

        // We do not assert but run code to cover references, string composition, loop with breaks/continue
    }
}

//# run

// Featurres:
// 731e7b66c340e61a359477160d73dcb1: Define reference types with mutable and immutable qualifiers using '&' and '&mut' syntax.
// 57e6de1e976504c13253b08a6f34a375: Generate a string representation of a struct handle's type including its module alias and identifier.
// cdd89ec6201f63d1f00c83114f52bb19: Test that the Move script correctly handles the combination of for-loop iteration, break, continue, and conditional modifications to a variable, resulting in the expected final value.
