//# publish
address 0x1 {
    module TestModule {
        use std::vector;
        use std::signer;

        #[test_attr]
        #[unknown_attr(param)]
        public struct MyStruct has copy, drop, store {
            value: u64,
        }

        public fun new_struct(val: u64): MyStruct {
            MyStruct { value: val }
        }

        // A function that returns a closure capturing a primitive variable
        public fun make_adder(x: u64): (u64) -> u64 {
            // closure capturing x
            move |y: u64| { x + y }
        }

        // A function that returns a closure capturing a struct
        public fun make_struct_adder(s: MyStruct): (u64) -> u64 {
            move |y: u64| { s.value + y }
        }

        // Runner function that exercises closures capturing primitive and struct variables
        public fun runner(): u64 {
            // Capture primitive
            let add_10 = make_adder(10);
            let res1 = add_10(5); // 15

            // Capture struct
            let s = new_struct(100);
            let add_struct_val = make_struct_adder(s);
            let res2 = add_struct_val(23); // 123

            res1 + res2 // 138
        }
    }
}
//# run 0x1::TestModule::runner


//# run
script {
    use std::signer;
    use 0x1::TestModule;

    fun main(account: signer) {
        let add_42 = TestModule::make_adder(42);
        // Invoke the closure with argument 8, expected 50
        let res = add_42(8);

        let my_struct = TestModule::new_struct(7);
        let add_struct = TestModule::make_struct_adder(my_struct);
        let res2 = add_struct(3);

        let total = res + res2; // 50 + 10 = 60
        // no assertions needed as per instruction
    }
}