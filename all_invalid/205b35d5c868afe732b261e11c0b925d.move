// This transactional test covers:
// 1. Structs with type parameters
// 2. Basic comparison, logical, bitwise, shift, arithmetic ops (without assertions as requested)
// 3. Assignment in if statement without braces in a script

// We use 0xCAFE address as required

//# publish
module 0xCAFE::TypeParamModule {
    // Define a generic struct with copy, store, drop, key abilities
    // to test type parameters on structs
    struct Wrapper<T> has copy, drop, store, key {
        value: T,
    }

    public fun new_wrapper<T>(v: T): Wrapper<T> {
        Wrapper { value: v }
    }

    // Runner function to test basic ops on integers and booleans, returning unit
    public fun runner(): () {
        let a: u8 = 10;
        let b: u8 = 3;
        let c: bool = true;
        let d: bool = false;

        // Arithmetic operations
        let _ = a + b;      // 13u8
        let _ = a - b;      // 7u8
        let _ = a * b;      // 30u8
        let _ = a / b;      // 3u8
        let _ = a % b;      // 1u8

        // Comparison operations
        let _ = a == b;     // false
        let _ = a != b;     // true
        let _ = a < b;      // false
        let _ = a <= b;     // false
        let _ = a > b;      // true
        let _ = a >= b;     // true

        // Logical operations
        let _ = c && d;     // false
        let _ = c || d;     // true
        let _ = !c;         // false

        // Bitwise operations
        let _ = a & b;      // 2u8  (10 = 1010, 3 = 0011, 1010 & 0011 = 0010)
        let _ = a | b;      // 11u8
        let _ = a ^ b;      // 9u8

        // Shift operations
        let _ = a << 1;     // 20u8
        let _ = a >> 2;     // 2u8

        // Instantiate a Wrapper<u8> and Wrapper<bool> to test generics
        let w1 = new_wrapper(42u8);
        let w2 = new_wrapper(true);

        // Use copy for w1.value and w2.value since u8 and bool has copy
        let v1 = copy w1.value;
        let v2 = copy w2.value;

        // No assertions needed as per instructions

        ()
    }
}
//# run 0xCAFE::TypeParamModule::runner

//# run
script {
    use 0xCAFE::TypeParamModule;

    fun main(_signer: signer) {
        // Test assignment in if statement without braces
        let mut x: u64 = 5;

        if (x < 10)
            x = x + 1;

        if (x > 10)
            x = x - 1;

        // just read x and w/o any asserts or further actions
        let y = x;
        let w = TypeParamModule::new_wrapper(y);

        // Touch w to confirm no unused variable error
        let _ = w;

        ()
    }
}

// Featurres:
// 530eba8c718b4aa02145503a03101af7: Specify type parameters for structs in Move modules
// ef5b780d2e211c0876ced1ee30acd3b5: Test that basic comparison, logical, bitwise, shift, and arithmetic operations work correctly with assertions.
// e6f62292f061ed9f4a0d4c0378174232: Test that assigning a value to a variable inside an if statement without braces works correctly in a Move script.
