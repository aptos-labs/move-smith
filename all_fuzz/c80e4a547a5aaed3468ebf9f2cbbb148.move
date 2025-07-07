
//# publish
module 0xCAFE::MathAndLambda {
    use std::vector;

    /// A function that adds two u8 and if the sum is greater than 10, returns 42, else 0
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42
        } else {
            0
        };
    }

    /// A function demonstrating lambda usage that returns a lambda adding u8 values
    public fun get_adder(): |u8, u8| u8 has copy+drop {
        |x: u8, y: u8| {
            x + y
        }
    }

    /// Compose calling inline function from another module (MyModule::f2), and use returned tuple
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }

    spec module {
        // Axiom to say add_and_check always returns either 0 or 42
        axiom (forall a: u8, b: u8 :: 
            (self::add_and_check(a, b) == 0) || (self::add_and_check(a, b) == 42));
    }
}


//# run 0xCAFE::MathAndLambda::add_and_check --args 5u8 6u8


//# run 0xCAFE::MathAndLambda::add_and_check --args 2u8 3u8


//# run 0xCAFE::MathAndLambda::get_adder


//# run 0xCAFE::MathAndLambda::nested_inline_call --args 10u16



//# publish
module 0xCAFE::BuiltinFunctionsDemo {
    use std::signer;
    use std::vector;
    use std::string;

    public fun test_builtin_functions(s: signer) {
        let addr = signer::address_of(&s);

        // Use vector builtin functions
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 7u8);
        vector::push_back(&mut v, 8u8);
        let first_elem = *vector::borrow(&v, 0);
        let len = vector::length(&v);
        let popped = vector::pop_back(&mut v);

        // Use string builtin function (conversion to vector<u8>)
        let str_vec = string::utf8(b"test");
        let str_len = vector::length(&str_vec);

        // Some dummy use to avoid warnings
        assert!(first_elem == 7, 1);
        assert!(len == 2, 2);
        assert!(popped == 8, 3);
        assert!(str_len == 4, 4);

        // Use abort builtin - will not execute abort, just a dummy call commented out:
        // abort!(10);
    }

    spec module {
        axiom(true);
    }
}


//# run 0xCAFE::BuiltinFunctionsDemo::test_builtin_functions --signers 0xCAFE



//# publish
module 0xCAFE::ModuleSpecA {
    spec module {
        axiom true; // dummy axiom saying this module is usable
    }
}

//# publish
module 0xCAFE::ModuleSpecB {
    spec module {
        axiom true; // another dummy axiom from another package/module
    }
}

// Spec merging test:
// Combined axioms from multiple modules/packages happen naturally at VM link time, so this test approximates that concept.


//# run 0xCAFE::ModuleSpecA::spec


//# run 0xCAFE::ModuleSpecB::spec


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3d2ce9fc48b7ff7c6641f496ab39191d: Add 'axiom' conditions inside specification blocks using 'axiom' keywords.
// f38b160b196d610bbefb97265eba037b: Use the set of all built-in function names provided by the compiler.
// e35e649060d4d698d78069f7f1cbbbfb: Combine or merge module specifications from different package definitions.
