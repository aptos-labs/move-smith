
//# publish
module 0xCAFE::AddModule {
    // 1: Test function that computes addition of two u8 values and returns a specific value
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // 2: Function containing lambda (anonymous function) expressions
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }

    // 5: Function modifying a local variable and returning result ensuring move semantics
    public fun modify_local_and_return(input: u8): u8 {
        let mut_val = input;
        let modified_val = mut_val + 5;
        modified_val
    }

    // 6: Function with ability constrained type parameter - function type with copy + drop
    public fun call_func_with_ability(fun_param: |u8| u8 has copy+drop, val: u8): u8 {
        fun_param(val)
    }

    spec module {
        // 4: Module-level spec block with 'module' target - just an example invariant
        invariant true;
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AddModule::use_lambda --args 3u8 4u8


//# run 0xCAFE::AddModule::modify_local_and_return --args 7u8


//# run 0xCAFE::AddModule::call_func_with_ability --args 6u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    // 3: Test calling inline function (here simulating nested calls)
    // We simulate inline by regular public function but call AddModule::add_and_return_sum internally
    public fun nested_call(x: u8, y: u8): u8 {
        let val = AddModule::add_and_return_sum(x, y);
        AddModule::modify_local_and_return(val)
    }
}


//# run 0xCAFE::NestedCallModule::nested_call --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c416dc1d62155276b1f629b93409bf9d: Declare module-level spec blocks with the 'module' target.
// 41a7e42786358f6234f852a8c37d00f0: Test that the function correctly modifies a local variable and returns the expected result without copying, ensuring move semantics are enforced.
// c58ec5bcad183e685aa4157b1ddd27cf: Specify ability constraints (such as copy, drop, store) on function type parameters.
