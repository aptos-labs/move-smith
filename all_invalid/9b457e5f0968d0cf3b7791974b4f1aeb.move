//# publish
address 0x1 {
    module EnvTest {
        use 0x1::Signer;
        use std::vector;
        use std::string::{Self, String};

        #[skip(lint_shadow_unions, lint_self_alias)]
        struct EnvStruct has store {
            val: u64,
        }

        // A function capturing primitives and a struct, returns sum of arguments + val stored in the struct
        public fun captured_primitives_and_struct(
            x: u64,
            y: u8,
            e: &EnvStruct
        ): u64 {
            let result = x + (y as u64) + e.val;
            result
        }

        // Helper to create EnvStruct
        public fun make_env_struct(val: u64): EnvStruct {
            EnvStruct { val }
        }

        // A runner function which uses captured_primitives_and_struct internally
        public fun runner(): u64 {
            let env = make_env_struct(42);
            let res = captured_primitives_and_struct(10, 5, &env);
            res
        }
    }
}
//# run 0x1::EnvTest::runner

//# publish
address 0x2 {
    module Dependency {
        #[skip(lint_shadow_unions)]
        struct DepStruct has store {
            val: u8,
        }

        public fun get_dep_value(): u8 {
            99
        }

        public fun make_dep_struct(): DepStruct {
            DepStruct { val: 7 }
        }
    }
}

//# publish
address 0x3 {
    module TestModule {
        use 0x2::Dependency;
        use 0x1::EnvTest;

        #[skip(lint_unused_vars)]
        struct TestStruct has store {
            a: u64,
            b: u8,
            ds: Dependency::DepStruct,
        }

        public fun new_test_struct(a: u64, b: u8): TestStruct {
            let ds = Dependency::make_dep_struct();
            TestStruct { a, b, ds }
        }

        public fun call_dep_value(): u8 {
            Dependency::get_dep_value()
        }

        // Call the function from EnvTest capturing env with a struct from Dependency
        public fun captured_env_use(): u64 {
            let ts = new_test_struct(20, 3);
            let env_struct = EnvTest::make_env_struct(ts.a);
            // reuse EnvTest function with captured variables
            let result = EnvTest::captured_primitives_and_struct(ts.a, ts.b, &env_struct);
            result
        }

        // Runner function to test calls
        public fun runner(): u64 {
            let val1 = call_dep_value();    // expects 99u8
            let val2 = captured_env_use();  // expects 20 + 3 + 20 = 43
            val1 as u64 + val2
        }
    }
}
//# run 0x3::TestModule::runner

//# run
script {
    use 0x3::TestModule;

    fun main() {
        let result = TestModule::runner();
        // no assertions needed, just run through compiler+VM
        let _ = result;
    }
}