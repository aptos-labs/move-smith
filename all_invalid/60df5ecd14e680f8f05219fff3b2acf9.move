
//# publish
module 0xCAFE::SpecFeatures {
    use std::signer;
    use std::vector;

    struct Sample has store, key {
        value: u64,
    }

    // This specification block has an explicit target of a struct type
    spec Sample {
        const MAGIC: u64 = 0xDEADBEEF;

        // Pragma property assignments with literals
        pragma reason = true;
        pragma id = 0xCAFEu64;
        pragma description = b"Testing spec features";

        // Example ensures clause using literals
        ensures self.value >= 0;
    }

    // Specification block targeted to a function with pragma property assignments
    spec fun create_sample(value: u64): Sample {
        pragma created = 0xCAFE;
        pragma valid = true;

        ensures result.value == value;
    }

    public fun create_sample(value: u64): Sample {
        Sample { value }
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        // Use a closure as a first-class value
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| a + b;
        add(x, y)
    }

    public fun call_lambda_dynamic() {
        let fn_list: vector<|u8, u8|u8> = vector[|a: u8, b: u8| a + b, |a: u8, b: u8| a * b];
        let adder = *vector::borrow(&fn_list, 0);
        let multiplier = *vector::borrow(&fn_list, 1);
        let _sum = adder(2u8, 3u8);
        let _prod = multiplier(2u8, 3u8);
    }

    public fun dynamic_call_expr(f: |u8|u8, argument: u8): u8 {
        // f is a call expression as a first class value passed in and called
        f(argument)
    }
}


//# run 0xCAFE::SpecFeatures::create_sample --args 123u64


//# run 0xCAFE::SpecFeatures::call_lambda --args 10u8 15u8


//# run 0xCAFE::SpecFeatures::call_lambda_dynamic


//# run 0xCAFE::SpecFeatures::dynamic_call_expr --args 4u8


// Featurres:
// 38f9a6f2c6adb29e506aa4a914008ecc: Specify the target of a specification block.
// 832c91f7f3c35b3fb61b5e7ce213244d: Assign literal values (such as at-sign, boolean, numeric, or byte string) to pragma properties using '=', optionally following the property name.
// e0cc0eb5a0e248d117c73b8ec2f355c6: Call expressions as first-class values, passing argument lists dynamically.
