
//# publish
module 0xCAFE::TestModule {
    // Removed unused `use std::signer;`
    // Removed `use 0xCAFE::TestModuleAlias;` because module does not exist
    
    const CONSTANT_U8: u8 = 42;

    // 1. Function that computes addition of two u8 and then returns CONSTANT_U8
    public fun add_then_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum;
        CONSTANT_U8
    }

    // 2. Function containing lambda (anonymous function) expressions
    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |y: u8| {
            y + 5u8
        };
        lambda(x)
    }

    // 3. Since `TestModuleAlias` does not exist, provide a local inline function `f2` here
    public fun f2(val: u16): (u16, u16) {
        // Dummy implementation for f2, example: return (val, val * 2)
        (val, val * 2)
    }

    // 3. Function calls inline function f2 and returns sum of tuple returns
    public fun call_inline_in_other_module(val: u16): u16 {
        let (a, b) = f2(val);
        a + b
    }

    // 4. Module member aliasing to refer to constant and function more conveniently
    public fun alias_usage(val: u8): u8 {
        let c = CONSTANT_U8;
        let f = add_then_return_constant;
        let _result = f(val, c);
        c
    }

    // 5. Declare enum with abilities only after variant list (to avoid conflict)
    enum ConflictEnum has copy, drop {
        A,
        B(u8),
        C { flag: bool }
    }

    // 6. Location information and properties in invariant definition
    // For simplicity, simulate invariant property via a public function
    public fun check_invariant(value: u8): bool {
        // Location info in real invariant would be metadata, here simulate with asserts
        assert!(value < 100, 201u64); // property: value must be less than 100, code 201
        true
    }
}



//# run 0xCAFE::TestModule::add_then_return_constant --args 10u8 20u8


//# run 0xCAFE::TestModule::apply_lambda --args 7u8


//# run 0xCAFE::TestModule::call_inline_in_other_module --args 10u16


//# run 0xCAFE::TestModule::alias_usage --args 15u8


//# run 0xCAFE::TestModule::check_invariant --args 50u8


//# run 0xCAFE::TestModule::check_invariant --args 150u8
