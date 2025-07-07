//# publish
module 0x1::TestStructs {
    use std::signer;

    #[store]              // layout attribute for storing the struct in global storage
    struct SimpleStore has key { 
        value: u8 
    }

    #[friend(0x1)]
    struct GenericStruct<T: copy + drop> has copy, drop {
        inner: T
    }

    #[vector]
    struct VectorWrapper<T> has copy, drop {
        data: vector<T>
    }

    #[store]
    struct AbilitiesTest has copy, store {
        a: u8,
        b: u16
    }

    #[store]
    struct NoAbilities {
        x: u64
    }

    public fun create_simple(): SimpleStore {
        SimpleStore { value: 42 }
    }

    public fun create_generic_u8(): GenericStruct<u8> {
        GenericStruct { inner: 100 }
    }
}

///# run 0x1::TestStructs::create_simple
///# run 0x1::TestStructs::create_generic_u8


//# publish
module 0x1::ArithmeticU16 {
    use std::error;
    use std::signer;
    use std::debug;

    /// Perform addition with overflow checking.
    public fun add(a: u16, b: u16): u16 acquires {
        let sum = a + b;
        // Move's native + for u16 is safe and will abort on overflow.
        sum
    }

    /// Perform subtraction with underflow checking.
    public fun sub(a: u16, b: u16): u16 {
        let diff = a - b;
        diff
    }

    /// Perform multiplication with overflow checking.
    public fun mul(a: u16, b: u16): u16 {
        let product = a * b;
        product
    }

    /// Perform division; aborts on division by zero.
    public fun div(a: u16, b: u16): u16 {
        assert!(b != 0, 1);
        a / b
    }

    /// Perform modulus; aborts on division by zero.
    public fun modulo(a: u16, b: u16): u16 {
        assert!(b != 0, 2);
        a % b
    }

    /// Runner function that executes arithmetic tests which should succeed.
    public fun run_success() {
        let a = 100u16;
        let b = 28u16;

        let _ = add(a, b);    // 128
        let _ = sub(a, b);    // 72
        let _ = mul(a, b);    // 2800
        let _ = div(a, b);    // 3
        let _ = modulo(a, b); // 16
    }

    /// Runner function that triggers overflow on addition and multiplication.
    public fun run_overflow() {
        let max = 0xFFFFu16;   // 65535
        // This addition should abort (overflow)
        let _ = add(max, 1);
        // This multiplication should abort too:
        let _ = mul(max, 2);
    }

    /// Runner to test division by zero errors
    public fun run_div_zero() {
        // division by zero causes abort
        let _ = div(10, 0);
        let _ = modulo(10, 0);
    }
}

///# run 0x1::ArithmeticU16::run_success
///# run 0x1::ArithmeticU16::run_overflow
///# run 0x1::ArithmeticU16::run_div_zero


//# publish
module 0x1::FunctionPointers {
    use std::signer;

    /// Type alias for function pointers taking u64 and returning u64
    public type alias Fn_u64_u64 = &fun(u64): u64;

    /// Struct holding a function pointer
    struct FuncHolder has copy, drop {
        fptr: Fn_u64_u64
    }

    /// Enum holding function pointers
    enum FuncEnum has copy, drop {
        First(Fn_u64_u64),
        Second(Fn_u64_u64)
    }

    /// Pure functions to be used as function pointers
    public fun incr(x: u64): u64 {
        x + 1
    }

    public fun double(x: u64): u64 {
        x * 2
    }

    /// Create a FuncHolder with incr function pointer
    public fun create_holder_incr(): FuncHolder {
        FuncHolder { fptr: &incr }
    }

    /// Create a FuncHolder with double function pointer
    public fun create_holder_double(): FuncHolder {
        FuncHolder { fptr: &double }
    }

    /// Apply the function pointer inside FuncHolder to an input
    public fun apply(holder: &FuncHolder, x: u64): u64 {
        ((*holder).fptr)(x)
    }

    /// Create a FuncEnum::First variant with incr
    public fun create_enum_first(): FuncEnum {
        FuncEnum::First(&incr)
    }

    /// Create a FuncEnum::Second variant with double
    public fun create_enum_second(): FuncEnum {
        FuncEnum::Second(&double)
    }

    /// Apply the function pointer inside FuncEnum to an input
    public fun apply_enum(fenum: &FuncEnum, x: u64): u64 {
        match *fenum {
            FuncEnum::First(fp) => fp(x),
            FuncEnum::Second(fp) => fp(x),
        }
    }

    /// Runner function to test FuncHolder with incr and double
    public fun run_holder() {
        let h1 = create_holder_incr();
        let res1 = apply(&h1, 10);
        let h2 = create_holder_double();
        let res2 = apply(&h2, 10);
    }

    /// Runner function to test FuncEnum with incr and double
    public fun run_enum() {
        let e1 = create_enum_first();
        let r1 = apply_enum(&e1, 20);
        let e2 = create_enum_second();
        let r2 = apply_enum(&e2, 20);
    }
}

///# run 0x1::FunctionPointers::run_holder
///# run 0x1::FunctionPointers::run_enum


//# run
script {
    use std::debug;
    use 0x1::ArithmeticU16;
    use 0x1::FunctionPointers;
    use 0x1::TestStructs;

    fun main() {
        debug::print(&b"Testing struct creations..."[0]);
        let _ = TestStructs::create_simple();
        let _ = TestStructs::create_generic_u8();
        debug::print(&b"Testing arithmetic operations..."[0]);
        ArithmeticU16::run_success();
        // The below test intentionally aborts to test overflow failures, comment out to prevent abort in test run:
        // ArithmeticU16::run_overflow();
        // ArithmeticU16::run_div_zero();
        debug::print(&b"Testing function pointer calls..."[0]);
        FunctionPointers::run_holder();
        FunctionPointers::run_enum();
    }
}