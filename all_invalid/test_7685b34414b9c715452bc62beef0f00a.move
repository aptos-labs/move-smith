//# publish
module 0xabcde::nested_structs {
    struct Inner has drop {
        a: u64,
        b: u64,
    }

    struct Outer has drop {
        inner: Inner,
        c: u64,
    }

    public fun create_struct(): Outer {
        let inner = Inner { a: 10, b: 20 };
        let outer = Outer { inner, c: 30 };
        outer
    }

    public fun sum_fields(): u64 {
        let s = create_struct();
        let Outer { inner, c } = s;
        let Inner { a, b } = inner;
        a + b + c
    }
}

//# run 0xabcde::nested_structs::sum_fields

//# publish
module 0xabcde::complex_pattern {
    struct Data has drop {
        x: u64,
        y: u64,
        z: u64,
    }

    public fun produce(): Data {
        Data { x: 2, y: 4, z: 6 }
    }

    public fun destructure_and_sum(): u64 {
        let d = produce();
        // Pattern matching with nested destructuring
        let Data { x, y, z } = d;
        x + y + z
    }
}

//# run 0xabcde::complex_pattern::destructure_and_sum

//# publish
module 0xabcde::option_transformation {
    use std::option;

    /// Applies a function to the contained value if some, otherwise returns none
    public fun transform_option<Elm, ResultElm>(
        opt: option::Option<Elm>,
        f: |Elm| ResultElm
    ): option::Option<ResultElm> {
        if (option::is_some(&opt)) {
            option::some(f(option::extract(&mut opt)))
        } else {
            option::none()
        }
    }

    public fun create_some(): option::Option<u64> {
        option::some(7)
    }
}

//# run 0xabcde::option_transformation::transform_option --args 0xabcde::option_transformation::create_some

//# publish
module 0xabcde::test_combined {
    use std::option;
    use 0xabcde::option_transformation;
    use 0xabcde::nested_structs;

    public fun run_all_tests(): u64 {
        // Test nested_structs sum
        let sum = nested_structs::sum_fields();

        // Test option transformation
        let opt = option::some(5);
        let transformed = option_transformation::transform_option(opt, |e| e * 10);
        let val = option::extract(&mut transformed);

        sum + val
    }
}

//# run 0xabcde::test_combined::run_all_tests