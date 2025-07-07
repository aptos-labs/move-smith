
//# publish
module 0xCAFE::SpecOptionLambda {
    use std::option;
    use std::vector;

    struct Data has store {
        value: u64
    }

    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    // Inline function taking a lambda as an argument and invoking it
    public inline fun modify_with_lambda(x: u64, f: |u64|u64): u64 {
        f(x)
    }

    // Function returning an Option<Data>
    public fun create_data_option(b: bool): option::Option<Data> {
        let res = if (b) {
            option::some(Data { value: 42 })
        } else {
            option::none<Data>()
        };
        res
    }

    // Function consuming Option<Data> and returning u64
    public fun read_data_option(opt: option::Option<Data>): u64 {
        match (opt) {
            option::Option::Some(d) => d.value,
            option::Option::None => 0,
        }
    }

    // Spec block with an unbound name and expressions involving Option
    spec module {
        // This spec accesses an unbound name `undefined_var` which should be ignored gracefully by the verifier.
        update {
            let o = option::some(1u64);
            let _ = option::is_some(&o);
            let _ = undefined_var + 1u64;
        }
    }

    public fun run_lambda_test(x: u64): u64 {
        let lambda: |u64|u64 has copy+drop = |a: u64| { a * 2 };
        modify_with_lambda(x, lambda)
    }

    public fun run_option_test() {
        let some_data = create_data_option(true);
        let none_data = create_data_option(false);

        let _ = read_data_option(some_data);
        let _ = read_data_option(none_data);
    }

    // Runner function for all tests
    public fun runner() {
        let _ = run_lambda_test(10u64);
        run_option_test();
    }
}



//# run 0xCAFE::SpecOptionLambda::runner
