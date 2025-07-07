//# publish
module 0x1::EnvCaptureTest {
    use std::signer;

    // Define a simple struct for capturing
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Function with a captured primitive variable inside a closure-like pattern.
    // The function returns x + y + param where x,y are captured variable and param is passed in.
    public fun captured_primitives(param: u64): u64 {
        let x = 10u64;
        let y = 5u64;
        // Simulate a closure by capturing x,y in inner function
        fun inner(z: u64): u64 {
            x + y + z
        }
        inner(param)
    }

    // Function capturing a struct variable "pt"
    public fun captured_struct(param: u64): u64 {
        let pt = Point { x: 7, y: 3 };
        fun inner(z: u64): u64 {
            pt.x + pt.y + z
        }
        inner(param)
    }

    // Runner function tests above two functions and sums their results
    // Uses an "inner" function with unknown attribute to test handling attributes
    #[unknown_attribute]
    public fun runner(): u64 {
        let v1 = captured_primitives(20);
        let v2 = captured_struct(30);
        v1 + v2
    }
}

//# run 0x1::EnvCaptureTest::runner

//# run
script {
    use 0x1::EnvCaptureTest;

    #[known_attribute]
    fun main() {
        let r = EnvCaptureTest::runner();
        // no assertion needed, just run for VM/compilation test
        // but doing a dummy local to check value usage
        let _ = r;
    }
}