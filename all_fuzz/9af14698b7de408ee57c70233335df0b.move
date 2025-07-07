
//# publish
module 0xCAFE::AddModule {
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_test(): u8 {
        let twice = |a: u8| { a * 2 };
        twice(7u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    struct Spanned<T> has copy, drop, store {
        value: T,
        start: u64,
        end: u64,
    }

    public fun create_spanned(value: u8, start: u64, end: u64): Spanned<u8> {
        Spanned { value, start, end }
    }

    public fun multiple_tuple_assignments(): (u8, u8) {
        let (a, b) = (3u8, 4u8);
        let (x, y) = (a + 1, b + 1);
        (x, y)
    }
}


//# publish
module 0xCAFE::UseAddModule {
    use 0xCAFE::AddModule;

    public fun nested_inline_calls(a: u8, b: u8): u8 {
        let sum = AddModule::inline_add(a, b);
        AddModule::add_two(sum, 5u8)
    }

    public fun hex_string_test(): vector<u8> {
        x"facefeeddeadbeef"
    }
}


//# run 0xCAFE::AddModule::add_two --args 6u8 5u8


//# run 0xCAFE::AddModule::lambda_test


//# run 0xCAFE::AddModule::create_spanned --args 9u8 100u64 200u64


//# run 0xCAFE::AddModule::multiple_tuple_assignments


//# run 0xCAFE::UseAddModule::nested_inline_calls --args 3u8 4u8


//# run 0xCAFE::UseAddModule::hex_string_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 38fa6b6e52f19006f26511efa2fb037a: Create a spanned value with location information for source code tracking.
// 9a42e06a9229d7c6adf6b846b10e1593: Create hex byte strings with 'x""' prefix.
// d479217191dddd027e7ba5e8ee233f7b: Use complex lvalues such as tuples on the left-hand side of assignment to assign multiple variables at once.
