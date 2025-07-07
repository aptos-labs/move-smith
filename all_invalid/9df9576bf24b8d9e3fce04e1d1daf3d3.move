
//# publish
module 0xCAFE::FilterTest {
    use std::vector;

    /// Just a dummy struct for keying purpose
    struct Dummy has store, key { x: u8 }

    /// Function to simulate filtering modules by name substring "Filter"
    /// Returns true if the module name contains "Filter"
    public fun filter_module(module_name: vector<u8>): bool {
        let sub = b"Filter";
        let len_sub = vector::length(&sub);
        let len_mod = vector::length(&module_name);
        let i = 0;
        while (i + len_sub <= len_mod) {
            // Manual slice comparison
            let slice = vector::borrow(&module_name, i, i + len_sub);
            if (vector::equals(slice, &sub)) {
                return true;
            };
            i = i + 1;
        };
        false
    }

    /// Function to simulate filtering scripts by checking byte length of the script name > 5
    public fun filter_script(script_name: vector<u8>): bool {
        vector::length(&script_name) > 5
    }

    /// Function to simulate filtering addresses by simple criteria: address last byte > 5
    public fun filter_address(addr: address): bool {
        // Use std::address::to_bytes() instead of method on address
        let addr_bytes = std::address::to_bytes(addr);
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
    /// Inline function f2 returns a struct of two u64 values instead of tuple (since tuples disallowed)
    struct Pair has copy, drop, store {
        first: u64,
        second: u64,
    }

    public inline fun f2(x: u64): Pair {
        Pair { first: x + 1, second: x + 2 }
    }

    /// Function f1 takes Pair and sums the two fields then adds 10
    public fun f1(vals: Pair): u64 {
        let a = vals.first;
        let b = vals.second;
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
