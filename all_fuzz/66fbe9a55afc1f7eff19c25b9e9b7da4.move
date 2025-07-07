
//# publish
module 0xCAFE::NestedInline {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public inline fun add_and_increment(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        sum + 1
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // Function returning a u8 result by applying an anonymous function (lambda)
    public fun apply_lambda_twice(x: u8, y: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let tmp = f(x, y);
        f(tmp, 1u8)
    }

    // Function defining and using nested lambdas
    public fun nested_lambda_call(x: u8): u8 {
        let f1: |u8|u8 has copy+drop = |a: u8| { a + 2u8 };
        let f2: |u8|u8 has copy+drop = |b: u8| { f1(b) * 2u8 };
        f2(x)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedInline;

    public fun call_inline_add(a: u8, b: u8): u8 {
        NestedInline::add_and_increment(a, b)
    }
}


//# publish
module 0xCAFE::UpdateInvariant {
    struct Data has store {
        value: u8,
    }

    public fun create_data(): Data {
        Data { value: 0 }
    }

    public fun update_value(data: &mut Data, new_val: u8) {
        data.value = new_val;
    }

    spec update(update_value) {
        // The value in Data after update must be strictly increasing
        ensures old(data).value < data.value;
    }
}


//# publish
module 0xCAFE::UnpackPattern {
    struct Inner has drop, copy {
        a: u8,
        b: u8,
    }

    struct Outer has drop, copy {
        inner: Inner,
        c: u8,
        d: u8,
    }

    public fun unpack_all(o: Outer): (u8, u8, u8, u8) {
        let Outer { inner: Inner {a, b}, c, d } = o;
        (a, b, c, d)
    }

    public fun unpack_partial(o: Outer): (u8, u8) {
        let Outer { inner: Inner {a, ..}, .. } = o;
        (a, o.c)
    }
}


//# run 0xCAFE::NestedInline::add_u8 --args 10u8 20u8


//# run 0xCAFE::NestedInline::add_and_increment --args 5u8 4u8


//# run 0xCAFE::LambdaTest::apply_lambda_twice --args 3u8 4u8


//# run 0xCAFE::LambdaTest::nested_lambda_call --args 5u8


//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8


//# run 0xCAFE::UpdateInvariant::create_data


//# run 0xCAFE::UpdateInvariant::update_value --args 10u8


//# run 0xCAFE::UnpackPattern::unpack_all --args 0x0


//# run 0xCAFE::UnpackPattern::unpack_partial --args 0x0


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d2481eaa11a9e5dd99ed461357bcfa99: Declare 'update' invariants in spec blocks to specify conditions that must hold after updates.
// 5e600aa226a8d8449755d06c34c1c553: Unpack struct patterns with support for nested fields and optional `..` for field omission.
