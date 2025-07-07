//# publish
module 0xCAFE::VarCoalesceLabelCopy {
    use std::signer;

    #[copy]
    struct MyCopyType has copy, drop, store {
        val: u64,
    }

    // A function that exercises variable coalescing by reusing local variables.
    public fun variable_coalescing_example() {
        let mut a = 10u64;
        let mut b = 20u64;

        // Reassign 'a' after 'b' no longer needed - var coalescing can reuse 'b's slot for 'a'
        b = a + b;
        a = b * 2;
    }

    // Function illustrating labeled code blocks and complex control flow
    public fun labeled_blocks_example() {
        let mut i = 0u64;
        'outer: loop {
            'inner: loop {
                i = i + 1;
                if (i > 5) {
                    break 'outer;
                };
                break 'inner;
            };
        };
    }

    // Function demonstrating the Copy ability
    public fun copy_ability_example(): MyCopyType {
        let x = MyCopyType { val: 42 };
        let y = x; // copy here allowed because of copy ability
        let z = y; // another copy
        z
    }

    // Runner function for running all tests at once with no arguments
    public fun runner() {
        variable_coalescing_example();
        labeled_blocks_example();
        let _ = copy_ability_example();
    }

}
//# run 0xCAFE::VarCoalesceLabelCopy::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::VarCoalesceLabelCopy;

    fun main(account: &signer) {
        // run the runner function from the module to exercise compiler/VM
        VarCoalesceLabelCopy::runner();
    }
}

// Featurres:
// d3097607e23b946d5eae1e2dece5cd50: Use VariableCoalescing to optimize variable usage by coalescing variables.
// b2fe2ba0fc5f4483ab8510aa33fd8420: Label code blocks for advanced control flow using labels
// 238182ffc740764119186b5d92e4ed82: Use the 'Copy' ability to allow values to be duplicated.
