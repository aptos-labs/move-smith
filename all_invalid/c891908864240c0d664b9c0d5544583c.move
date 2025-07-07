//# publish
module 0xCAFE::AddressFilter {
    use std::vector;

    /// A struct to hold address and module name
    struct AddrModule has copy, drop, store {
        addr: address,
        module_name: vector<u8>,
    }

    /// Filters addresses that start with 0xCAFE and their module names
    public fun filter_cafe_modules(addr_modules: vector<AddrModule>): vector<AddrModule> {
        let mut result = vector::empty<AddrModule>();
        let length = vector::length(&addr_modules);
        let mut i = 0;
        while (i < length) {
            let am_ref = vector::borrow(&addr_modules, i);
            if (am_ref.addr == @0xCAFE) {
                vector::push_back(&mut result, *am_ref);
            };
            i = i + 1;
        };
        result
    }

    /// Creates sample AddrModule vector for testing
    public fun create_sample_addr_modules(): vector<AddrModule> {
        let v = vector::empty<AddrModule>();
        vector::push_back(&mut v, AddrModule { addr: @0xCAFE, module_name: b"ModuleA" });
        vector::push_back(&mut v, AddrModule { addr: @0xBEEF, module_name: b"ModuleB" });
        vector::push_back(&mut v, AddrModule { addr: @0xCAFE, module_name: b"ModuleC" });
        vector::push_back(&mut v, AddrModule { addr: @0xDEAD, module_name: b"ModuleD" });
        v
    }

    /// Runner function to test filter
    public fun runner(): vector<AddrModule> {
        let addr_modules = create_sample_addr_modules();
        filter_cafe_modules(addr_modules)
    }
}

//# run 0xCAFE::AddressFilter::runner


//# publish
module 0xCAFE::PrimeFactor {

    /// Returns the largest prime factor of n
    public fun largest_prime_factor(mut n: u64): u64 {
        let mut max_prime = 1u64;
        // Divide n by 2 as long as even
        while (n % 2 == 0) {
            max_prime = 2;
            n = n / 2;
        };
        // n must be odd at this point
        let mut i = 3u64;
        while (i * i <= n) {
            while (n % i == 0) {
                max_prime = i;
                n = n / i;
            };
            i = i + 2;
        };
        if (n > 2) {
            n
        } else {
            max_prime
        }
    }

    /// Runner function to test largest_prime_factor with a fixed number
    public fun runner(): u64 {
        largest_prime_factor(13195u64)
        // 13195 prime factors are 5,7,13,29 largest is 29
    }
}

//# run 0xCAFE::PrimeFactor::runner


//# publish
module 0xCAFE::ShadowingTest {

    /// Dummy function in library-shadowable module
    public fun library_func(): u8 {
        1
    }

    /// Dummy function in source-shadowable module
    public fun source_func(): u8 {
        2
    }
}

//# run 0xCAFE::ShadowingTest::library_func

//# run 0xCAFE::ShadowingTest::source_func

// Featurres:
// bd55926960feba0d24f5bc21babb44c0: Filter addresses and their associated modules based on specific criteria.
// 0b89dd6ddc06f3fa01b23ecf6ecef9c6: Test that the `largest_prime_factor` function correctly identifies the largest prime factor of a given number.
// 92c9bad335d82c6987dd46e45a072800: Shadow library modules with source modules when allowed by the compiler flags.
