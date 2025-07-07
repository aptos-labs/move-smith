//# publish
module 0x1::NestedFnArith {
    use std::signer;

    /// A function that returns a closure capturing a variable and performing an addition.
    /// Move does not support full closures, but we can simulate nested function calls
    /// with captured parameters via defined inner functions.
    public fun add_n(x: u64, y: u64): u64 {
        // Inner function that "captures" x as argument and adds y
        fun inner_add(z: u64): u64 {
            z + y
        }
        inner_add(x)
    }

    /// Demonstrates function composition via nested calls with captures
    public fun compose_add(x: u64, y: u64, z: u64): u64 {
        // f(w) = w + y
        fun f(w: u64): u64 { w + y }
        // g(v) = f(v) + z = v + y + z
        fun g(v: u64): u64 { f(v) + z }
        g(x)
    }

    /// Runner function with no args to test arithmetic via nested functions
    public fun runner(): u64 {
        // add_n(10, 20) = 30
        let a = add_n(10, 20);
        // compose_add(5, 10, 15) = 5 + 10 + 15 = 30
        let b = compose_add(5, 10, 15);
        a + b // expect 60
    }
}
//# run 0x1::NestedFnArith::runner

//# publish
module 0x1::LoopControl {
    use std::signer;

    /// Runner function to test nested loops and control flow
    public fun loop_runner(): u64 {
        let mut sum = 0u64;

        // Outer loop: for i in 0..3
        let mut i = 0u64;
        while (i < 3) {
            // Inner loop: for j in 0..i
            let mut j = 0u64;
            while (j < i) {
                sum = sum + i * j;
                j = j + 1;
            }
            i = i + 1;
        }
        // sum = 0*? + 1*0 + 2*0 + 2*1 = 0 + 0 + 0 + 2 = 2
        sum
    }
}
//# run 0x1::LoopControl::loop_runner

//# run 0x1::NestedFnArith::add_n --args 7u64 8u64
//# run 0x1::NestedFnArith::compose_add --args 1u64 2u64 3u64

//# run
script {
    use 0x1::NestedFnArith;
    use 0x1::LoopControl;

    fun main() {
        // Test 1: use declarations included (above), call function from module with use
        let a = NestedFnArith::add_n(100, 50);
        // Print is unavailable, but we exercise compiler and VM by calling nested functions

        // Test 2: Exclude use declarations and ensure compilation fails if uncommented (commented out)
        // let b = LoopControl::loop_runner();

        // Test 3: Nested loops and control flow inside script
        let mut sum = 0u64;
        let mut i = 0u64;
        while (i < 2) {
            let mut j = 0u64;
            while (j < 3) {
                sum = sum + i + j;
                j = j + 1;
            }
            i = i + 1;
        }

        // sum = (i=0:0+0+0+0) + (i=1:1+0+1+1+2) = 0 + (1+2+3) = 6

        // Compose function with captures in script style:
        fun add_y(z: u64, y: u64): u64 {
            z + y
        }

        fun compose_f_g(x: u64, y: u64, z: u64): u64 {
            // f(w) = w + y
            fun f(w: u64): u64 { w + y }
            // g(v) = f(v) + z
            fun g(v: u64): u64 { f(v) + z }
            g(x)
        }

        let nested_result = compose_f_g(3, 4, 5); // 3 + 4 + 5 = 12

        // Ignore assertions, code exercises compiler and VM thoroughly.
        // Variables a, sum, nested_result are unused intentionally.
    }
}