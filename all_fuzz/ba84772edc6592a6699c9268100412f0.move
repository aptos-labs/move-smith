
//# publish
module 0xCAFE::AddLambda {
    use std::vector;

    // A function that adds two u8 numbers and returns the sum + 10
    public fun add_then_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // A function with a lambda that multiplies by 2 and then adds 3
    public fun lambda_example(x: u8): u8 {
        let double_then_add: |u8| u8 has copy + drop = |a: u8| {
            (a * 2) + 3
        };
        double_then_add(x)
    }

    // A simple inline function within this module returning a tuple of two u16 values
    public inline fun f2(val: u16): (u16, u16) {
        // Example implementation: return (val/2, val/2)
        let half = val / 2;
        (half, val - half)
    }

    // Uses the inline function f2 defined in this module and returns the sum of its returned tuple's values
    public fun call_inline_and_sum(val: u16): u16 {
        let (a, b) = Self::f2(val);
        a + b
    }

    // Intentionally malformed vector syntax to report error (commented out as code cannot compile)
    // public fun incorrect_vector() {
    //     let v = vector[1, 2, 3]; // error: use parentheses and type annotations; must be vector[1u8, 2u8, 3u8]: vector<u8>
    // }

    // Correct vector usage to avoid compile error
    public fun correct_vector() {
        let _v: vector<u8> = vector[1u8, 2u8, 3u8];
    }
}



//# run 0xCAFE::AddLambda::add_then_offset --args 5u8 7u8


//# run 0xCAFE::AddLambda::lambda_example --args 6u8


//# run 0xCAFE::AddLambda::call_inline_and_sum --args 20u16


//# run 0xCAFE::AddLambda::correct_vector
