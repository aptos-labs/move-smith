
//# publish
module 0xCAFE::FunctionFeatures {
    /// A struct to demonstrate generic function usage
    struct Container<T> has copy, drop {
        value: T
    }

    /// Simple function to add two u64 numbers
    public fun add_u64(x: u64, y: u64): u64 {
        x + y
    }

    /// Generic identity function
    public fun id<T: copy + drop>(x: T): T {
        x
    }

    /// Function that takes a function pointer and uses it
    public fun call_with_2(f: |u64, u64|u64): u64 {
        f(2u64, 3u64)
    }

    /// Function returning a function pointer
    public fun get_adder(): |u64, u64|u64 {
        add_u64
    }

    /// Higher order function; returns a closure incrementing its argument by a captured value
    public fun make_incrementer(n: u8): |u8|u8 {
        // Closure capturing n; increment argument by n
        move |x: u8| {
            x + n
        }
    }

    /// Demonstrate function pointers with generic functions
    public fun use_generic<T: copy + drop>(f: |T|T, val: T): T {
        f(val)
    }

    /// Recursive function calling itself; to test cycles in call graph detection
    public fun recursive_fn(n: u8): u8 {
        if (n == 0) {
            0
        } else {
            recursive_fn(n - 1) + 1
        };
    }

    /// Mutual recursion: fn_a calls fn_b and fn_b calls fn_a
    /// To test cycles in function call graphs
    public fun fn_a(x: u8): u8 {
        if (x == 0) {
            0
        } else {
            fn_b(x - 1) + 1
        };
    }

    public fun fn_b(x: u8): u8 {
        if (x == 0) {
            0
        } else {
            fn_a(x - 1) + 1
        };
    }

    /// Runner function exercising various features
    public fun runner() {
        // Use function pointer for add_u64
        let f_add: |u64, u64|u64 = add_u64;
        let _sum = f_add(10u64, 20u64);

        // Use generic function as first class value
        let f_id_num: |u64|u64 = id;
        let _val = f_id_num(100u64);

        let f_id_bool: |bool|bool = id;
        let _b = f_id_bool(true);

        // Pass function pointer to another function
        let result = call_with_2(f_add);

        // Get adder function pointer and call it
        let adder = get_adder();
        let _ = adder(5u64, 6u64);

        // Use closure returned by make_incrementer
        let inc = make_incrementer(5u8);
        let _inc_value = inc(10u8);

        // Use generic function as argument
        let _ = use_generic<u64>(id, 42u64);

        // Test recursive function
        let _rec = recursive_fn(5u8);

        // Test mutual recursion
        let _mutual = fn_a(3u8);

        // Declare distinct kind of members: constant and struct
        let _const_val = Self::CONST_VAL;

        let r = Resource {value: 10u64};
        drop(r);
    }

    const CONST_VAL: u64 = 1234;

    struct Resource has store {
        value: u64
    }
}


//# run 0xCAFE::FunctionFeatures::runner


// Featurres:
// 9cdacc7afe58cca2bcfe5785ae7f418c: Use this function to check for cycles in function call graphs within Move modules.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// 38c9b5c668830d116f1ace86df64486f: Declare distinct kinds of module members in a Move module.
