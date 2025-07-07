//# publish
module 0xCAFE::SpecExample {
    use std::option;
    use std::signer;

    friend 0xCAFE::FriendModule;

    struct Data has store {
        val: u64,
    }

    /// An example specification that the value is always less than 1000
    spec script {
        invariant forall d: Data in global<Data> :: d.val < 1000;
    }

    public fun create_data(s: signer, val: u64) 
        acquires Data 
    {
        assert!(val < 1000, 1);
        let data = Data { val };
        move_to<Data>(&s, data);
    }

    /// Function only accessible by friend module to get value
    friend fun get_value_friend(addr: address): u64 acquires Data {
        let data_ref = borrow_global<Data>(addr);
        data_ref.val
    }

    /// Example inline specification that this function never returns odd numbers
    public inline spec fun always_even(x: u64): bool {
        x % 2 == 0
    }

    public fun double_if_even(x: u64): u64
        ensures always_even(result)
    {
        if (x % 2 == 0) {
            x * 2
        } else {
            x * 2 + 1
        }
    }

    /// Returns optional (pair of u64, u64) only if both inputs are even
    public fun optional_even_pair(x: u64, y: u64): option::Option<(u64, u64)> {
        if ((x % 2 == 0) && (y % 2 == 0)) {
            option::some((x, y))
        } else {
            option::none<(u64, u64)>()
        }
    }
}

//# run 0xCAFE::SpecExample::create_data --signers 0xBEEF --args 500u64

//# run 0xCAFE::SpecExample::double_if_even --args 10u64

//# run 0xCAFE::SpecExample::double_if_even --args 7u64

//# run 0xCAFE::SpecExample::optional_even_pair --args 4u64 6u64

//# run 0xCAFE::SpecExample::optional_even_pair --args 3u64 8u64


//# publish
module 0xCAFE::FriendModule {
    use 0xCAFE::SpecExample;

    /// Call friend function to get Data.val
    public fun get_data_val(addr: address): u64 acquires SpecExample::Data {
        SpecExample::get_value_friend(addr)
    }
}

//# run 0xCAFE::FriendModule::get_data_val --args 0xBEEF

// Featurres:
// 437c337878908cd2a0d8e57fa14c0f0c: Write Move functions with inline specifications to enable specification checking.
// 12320643fcfef0dfbdf644ac7558d719: Use module relationships such as friend modules to control which modules can access certain functions.
// 7e193095ff803e037a84a6410c5d2ecf: Handle optional binding results to ensure only valid pairs are included.
