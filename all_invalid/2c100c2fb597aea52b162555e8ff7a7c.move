
//# publish
module 0xCAFE::FilterTest {
    use std::vector;

    /// Just a dummy struct for keying purpose
    struct Dummy has store, key { x: u8 }

    /// Function to simulate filtering modules by name substring "Filter"
    /// Returns true if the module name contains "Filter"
    public fun filter_module(module_name: vector<u8>): bool {
        let sub = b"Filter";
        let i = 0;
        while i + vector::length(&sub) <= vector::length(&module_name) {
            if (vector::sub_vector(&module_name, i, i + vector::length(&sub)) == sub) {
                break;
            };
            i = i + 1;
        };
        i + vector::length(&sub) <= vector::length(&module_name)
    }

    /// Function to simulate filtering scripts by checking byte length of the script name > 5
    public fun filter_script(script_name: vector<u8>): bool {
        vector::length(&script_name) > 5
    }

    /// Function to simulate filtering addresses by simple criteria: address last byte > 5
    public fun filter_address(addr: address): bool {
        let addr_bytes = addr.to_bytes();
        let last = *vector::borrow(&addr_bytes, vector::length(&addr_bytes) - 1);
        last > 5
    }
}


//# run 0xCAFE::FilterTest::filter_module --args b"ModuleFilterTest"


//# run 0xCAFE::FilterTest::filter_script --args b"RunScript"


//# run 0xCAFE::FilterTest::filter_address --args 0xCAFE



//# publish
module 0xCAFE::NestedLocalUpdate {
    /// This function demonstrates updating local variables inside nested blocks and summing them
    public fun nested_update_sum(): u64 {
        let a = 3u64;
        {
            a = a + 2;
            {
                a = a + 5;
            };
        };
        let b = 7u64;
        {
            b = b + 4;
            {
                b = b + 1;
            };
        };
        a + b
    }
}


//# run 0xCAFE::NestedLocalUpdate::nested_update_sum



//# publish
module 0xCAFE::NestedInlineCalls {
    /// Inline function f2 returns a tuple of (a+1, a+2)
    public inline fun f2(x: u64): (u64, u64) {
        (x + 1, x + 2)
    }

    /// Function f1 takes a tuple and sums the two fields then adds 10
    public fun f1(vals: (u64, u64)): u64 {
        let (a, b) = vals;
        let sum = a + b;
        sum + 10
    }

    /// Runner function applies f2 to 3 and then passes result to f1, returning final output
    public fun runner(): u64 {
        let vals = f2(3);
        f1(vals)
    }
}


//# run 0xCAFE::NestedInlineCalls::runner


// Featurres:
// aea0924f9167959f01edde6ae806553e: Filter modules, scripts, or addresses based on specific criteria during compilation.
// 61cadd41a5787fae8572999699bd9051: Test that the Move function correctly updates local variables within nested expression blocks and sums their updated values.
// cc8c69755e71ae8b32b329d7d21583ea: Test that the nested inline functions in the module correctly compute the value by applying f2 to 3 and then passing the result to f1, resulting in the correct final output.
