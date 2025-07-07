//# publish
address 0x1 {
    module CaptureTest {
        use std::signer;

        #[known_attribute]
        #[unknown_attribute]
        struct S has copy, drop, store {
            x: u64,
        }

        // Function to test captured primitive variable in a closure-like scenario
        fun captured_primitive(x: u64): u64 {
            let y = x + 1;
            // simulate capture by a nested function pattern
            let add = |z: u64| { y + z }; // y is captured
            add(10)
        }

        // Function to test captured struct in a closure-like scenario
        fun captured_struct(s: S, addend: u64): u64 {
            let captured_x = s.x;
            let add = |v: u64| { captured_x + v + addend };
            add(5)
        }

        // Runner function to invoke tests without arguments
        public fun run_tests(_signer: &signer) {
            let primitive_result = captured_primitive(10);
            let s = S { x: 100 };
            let struct_result = captured_struct(s, 20);

            // We ignore assertions, just force call.
            let _ = primitive_result;
            let _ = struct_result;
        }
    }
}
//# run 0x1::CaptureTest::run_tests --signers 0x1;

//# run 0x1::CaptureTest::captured_primitive --args 42u64
//# run 0x1::CaptureTest::captured_struct --args 0x1::CaptureTest::S { x: 50 } 10u64 --signers 0x1

//# run
script {
    use 0x1::CaptureTest;

    fun main(s: signer) {
        let r1 = CaptureTest::captured_primitive(20);
        let s_inst = CaptureTest::S { x: 7 };
        let r2 = CaptureTest::captured_struct(s_inst, 3);
        // no asserts, just invoke 
        let _ = r1;
        let _ = r2;
    }
}