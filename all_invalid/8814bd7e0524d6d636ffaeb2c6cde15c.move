// transactional_test.move

address 0xA1 {
    module Constants {
        const SOME_CONST: u64 = 42;
        const ZERO_CONST: u8 = 0;
    }
}

address 0xB2 {
    /// A module that defines a struct and a function referencing constants and local/module names.
    module TestModule {
        use 0xA1::Constants;

        struct MyResource has key {
            value: u64,
        }

        public fun new_resource(): MyResource {
            // Reference constant with module qualification
            MyResource { value: Constants::SOME_CONST }
        }

        public fun get_const_plus_one(): u64 {
            Constants::SOME_CONST + 1
        }

        public fun compare_with_zero(input: u8): bool {
            // Reference constant unqualified (local, after aliasing below)
            input == ZERO_CONST
        }
        
        // Local constant (test direct local name reference)
        const ZERO_CONST: u8 = 0;
    }
}

// Testing the above in a transactional test

script {
    use 0xB2::TestModule;
    use 0xA1::Constants;

    fun main() {
        // 1. Reference local or module names directly as expressions:
        // Creating resource using module constant reference
        let res = TestModule::new_resource();
        assert!(res.value == 42, 1);

        // Testing function returning constant + 1
        let v = TestModule::get_const_plus_one();
        assert!(v == 43, 2);

        // 2. Reference constants with optional module qualification:
        // Direct qualified constant
        let val_qualified: u64 = Constants::SOME_CONST;
        assert!(val_qualified == 42, 3);

        // Direct unqualified constant via local const in TestModule (inside another call)
        let zero_check = TestModule::compare_with_zero(0);
        let zero_check_false = TestModule::compare_with_zero(1);
        assert!(zero_check, 4);
        assert!(!zero_check_false, 5);

        // 3. Named addresses resolved to concrete numerical addresses:
        // Addresses used above: 0xA1 for Constants, 0xB2 for TestModule.
        // Verifying these addresses in the script explicitly:
        assert!(@0xA1 == 0xA1, 6);
        assert!(@0xB2 == 0xB2, 7);
    }
}

// Featurres:
// 78520ca50c9e7a8aa1f699cba2de2832: Reference local or module names directly as expressions.
// e41df40c11331f9327feead28ff6e8d1: Reference constants with optional module qualification.
// ab553b4b3f5bbbda29b5fe4c07380450: Use named addresses in Move modules, which are resolved to concrete numerical addresses for test identification and execution.
