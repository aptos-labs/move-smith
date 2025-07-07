
//# publish
module 0xDEAD::TestVariableAssignment {
    use std::vector;

    // Function that tests variable assignment in both branches of if-else with uninitialized variable
    public fun test_if_else_assign(flag: bool): u64 {
        let value: u64;
        if (flag) {
            value = 10;
        } else {
            value = 20;
        };
        value
    }

    // Function to test local variable assignment directly
    public fun test_local_assignment(x: u8): u8 {
        let y: u8 = x;
        y
    }
}


//# publish
module 0xBEEF::TestModules {
    // These modules will be checked for bytecode correctness

    // Module with simple functions
//# publish
    module 0xBAAD::SimpleModule {
        public fun dummy() {
            let a: u8 = 1;
            let b: u64 = 2;
            let c: bool = true;
        }
    }

    // Module with nested structs and enums
//# publish
    module 0xF00D::NestedTypes {
        struct InnerStruct has copy, store {
            value: u128
        }

        struct OuterStruct has copy, store {
            inner: InnerStruct,
            flag: bool
        }

        enum TestEnum has copy, drop {
            Variant1,
            Variant2(u8, u8),
            Variant3 { a: bool }
        }

        public fun create_outer(val: u128, b: bool): OuterStruct {
            let inner_struct = InnerStruct { value: val };
            let outer_struct = OuterStruct { inner: inner_struct, flag: b };
            outer_struct
        }
    }
}


//# run 0xDEAD::TestVariableAssignment::test_if_else_assign --args false


//# run 0xDEAD::TestVariableAssignment::test_local_assignment --args 42u8


//# run 0xBEEF::TestModules::SimpleModule::dummy


//# run 0xBEEF::TestModules::NestedTypes::create_outer --args 123456789u128 true


// Featurres:
// 23358b71c0ef160b4e84c7f263291e48: Test variable assignment in both branches of an if-else statement with an uninitialized variable.
// a4fe7db2390dba35925d2efeae1a9883: Assign to local variables directly.
// b5d81a20a5398c9d5b7dc51584b5ca34: Define modules in Move that will be verified for bytecode correctness after compilation.
