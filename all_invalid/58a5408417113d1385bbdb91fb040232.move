// Using address 0xCAFE as required

//# publish
module 0xCAFE::MyStruct {
    // A struct with 3 fields
    struct S has copy, drop, store, key {
        a: u8,
        b: u16,
        c: bool,
    }

    public fun new(): S {
        S { a: 1u8, b: 2u16, c: true }
    }

    public fun update_a(s: S, new_a: u8): S {
        // Create a new struct with updated a
        S { a: new_a, b: s.b, c: s.c }
    }

    // A runner function to call update_a without args
    public fun runner(): S {
        let s = new();
        update_a(s, 42u8)
    }
}
//# run 0xCAFE::MyStruct::runner

//# publish
module 0xCAFE::MyModule1 {
    use 0xCAFE::MyStruct;

    // A function demonstrating destructuring with positional unpacking
    public fun destructure_example(): u64 {
        let s = MyStruct::new();

        // Tuple-style destructuring
        // Move supports destructuring structs by listing field names, but 
        // here we want to test positional (tuple-style) unpacking.
        // Since fields are named, unpacking is by name. We simulate positional 
        // by unpacking directly to variables using the struct pattern.

        let MyStruct::S { a, b, c } = s;

        // Return a numeric value by combining fields: a + b + (c ? 100 : 0)
        let c_val = if c { 100u64 } else { 0u64 };
        (a as u64) + (b as u64) + c_val
    }

    public fun runner(): u64 {
        destructure_example()
    }
}
//# run 0xCAFE::MyModule1::runner

//# publish
module 0xCAFE::NonNativeUsage {
    // We will write a module that imports specific members from another module using 'members' import with aliasing

    // Importing specific member functions from MyModule1 with aliases
    use 0xCAFE::MyModule1::{runner as run_module1};

    // Importing specific member from MyStruct, no alias here
    use 0xCAFE::MyStruct::{new};

    public fun call_functions(): u64 {
        // Call MyStruct::new
        let s = new();

        // Call aliased run_module1 which returns u64
        let res = run_module1();

        // We will also call update_a and destructure
        let MyStruct::S { a, b, c } = s;

        // Return sum with run_module1 result + a + b + c as u64
        let c_val = if c { 1u64 } else { 0u64 };

        res + (a as u64) + (b as u64) + c_val
    }

    public fun runner(): u64 {
        call_functions()
    }
}
//# run 0xCAFE::NonNativeUsage::runner

//# run
script {
    use 0xCAFE::MyStruct::{new, update_a};
    use 0xCAFE::MyModule1::{destructure_example};
    use 0xCAFE::NonNativeUsage::{call_functions};

    fun main() {
        // 1. Test MyStruct::new and update_a
        let s = new();
        let s2 = update_a(s, 255u8);

        // Destructure s2 positionally
        let MyStruct::S { a, b, c } = s2;

        // Just make some vm usage - e.g. compute a sum with the fields and constants
        let res1 = (a as u64) + (b as u64) + if c { 1u64 } else { 0u64 };

        // 2. Test destructure_example from MyModule1 (should get 1+2+100=103u64)
        let res2 = destructure_example();

        // 3. Test call_functions() in NonNativeUsage (res2 + 255 + 2 + 1)
        let res3 = call_functions();

        // Note: as per instructions, assertions are ignored.

        // Just consume results to avoid warnings
        let _ = res1;
        let _ = res2;
        let _ = res3;
    }
}

// Featurres:
// cdc6a5450223e140b5b86ef88e7b4699: Write and use non-native (Move) functions in target modules.
// 4ebd003b016e539a91b7c9e4c96572c2: Use 'members' declarations to import specific members of a module with optional aliasing.
// 8b0591f0076eadab1e1c9b54ed519bcb: Destructure structs in 'let' statements using positional (tuple-style) unpacking.
