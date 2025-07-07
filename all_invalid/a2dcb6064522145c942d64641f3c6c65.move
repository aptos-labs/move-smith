
//# publish
module 0xBADF00D::TestModule {
    use std::vector;

    // Testing function calls with runtime arguments, type parameters, and visual annotations
    public fun test_function_calls() {
        let x = 42u8;
        let y = true;
        // Call function with arguments
        let result = f1(x, y);
        // Use the result to prevent unused variable warnings
        result;
    }

    // Function with type parameter in struct using phantom declare
    public fun create_struct_with_type_param<T>() {
        let s = StructWithTypeParameter<T> {field: 123};
        s;
    }

    // Function with inline type parameters in call
    public fun create_enum_with_type_param() {
        let e = E::V2(10, 20);
        e;
    }

    // Test function with annotations for visualizing exit state analysis
    public fun visualize_exit_state() {
        // We analyze the following code step-by-step:
        // 1. Assign a value
        let val: u8 = 7;
        // 2. Match on enum
        let result = match (E::V3 { a: true }) {
            E::V1 => 1,
            E::V2(x, y) => x + y,
            E::V3 { a } => if (a) { 2 } else { 3 },
        };
        result;
        // Visualize bytecode analysis: 
        // - After the match, the bytecode annotations would show analysis points for each arm.
        // - For example, the branch for E::V3 should be annotated to indicate condition evaluation.
    }

    // Function showcasing type parameter with phantom
    public fun phantom_type_demo<T>() {
        let s = StructWithTypeParameter<T> {field: default(),};
        s;
    }
}


//# run 0xBADF00D::TestModule::test_function_calls


//# run 0xBADF00D::TestModule::create_struct_with_type_param --args u8


//# run 0xBADF00D::TestModule::create_enum_with_type_param


//# run 0xBADF00D::TestModule::visualize_exit_state


//# run 0xBADF00D::TestModule::phantom_type_demo --args u8

// Featurres:
// 2efdd5eadd46989b80dc7348772f0d7c: Call functions or methods with runtime arguments using parentheses, such as `my_fn(args)`.
// 1e4ea42b70714ed824d356f20e055e8f: Specify type parameters with phantom declarations in struct definitions.
// e939c3053bed69e5d55cdedf93bdb14e: Visualize exit state analysis as bytecode annotations for debugging purposes.
