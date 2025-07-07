
//# publish
module 0xCAFE::AccessSpecAndLogic {
    // Test modules functions with multiple comma separated access specifiers including trailing commas
    // And test logic operators and move x syntax

    use std::signer;

    struct Dummy has store { val: u8 }

    // Functions with multiple comma separated access specifiers including trailing commas
    public(script, entry,) fun example_entry(s: signer): bool {
        // use logical operators in a function annotated with comma separated access specifiers
        let b1 = true and false or true;
        let b2 = !false and (true or false);
        let b3 = !!b2; // double negation
        b1 and b3
    }

    public(public, entry,) fun example_public_entry(s: signer): bool {
        let x = 4u8;
        let y = 3u8;
        // Use move x syntax instead of move(x)
        let moved_x = move x;
        let moved_y = move y;
        // Verify that logical operators combine expressions with move x used inside
        (moved_x > 2u8) and !((moved_y < 2u8) or false)
    }

    public(private, entry, script,) fun example_private_entry_script(s: signer): bool {
        // Nested logical operators and move x usage
        let condition = move s as address != @0x0;
        let res = !(condition and (false or true)) or (move s as address == @0xCAFE);
        res
    }

    // This function uses trailing comma with access specs to test parsing them
    public(script,) fun logic_with_move_ops(): bool {
        let a = true;
        let b = false;
        // Using move on bool (legal since bool has copy, simulating move usage for test)
        let ma = move a;
        let mb = move b;
        ((ma and !mb) or (!ma and mb)) and !(ma and mb)
    }

    // Function to test move x inside complex boolean expressions with multiple access specs
    public(public, script,) fun test_move_and_logic(x: u8): bool {
        let cond1 = move x > 5;
        let cond2 = ! (move x < 3);
        move x < 10 and (cond1 or cond2)
    }
}


//# run 0xCAFE::AccessSpecAndLogic::example_entry --signers 0xBEEF


//# run 0xCAFE::AccessSpecAndLogic::example_public_entry --signers 0xBEEF


//# run 0xCAFE::AccessSpecAndLogic::example_private_entry_script --signers 0xBEEF


//# run 0xCAFE::AccessSpecAndLogic::logic_with_move_ops


//# run 0xCAFE::AccessSpecAndLogic::test_move_and_logic --args 7u8 --signers 0xBEEF



//# publish
module 0xCAFE::TrailingCommaAccessSpecAndMove {
    // Test parsing and semantic of trailing comma in access specifiers
    // and move x syntax in match, if, and complex boolean operations

    use std::signer;

    // Test function with trailing comma access spec and complex logic with move syntax
    public(public, entry, script,) fun test_trailing_comma_and_move(s: signer, val: u8): bool {
        let moved_val = move val;
        if (moved_val > 0 and moved_val < 10) {
            let condition = moved_val == 5 or ! (moved_val == 3);
            condition
        } else {
            false
        };
        true
    }

    public(entry, public,) fun double_negation_test(): bool {
        let t = true;
        let f = false;
        // Double negation using move syntax for variables
        let t2 = move t;
        let f2 = move f;
        !!t2 and !(!f2 or false)
    }

    // Test match with move inside logic operation with trailing commas at access specifiers
    public(script, entry, public,) fun match_with_move_logic(x: u8): u8 {
        match move x {
            0 => 0,
            1 => 1,
            2 => 2,
            _ => {
                let test = (move x > 0 and move x < 10) or (move x == 255);
                if (test) {
                    42
                } else {
                    0
                }
            }
        }
    }
}


//# run 0xCAFE::TrailingCommaAccessSpecAndMove::test_trailing_comma_and_move --signers 0xBEEF --args 5u8


//# run 0xCAFE::TrailingCommaAccessSpecAndMove::double_negation_test


//# run 0xCAFE::TrailingCommaAccessSpecAndMove::match_with_move_logic --args 42u8



//# publish
module 0xCAFE::MoveXAndLogicNesting {
    // Tests for move x syntax nested inside expressions with logical operators,
    // and functions with multiple comma-separated access specifiers including trailing comma
    
    use std::signer;
    use std::vector;

    public(public, script, entry,) fun nested_move_logic(x: u8): bool {
        let a = move x;
        let b = !(a < 10);
        let c = (b or (a > 5)) and (!b or a == 0);
        c
    }

    // Function with multiple comma separated access specifiers with trailing commas
    public(script, public, entry,) fun complex_logic_move_usage(s: signer, x: u8): bool {
        let m_x = move x;
        let cond1 = m_x > 0 and m_x < 20;
        let cond2 = !(m_x == 10) or (m_x != 15);
        cond1 and cond2
    }

    // Function with move x inside vector initialization guarded by access specifiers
    public(public, script,) fun vector_with_move_elements(): vector<u8> {
        let v = vector[move 1u8, move 2u8, move 3u8];
        v
    }

    // Function to test move x usage inside if, while, and logical operations
    public(entry, public,) fun control_flow_with_move(mut x: u8): u8 {
        while (move x > 0) {
            if ((move x % 2) == 0) {
                x = x - 1;
            } else {
                x = x - 2;
            };
        };
        x
    }
}


//# run 0xCAFE::MoveXAndLogicNesting::nested_move_logic --args 7u8


//# run 0xCAFE::MoveXAndLogicNesting::complex_logic_move_usage --signers 0xBEEF --args 11u8


//# run 0xCAFE::MoveXAndLogicNesting::vector_with_move_elements


//# run 0xCAFE::MoveXAndLogicNesting::control_flow_with_move --args 10u8 --signers 0xBEEF


// Featurres:
// 9653b5b722d29da014d7a3da2f3ec2bb: Specify a comma-separated list of access specifiers in your Move code, allowing both trailing commas and multiple entries.
// 1b6508bb33bc5c6d888a4147cba456a4: Test the correctness of logical operators (and, or, not, double negation) in Move scripts.
// 50e09f80f0a5d1443ce0a870cdae8efb: Replace 'move(x)' with 'move x' in Move code to improve syntax.
