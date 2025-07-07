//# publish
module 0xCAFE::BlockLabels {
    use std::signer;

    /// This function demonstrates labels at the start of bytecode blocks
    public fun label_demo(account: &signer) {
        let x: u64 = 1;
    label1:
        {
            let y = 2;
            let z = x + y;
        }
    label2:
        {
            // empty block with label
        }
    }

    /// This function uses blocks as expressions updating and accessing locals within one expression
    public fun block_expression_demo(): u64 {
        let mut x: u64 = 10;
        // The block expression updates x and returns an expression using x
        let y = {
            x = x + 5;
            x * 2
        };
        y
    }

    /// Function with ability constraints on type parameters
    /// T must have copy, drop, and store abilities
    public fun ability_constrained<T: copy + drop + store>(val: T) {
        // Just do nothing, dummy function exercising ability constraints
        let _ = val;
    }

    public fun runner() {
        let dummy = ability_constrained(42u64);
        let _ = block_expression_demo();
        label_demo(&signer::specify_address());
    }
}

//# run 0xCAFE::BlockLabels::runner --signers 0xCAFE

//# run 0xCAFE::BlockLabels::ability_constrained --args 99u64
//# run 0xCAFE::BlockLabels::block_expression_demo
//# run 0xCAFE::BlockLabels::label_demo --signers 0xCAFE

//# publish
script {
    use 0xCAFE::BlockLabels;
    use std::signer;

    // Just run each function individually to exercise compiler and VM

    fun main(account: signer) {
        // Call label_demo
        BlockLabels::label_demo(&account);

        // Call block_expression_demo and ignore result
        let _ = BlockLabels::block_expression_demo();

        // Call ability_constrained with u8 type (which satisfies abilities)
        BlockLabels::ability_constrained(8u8);
    }
}

//# run

// Featurres:
// c8af774d9ccf538c6ed3c843228d6d52: Define and use labels at the start of bytecode blocks in Move functions.
// c074aa354e9f190e8e202281e65c259f: Test that blocks used as expressions can update and access local variables within a single expression statement.
// c58ec5bcad183e685aa4157b1ddd27cf: Specify ability constraints (such as copy, drop, store) on function type parameters.
