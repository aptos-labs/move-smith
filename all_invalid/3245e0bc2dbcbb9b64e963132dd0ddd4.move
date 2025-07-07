
//# publish
module 0xCAFE::PropertyTest {
    use std::vector;
    use std::string;

    // 1. Define a resource with pragma properties
    struct PragmaItem has key, store {
        value: u64,
        flags: u8,
    }

    // 2. Define a module with a spec block that includes properties
    spec module {
        // Specify the module address and name
        address: 0xCAFE,
        name: "PropertySpec",
        include {
            PragmaItem: {
                // Add a property to the spec
                pragma_properties: {
                    "description": "A property with pragma properties",
                    "category": "test",
                }
            }
        }
    }
    // Note: The location of the `spec module` statement must be outside the module block.

    // 3. Define a function to perform an expression with binary operators considering precedence
    public fun compute_expression(a: u64, b: u64, c: u64): u64 {
        // Expression: a + b * c - (a / b) + (a & b) - (c % b)
        // Should evaluate with correct precedence
        let mult = b * c; // * has higher precedence
        let div = if (b != 0) { a / b } else { 0 }; // Avoid division by zero
        let and_op = a & b;
        let mod_op = c % b;
        let result = a + mult - div + and_op - mod_op;
        result
    }
}


//# run 0xCAFE::PropertyTest::compute_expression --args 10 2 3