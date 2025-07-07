//# publish
module 0x1::TestNestedBlocks {
    /// Function to test nested blocks and local variable updates
    public fun sum_nested(): u64 {
        let a = 1u64;
        let b = 2u64;
        let res = block {
            let a = a + 10u64;
            let inner_sum = block {
                let b = b + 20u64; 
                a + b // 11 + 22 = 33
            };
            inner_sum * 2 // 33 * 2 = 66
        };
        res + a + b // 66 + 1 + 2 = 69
    }

    /// Runner function to exercise the nested expression and local variable update test
    public entry fun run_nested_test() {
        ignore sum_nested();
    }
}
//# run 0x1::TestNestedBlocks::run_nested_test --signers 0x1

//# publish
module 0x2::TestInlineFunction {
    /// Inline function testing function pointer call and return of expected result
    public fun foo(f: &fn(u8, u8): u8, x: u8, y: u8): u8 {
        f(x, y) + x
    }

    public fun adder(x: u8, y: u8): u8 {
        x + y
    }

    /// Runner function for function pointer call via inline
    public entry fun run_inline_test() {
        let result = foo(&Self::adder, 4u8, 15u8); // adder(4, 15) = 19 + 4 = 23
        ignore result;
    }
}
//# run 0x2::TestInlineFunction::run_inline_test --signers 0x2

//# publish
module 0x3::TestScriptSpecs {
    use std::vector;
    use std::string;

    /// A sample struct representing a 'spec'
    struct Spec has copy, drop, store {
        name: string::String,
        valid: bool,
    }

    /// Take a vector of specs, filter valid, and return their names uppercased
    public fun process_specs(specs: vector<Spec>): vector<string::String> {
        let mut result = vector::empty<string::String>();
        let i = 0;
        let len = vector::length(&specs);
        while (i < len) {
            let s = vector::borrow(&specs, i);
            if (s.valid) {
                let upper = string::uppercase(&s.name);
                vector::push_back(&mut result, upper);
            };
            i = i + 1;
        };
        result
    }

    /// Runner function to test filtering/transforming specifications
    public entry fun run_specs_test() {
        let v = vector::empty<Spec>();
        vector::push_back(&mut v, Spec { name: string::utf8(b"foo"), valid: true });
        vector::push_back(&mut v, Spec { name: string::utf8(b"bar"), valid: false });
        vector::push_back(&mut v, Spec { name: string::utf8(b"baz"), valid: true });
        let upcased = process_specs(v);
        ignore upcased;
    }
}
//# run 0x3::TestScriptSpecs::run_specs_test --signers 0x3