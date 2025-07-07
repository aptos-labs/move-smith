//# publish
module 0xCAFE::LambdaMutability {
    use std::signer;

    // This function tests variable bindings in lambda expressions and blocks:
    // We create a lambda (closure) that captures a variable, both mutable and immutable,
    // and test the mutability inside blocks.
    public fun runner() {
        let x = 10; // immutable binding
        let mut y = 20; // mutable binding

        // Simulate a lambda that captures x and y and tries to modify y
        {
            let _ = &x; // binding in block, should be immutable
            y = y + 5;  // mutable binding is changed here
        }

        // Another block to check mutability
        {
            let mut z = x; // z is mutable, initialized from immutable x
            z = z + 1;
        }
    }

    // Function with a name marker for 'lambda lifting' detection
    public fun lambda_lifted_function__lambda_marker__() {
        // Marker function body does nothing, just used to identify lifted lambdas
    }

    // Function to test Drop ability: create a struct with Drop and discard it
    struct Droppable has drop {
        value: u64,
    }

    public fun test_drop() {
        let d = Droppable { value: 42 };
        // d will be dropped at the end of scope.
        // This explicitly tests that Drop ability is handled.
    }
}
//# run 0xCAFE::LambdaMutability::runner --signers 0xCAFE
//# run 0xCAFE::LambdaMutability::test_drop --signers 0xCAFE
//# run 0xCAFE::LambdaMutability::lambda_lifted_function__lambda_marker__ --signers 0xCAFE

//# publish
module 0xCAFE::UseDrop {
    use std::signer;

    struct ValueWithDrop has drop {
        val: u8,
    }

    public fun create_and_drop() {
        let v = ValueWithDrop { val: 255 };
        // Explicit discard allowed by Drop ability
    }

    public fun lambda_lifted_dummy__lambda_marker__() {
        // Marker function for lambda lifted detection
    }
}
//# run 0xCAFE::UseDrop::create_and_drop --signers 0xCAFE
//# run 0xCAFE::UseDrop::lambda_lifted_dummy__lambda_marker__ --signers 0xCAFE

//# run
script {
    use 0xCAFE::LambdaMutability;
    use 0xCAFE::UseDrop;

    fun main() {
        // Call runner from LambdaMutability module
        LambdaMutability::runner();

        // Call test_drop
        LambdaMutability::test_drop();

        // Call create_and_drop from UseDrop module
        UseDrop::create_and_drop();

        // Call lambda lifted marker functions
        LambdaMutability::lambda_lifted_function__lambda_marker__();
        UseDrop::lambda_lifted_dummy__lambda_marker__();
    }
}

// Featurres:
// 8171a7fbf944cb0c44bd028f983d3a3b: Handle variable bindings in lambda expressions and blocks to determine their mutability status.
// a3689d6d7cd57460c32ba683fdb9eeed: Use the 'Drop' ability to permit values to be explicitly discarded.
// cef87b05b783ce31d7a329f3d6203a99: Identify functions that are the result of lambda lifting by checking for a specific marker in their name.
