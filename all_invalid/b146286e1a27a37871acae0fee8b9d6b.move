//# publish
address 0xCAFE {
    module Module0 {
        use std::vector;

        // Struct with copy and drop abilities to hold example values
        struct Example has copy, drop, store {
            x: u8,
            y: bool,
        }

        // Internal function: can only be called inside Module0
        fun internal_add_u8(a: u8, b: u8): u8 {
            a + b
        }

        // Internal function that returns a vector<u64>
        fun internal_make_u64_vector(): vector<u64> {
            let v = vector::empty<u64>();
            let v = vector::push_back(v, 10u64);
            let v = vector::push_back(v, 20u64);
            let v = vector::push_back(v, 30u64);
            v
        }

        // Public function to call internal functions from outside (like runner)
        public fun runner(): u8 {
            // 1. Defining locals and ensure definite initialization for all before use
            let a;
            let b;
            let c;

            a = 1u8;
            b = internal_add_u8(a, 2u8);
            c = b + 3u8;

            // 2. Declare vectors of u8, bool, and struct Example 
            let v_u8 = vector::empty<u8>();
            let v_u8 = vector::push_back(v_u8, a);
            let v_u8 = vector::push_back(v_u8, b);
            let v_u8 = vector::push_back(v_u8, c);

            let v_bool = vector::empty<bool>();
            let v_bool = vector::push_back(v_bool, true);
            let v_bool = vector::push_back(v_bool, false);
            let v_bool = vector::push_back(v_bool, (c > 2u8));

            let example1 = Example { x: a, y: true };
            let example2 = Example { x: b, y: false };
            let example3 = Example { x: c, y: (b > 2u8) };

            let v_example = vector::empty<Example>();
            let v_example = vector::push_back(v_example, example1);
            let v_example = vector::push_back(v_example, example2);
            let v_example = vector::push_back(v_example, example3);

            // 3. Use internal function returning vector<u64>
            let v_u64 = internal_make_u64_vector();

            // just return c as the demonstration of definite initialization
            c
        }
    }
}
//# run 0xCAFE::Module0::runner

//# run
script {
    use 0xCAFE::Module0;

    fun main() {
        let result = Module0::runner();
        // We don't assert but call to test VM and compiler handles all above features.
        return;
    }
}