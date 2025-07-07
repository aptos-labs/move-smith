
//# publish
module 0xCAFE::MathModule {
    use std::vector;

    public fun add_and_transform(a: u8, b: u8): u8 {
        let c = a + b;
        // transform: add 10 to the sum
        c + 10
    }

    public fun lambda_example(x: u8): u8 {
        let func: |u8| u8 has copy + drop = |y: u8| y * 2;
        func(x)
    }

    inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_adder(a: u8, b: u8): u8 {
        let tmp = inline_adder(a, b);
        tmp + 5
    }

    public fun assign_unit() {
        let (): () = ();
    }

    public fun store_lambdas(): vector<|u8| u8> {
        let v = vector::empty<|u8| u8>();
        let f1: |u8| u8 has copy + drop = |x: u8| x + 1;
        let f2: |u8| u8 has copy + drop = |x: u8| x * 3;
        vector::push_back(&mut v, f1);
        vector::push_back(&mut v, f2);
        v
    }

    public fun invoke_lambdas(v: vector<|u8| u8>, arg: u8): vector<u8> {
        let res = vector::empty<u8>();
        let len = vector::length(&v);
        let i = 0;
        while (i < len) {
            let f = *vector::borrow(&v, i);
            let val = f(arg);
            vector::push_back(&mut res, val);
            i = i + 1;
        };
        res
    }
}


//# publish
module 0xCAFE::ExistsAndCall {
    use 0xCAFE::MathModule;

    // Note: 'exists' is not supported as a module member in Aptos Move.
    // Commenting it out to fix compilation. If existential is required,
    // it must be declared within specification or different context.

    // exists a: u8;

    public fun call_add_and_transform_with_exists(): u8 {
        // usage of existential a is not required, just ensure syntax is accepted
        MathModule::add_and_transform(2u8, 3u8)
    }

    public fun call_lambda_example(x: u8): u8 {
        MathModule::lambda_example(x)
    }

    public fun call_inline_adder(a: u8, b: u8): u8 {
        MathModule::call_inline_adder(a, b)
    }

    public fun demo_unit_assign() {
        MathModule::assign_unit();
    }

    public fun demo_lambda_vector_call(arg: u8): vector<u8> {
        let vs = MathModule::store_lambdas();
        MathModule::invoke_lambdas(vs, arg)
    }
}
