
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 7u8 8u8



//# publish
module 0xCAFE::LambdaModule {
    public fun use_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            p + q
        };
        let result = add(x, y);
        result
    }

    public fun nested_lambda(x: u8): u8 {
        let add_ten: |u8| u8 has copy+drop = |p: u8| {
            p + 10
        };
        let apply_and_double: |u8| u8 has copy+drop = |q: u8| {
            let inner_result = add_ten(q);
            inner_result * 2
        };
        apply_and_double(x)
    }
}



//# run 0xCAFE::LambdaModule::use_lambda --args 2u8 5u8



//# run 0xCAFE::LambdaModule::nested_lambda --args 3u8



//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let result = inline_add(a, b);
        result + 5u8
    }
}



//# run 0xCAFE::InlineCallModule::call_inline_and_add --args 1u8 2u8



//# publish
module 0xCAFE::DigitLengthModule {
    public fun digit_length(s: vector<u8>): u64 {
        let count = 0u64;
        let len = vector::length(&s);
        let i = 0u64;
        while (i < len) {
            let ch = *vector::borrow(&s, i as u64);
            let is_digit = (ch >= b'0' && ch <= b'9');
            if (is_digit) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }
}



//# run 0xCAFE::DigitLengthModule::digit_length --args b"abc1_2d3f4!5" 



//# publish
module 0xCAFE::MatchModule {

    enum SampleEnum has copy, drop {
        A,
        B(u8),
        C { c1: bool, c2: u8 }
    }

    public fun match_test(e: SampleEnum): u8 {
        let result = match(e) {
            SampleEnum::A => 1,
            SampleEnum::B(x) if x > 5 => 2,
            SampleEnum::B(x) => x,
            SampleEnum::C { c1, c2 } => if (c1) { c2 } else { 0 },
        };
        result
    }
}

// Fixed runs with enum values passed in correct form (pattern match values are not accepted as params directly):
// Provide constructor calls explicitly:

// for SampleEnum::A

//# run 0xCAFE::MatchModule::match_test --args 0

// for SampleEnum::B(7u8)

//# run 0xCAFE::MatchModule::match_test --args 1 7u8

// for SampleEnum::B(3u8)

//# run 0xCAFE::MatchModule::match_test --args 1 3u8

// for SampleEnum::C { c1: true, c2: 9u8 }

//# run 0xCAFE::MatchModule::match_test --args 2 true 9u8

// for SampleEnum::C { c1: false, c2: 9u8 }

//# run 0xCAFE::MatchModule::match_test --args 2 false 9u8
