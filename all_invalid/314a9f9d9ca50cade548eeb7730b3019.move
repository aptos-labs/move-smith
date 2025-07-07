
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
    spec module 0xCAFE::PropertySpec {
        // Include a specification on the resource
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

 
//# run 0xCAF::PropertyTest::compute_expression --args 10 2 3


// Featurres:
// 1de8ad72115f0eb0822915e74e37018f: Define pragma properties on items in Move code.
// 6e0da44f71576c1f38f66496810c4af8: Include other specifications or specification expressions with properties via include in spec blocks.
// 57919bd46e68fd73db04e28e80162320: Use binary operators with correct precedence during expression parsing.
