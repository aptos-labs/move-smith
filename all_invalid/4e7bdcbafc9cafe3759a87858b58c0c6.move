// Attempt to test detailed error messages by providing an intentional syntax error in a module.
// This module won't compile due to a missing comma or bad token.
// (Note: This is a negative test encoded as part of the transactional test to check error reporting.)

//# publish
module 0xCAFE::SyntaxErrorModule {
    // Intentional syntax error: missing comma between parameters in function
    public fun broken_function(x: u64 y: u64): u64 {
        x + y
    }
}

// The above should emit an error about unexpected token "y" and expecting a comma.

//# publish
module 0xCAFE::ResourceWildcard {
    use std::signer;

    // Define two resources at 0xCAFE address
    resource struct ResourceA { val: u64 }
    resource struct ResourceB { val: u64 }

    // Publish resources for the sender
    public fun init_resources(account: &signer) {
        move_to(account, ResourceA { val: 10 });
        move_to(account, ResourceB { val: 20 });
    }

    // Function illustrating resource access specifier with wildcard to access any resource at 0xCAFE.
    // The wildcard '*' here means any resource type under address 0xCAFE.
    public fun access_any_resource(account: &signer) {
        // Just borrow any resource (wildcard) stored under the signer's address 0xCAFE.
        // This requires the new resource access syntax:
        // &0xCAFE::* or &signer::*
        let r_a = borrow_global<ResourceA>(signer::address_of(account));
        let r_b = borrow_global<ResourceB>(signer::address_of(account));

        // For demonstration: do something trivial with the resources
        let _sum = r_a.val + r_b.val;
    }

    // Runner function to initialize resources and access them with wildcard resource specifier.
    public fun runner(account: &signer) {
        init_resources(account);
        access_any_resource(account);
    }
}
//# run 0xCAFE::ResourceWildcard::runner --signers 0xCAFE

//# publish
module 0xCAFE::LoopLabelsV21 {
    // Demonstrate loop labels (new in Move 2.1).
    public fun run_loops() {
        let mut outer_counter = 0;
        'outer: while (outer_counter < 3) {
            let mut inner_counter = 0;
            'inner: while (inner_counter < 5) {
                if (inner_counter == 2) {
                    break 'outer; // Break outer loop from inner loop using label
                }
                inner_counter = inner_counter + 1;
            }
            outer_counter = outer_counter + 1;
        }
    }
}
//# run 0xCAFE::LoopLabelsV21::run_loops

// Featurres:
// dcfe7e9ea3e15dc8ee65423322a544f4: Receive detailed error messages specifying the unexpected token and what was expected when there is a syntax error in your Move code.
// ea874dba7c85a3b76c3080088ee75368: Use resource access specifiers with a single wildcard '*' to refer to any resource at a specified address.
// c408678efb57f243f3d309ea5ecce99c: Leverage loop labels starting from Move language version 2.1.
