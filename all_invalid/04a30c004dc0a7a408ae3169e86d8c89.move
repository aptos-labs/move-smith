
//# publish
module 0xCAFE::TestGlobalAnalysis {
    // This module tests global analysis correctness by compiling complex features together
    public fun dummy() {}
}


//# publish
module 0xCAFE::TestParser {
    use std::assert;

    // Declare functions with binary expressions involving various operators

    public fun test_binary_expressions(): bool {
        let a: u64 = 10;
        let b: u64 = 20;
        let c: bool;

        // Equality and inequality
        assert!(a == 10, 1);
        assert!(b != 10, 2);
        // Comparisons
        assert!(a < b, 3);
        assert!(b > a, 4);
        // Bitwise operators (^, |, &)
        let xor = a ^ b;
        let or = a | b;
        let and = a & b;
        assert!(xor == (10 ^ 20), 5);
        assert!(or == (10 | 20), 6);
        assert!(and == (10 & 20), 7);
        // Shift operators (<<, >>)
        let shift_left = a << 2;
        let shift_right = b >> 1;
        assert!(shift_left == 40, 8);
        assert!(shift_right == 10, 9);
        // Arithmetic (+, -, *, /, %)
        assert!(a + b == 30, 10);
        assert!(b - a == 10, 11);
        assert!(a * 2 == 20, 12);
        assert!(b / 2 == 10, 13);
        assert!(b % 3 == 2, 14);
        // Range (..)
        let range_vec: vector<u64> = vector::empty();
        let _ = vector::push_back(&mut range_vec, a);
        let _ = vector::push_back(&mut range_vec, b);
        assert!(vector::length(&range_vec) == 2, 15);
        // Implication (==>)
        let imp = a < b ==> b > a;
        assert!(imp, 16);
        // Equivalence (<==>)
        let equiv = (a + 0 == a) <==> (b - 0 == b);
        assert!(equiv, 17);

        // combined complex expression
        c = ((a + b) > 15) && (a != b);
        assert!(c, 18);
        true
    }
}


//# run 0xCAFE::TestParser::test_binary_expressions


//# publish
module 0xCAFE::TestInit {
    use std::assert;
    use 0xCAFE::MyModule;

    // Map keys to their lengths plus two and values with three added
    public fun test_initialize() acquires MyModule {
        // invoke init
        MyModule::initialize();
        let keys_length = MyModule::get_keys_length();
        let values_sum = MyModule::get_values_sum();

        // Assuming keys length is 3 (from test keys) plus 2 = 5
        assert!(keys_length == 5, 1);
        // Assuming values are each original value +3
        assert!(values_sum == ( (100 + 3) + 200 + 3 + 300 + 3 ), 2);
    }
}


//# publish
module 0xCAFE::MyModule {
    use std::vector;
    use std::table::{Self, Table};
    use std::signer;

    // Store keys and values
    struct MyData has store, key {
        keys: vector<vector<u8>>,
        values: vector<u64>,
        // For the test, prepopulate some keys and values.
    }

    // static resource singleton
    struct GlobalData has key {
        data: MyData,
        initialized: bool,
    }

    var global: option<GlobalData> = none<GlobalData>;

    public fun initialize() {
        // initialize only once
        if (option::is_none(&global)) {
            let keys = vector::empty<vector<u8>>();
            let values = vector::empty<u64>();
            // inserting sample keys
            let _ = vector::push_back(&mut keys, b"key1");
            let _ = vector::push_back(&mut keys, b"key2");
            let _ = vector::push_back(&mut keys, b"key3");
            // inserting sample values
            let _ = vector::push_back(&mut values, 100);
            let _ = vector::push_back(&mut values, 200);
            let _ = vector::push_back(&mut values, 300);
            let data = MyData {keys, values};
            global = option::some(GlobalData {data, initialized: true});
        }
    }

    public fun get_keys_length(): u64 acquires GlobalData {
        let global_ref = borrow_global<GlobalData>(0xCAFE);
        vector::length(&global_ref.data.keys)
    }

    public fun get_values_sum(): u64 acquires GlobalData {
        let global_ref = borrow_global<GlobalData>(0xCAFE);
        let sum: u64 = 0;
        let len = vector::length(&global_ref.data.values);
        let i: u64 = 0;
        while (i < len) {
            let val = *vector::borrow(&global_ref.data.values, i);
            sum = sum + val;
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::MyModule::initialize --signers 0xBADD

// the above init ensures keys map to length 3, values sum to 600 (100+200+300)


//# publish
module 0xCAFE::TestContractSpecViolations {
    use std::assert;

    // Contract with specs that are correct
    public fun valid_contract(x: u64) {
        // Spec: x must be > 50
        assert!(x > 50, 100);
        // Function is pure
    }

    // Contract with violated spec
    public fun invalid_contract() {
        let x: u64 = 10;
        // Should trigger violation
        assert!(x > 50, 101);
    }
}


//# run 0xCAFE::TestContractSpecViolations::valid_contract --args 60u64

//# run 0xCAFE::TestContractSpecViolations::invalid_contract


//# publish
module 0xCAFE::TestCrossModuleInteraction {
    use 0xCAFE::MyModule;

    // Function to test interaction with MyModule
    public fun call_get_keys_length(): u64 {
        MyModule::get_keys_length()
    }
}


//# run 0xCAFE::TestCrossModuleInteraction::call_get_keys_length


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 6a2556ec38646785f8400fff16aac057: Parse binary expressions with support for operators such as '==', '!=', '<', '>', '<=', '>=', '||', '&&', '^', '|', '&', '<<', '>>', '+', '-', '*', '/', '%', '..', '==>', and '<==>'.
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
// 12f5220fa4b205380458401aa47bd581: Use specifications (specs) in your code to have them checked for correctness and purity by the compiler.
// 7976d22becb3d0788e35d04a5d3cc103: Test that a module exposing a function can be called from another module to retrieve a constant value.
