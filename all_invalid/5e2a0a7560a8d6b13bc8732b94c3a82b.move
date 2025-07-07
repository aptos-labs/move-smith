
//# publish
module 0xCAFE::TestFeatureCoverage {
    use std::vector;
    use std::signer;
    use 0xCAFE::MyModule;

    // Helper function to call a module function with varied arguments
    public fun call_module_func_with_args() {
        // Call MyModule::f1 with module access, no type args, and simple args
        let _ = MyModule::f1(7u8, false);

        // Call MyModule::f2 inline function with a u16 argument
        let (a, b) = MyModule::f2(20);

        // Call MyModule::f3 with a u16 argument
        let _s = MyModule::f3(15);

        // Call MyModule::f4 to test match and asserts
        MyModule::f4();

        // Call MyModule::f5 and bind lambda, then call it
        let _lambda = copy MyModule::f5;
        let (c, d) = _lambda(5u8, 6u8);
        let _ = (c, d);

        // Call MyModule::f6 with a lambda argument
        let lambda_fn: |u8|u8 = |x| { x + 10 };
        let res = MyModule::f6(lambda_fn, 3);
    }

    // Function to create various match statements on enum E with destructuring
    public fun match_enum_e(e: E): u32 {
        match (e) {
            E::V1 => 100,
            E::V2(x, y) => {
                // Sum the tuple elements
                x + y
            },
            E::V3 { a } => {
                if (a) {
                    1
                } else {
                    0
                }
            }
        }
    }

    // Function to test match with nested destructuring and wildcards
    public fun match_with_destructuring_and_wildcards(e: E): u32 {
        match (e) {
            E::V3 { a: true } => 42,
            E::V3 { a: false } => 24,
            E::V2(x, 0) => x,
            E::V2(_, y) => y,
            E::V1 => 7,
        }
    }

    // Function to create a lambda capturing non-reference variables
    public fun lambda_capture_test(val1: u8, val2: u8): u8 {
        let captured_val1 = val1;
        let captured_val2 = val2;

        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = captured_val1 * captured_val2;
            (sum, prod)
        };
        let (s, p) = lambda(3, 4);
        // Return sum for validation
        s
    }

    // Function to test variable binding inside switch-like match with destructuring
    public fun match_struct_with_binding(s: S): u32 {
        match (s) {
            S { x, y } => {
                x + y
            }
        }
    }
}


//# run 0xCAFE::TestFeatureCoverage::call_module_func_with_args


//# run 0xCAFE::TestFeatureCoverage::match_enum_e --args 0xCAFE::MyModule::E::V2(5, 10)

 
//# run 0xCAFE::TestFeatureCoverage::match_enum_e --args 0xCAFE::MyModule::E::V3 { a: true }

 
//# run 0xCAFE::TestFeatureCoverage::match_with_destructuring_and_wildcards --args 0xCAFE::MyModule::E::V2(3, 0)

 
//# run 0xCAFE::TestFeatureCoverage::match_with_destructuring_and_wildcards --args 0xCAFE::MyModule::E::V3 { a: false }

 
//# run 0xCAFE::TestFeatureCoverage::lambda_capture_test --args 8u8 5u8

// Featurres:
// 21dfdda52130773b42f66a6fd74ad91f: Create function call expressions with module access, macro flag, type arguments, and argument list.
// 75e79eec27f2b7c1341805305b2da456: Test that match statements on enums with both tuple and struct variants correctly support pattern matching with destructuring, wildcards, and binding to extract nested fields.
// e8560c6eb8ae69c496035ef838c8baa6: Capture variables inside lambda expressions provided they are not references and possess the required abilities.
