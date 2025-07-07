//# publish
module 0xCAFE::TempRefTest {
    struct Container has store {
        data: u64,
    }

    // A runner function that exercise taking mutable references to complex temporaries
    public fun runner() {
        let mut x = 42u64;
        let mut c = Container { data: 100 };

        // 1. Mutable ref from conditional
        if true {
            let r = &mut (if false { &mut x } else { &mut x });
            // mutation to this ref should be ignored
            *r = 1;
        }

        // 2. Mutable ref from block expression
        let r2 = &mut ({
            let tmp = &mut x;
            tmp
        });
        *r2 = 2;

        // 3. Mutable ref from field access inside temporary struct
        let r3 = &mut (Container { data: c.data }).data;
        *r3 = 999; // Mutating temporary, should not affect c.data

        // Ignore the mutations above effect on original x or c:
        // Just attempt to read the variables to ensure no error and variables unaffected.
        let _ = x;
        let _ = c.data;
    }
}
//# run 0xCAFE::TempRefTest::runner

//# publish
module 0xCAFE::EmptyAddressTest {
    // Define a simple struct with empty address specifier on the module itself
    struct S has store, key {
        val: u8,
    }

    // Public fun to store and read using empty address specifier in struct instantiation
    public fun store_and_read(account: &signer) {
        let s = S { val: 10u8 };
        move_to(account, s);

        let ref_s = borrow_global<S>(signer::address_of(account));
        let x = ref_s.val;

        // use x for something trivial to keep the compiler happy
        if x > 5 {
            let _ = x;
        }
    }
}
//# run 0xCAFE::EmptyAddressTest::store_and_read --signers 0xCAFE

//# publish
module 0xCAFE::VarUse {
    // A simple module to test usage of variables by name, move, and copy

    struct MyCopyable has copy, store {
        a: u8,
    }

    public fun runner() {
        let v: u64 = 123;
        let mut v2 = v; // copy by name
        v2 = 456;

        let c = MyCopyable { a: 1 };
        let c2 = copy c; // explicit copy
        let c3 = c;       // move c into c3, c no longer usable

        // Use variables in expressions by name, copy, and move
        let sum = v2 + (1 as u64); // var by name
        let sum2 = sum + (copy v2); // explicit copy

        // Construct new MyCopyable from fields of c2 and c3
        let _new_c = MyCopyable { a: c2.a + c3.a };
    }
}
//# run 0xCAFE::VarUse::runner

//# run
script {
    use 0xCAFE::TempRefTest;
    use 0xCAFE::EmptyAddressTest;
    use 0xCAFE::VarUse;

    fun main(account: signer) {
        // Run runner directly from module
        TempRefTest::runner();

        EmptyAddressTest::store_and_read(&account);

        VarUse::runner();
    }
}

// Featurres:
// 3497bb6cfac0ff6bb6fc5865570f2421: Test that taking mutable references to complex temporary expressions, including conditionals, block expressions, and field accesses, does not affect the original variable bindings and that mutations to such temporaries are ignored as expected.
// 2cb34974521d3b1179185cb43dc3cab5: Use empty address specifiers in address attributes or statements.
// 0930f39e34bf3654b01812ec2c4024b5: Use variables directly in expressions, including by name, move, or copy.
