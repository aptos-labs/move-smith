
//# publish
module 0xCAFE::ComplexExpressionsTest {
    use std::vector;
    use 0xCAFE::MyModule;

    // A generic function returning a vector of values
    public fun gen_vector() acquires {}

    // Test expression involving multiple chained field accesses, method calls, and index operations
    public fun complex_chain_test(signer: &signer): u64 {
        // Instantiate a struct with nested fields and method calls
        let obj = MyModule::f3(20u16);

        // Chain multiple accesses: obj.x, then method calls, and index
        let result: u32 = {
            // Access the field `x` from object, which is u32
            let field_x = obj.x; // u32

            // Call f2 with a u16, which returns a tuple
            let tuple_xy = MyModule::f2(5u16); // (u16, u16)

            // Access the second element of the tuple, convert to u64
            let y_value: u64 = (tuple_xy.1 as u64);

            // Call a method that returns a vector of bytes
            let byte_vec: vector<u8> = MyModule::f7();

            // Access an element of the vector using index
            let index_element: u8 = *vector::borrow(&byte_vec, 2); // 3rd element

            // Chain: multiply field_x with index_element (cast to u32)
            let chained_value = field_x + (index_element as u32);

            // Call f4 to verify enum handling
            MyModule::f4();

            // Return the chained value as u32
            chained_value
        };

        // Return the result as u64
        result as u64
    }

    // Spec block at the module level to specify test properties
    spec {
        // No specific properties; placeholder for future specifications
    }
}


//# run 0xCAFE::ComplexExpressionsTest::complex_chain_test --signers 0xBADD --args

// Featurres:
// 1ab2f423f232633e6abbd4ea3e6fb145: Chain multiple field accesses, method calls, and index operations in a single expression, like `obj.field.method()[index]`.
// c416dc1d62155276b1f629b93409bf9d: Declare module-level spec blocks with the 'module' target.
// 6192873014e042dc5a2e54f216cd6688: Write code blocks as expressions using curly braces ('{ ... }') to denote a block expression that evaluates to the last statement's value.
