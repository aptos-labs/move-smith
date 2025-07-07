//# publish
module 0xabc::nested_value_reassignment {
    public fun test_renaming_and_reassignment(): u64 {
        let a = 10;
        {
            // Renaming 'a' to 'b'
            let b = a;
            // Reassign 'b'
            let b = b + 5; // b = 15
            // Use 'b' in nested expression
            b + { // start nested block
                let b = b * 2; // b = 30
                b
            } + {
                // Reassign 'b' again
                let b = b - 10; // b = 20
                b
            }
        }
    }

    public fun test_function_return(): u64 {
        // Call previous function with specific argument
        Self::compute_with_input(7)
    }

    fun compute_with_input(p: u64): u64 {
        let x = p;
        let y = {
            let x = x + 3; // 10 when p=7
            x
        };
        y + 2
    }
}

//# run 0xabc::nested_value_reassignment::test_renaming_and_reassignment
//# run 0xabc::nested_value_reassignment::test_function_return --args 7