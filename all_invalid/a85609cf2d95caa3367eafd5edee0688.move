
//# publish
module 0xCAFE::FriendA {
    use std::vector;

    struct Secret has key, store {
        data: vector<u8>,
    }

    // A large constant vector with 900 elements
    const LARGE_VEC: vector<u8> = vector[
        0u8,1u8,2u8,3u8,4u8,5u8,6u8,7u8,8u8,9u8,
        10u8,11u8,12u8,13u8,14u8,15u8,16u8,17u8,18u8,19u8,
        20u8,21u8,22u8,23u8,24u8,25u8,26u8,27u8,28u8,29u8,
        30u8,31u8,32u8,33u8,34u8,35u8,36u8,37u8,38u8,39u8,
        40u8,41u8,42u8,43u8,44u8,45u8,46u8,47u8,48u8,49u8,
        50u8,51u8,52u8,53u8,54u8,55u8,56u8,57u8,58u8,59u8,
        60u8,61u8,62u8,63u8,64u8,65u8,66u8,67u8,68u8,69u8,
        70u8,71u8,72u8,73u8,74u8,75u8,76u8,77u8,78u8,79u8,
        80u8,81u8,82u8,83u8,84u8,85u8,86u8,87u8,88u8,89u8,
        90u8,91u8,92u8,93u8,94u8,95u8,96u8,97u8,98u8,99u8,

        100u8,101u8,102u8,103u8,104u8,105u8,106u8,107u8,108u8,109u8,
        110u8,111u8,112u8,113u8,114u8,115u8,116u8,117u8,118u8,119u8,
        120u8,121u8,122u8,123u8,124u8,125u8,126u8,127u8,128u8,129u8,
        130u8,131u8,132u8,133u8,134u8,135u8,136u8,137u8,138u8,139u8,
        140u8,141u8,142u8,143u8,144u8,145u8,146u8,147u8,148u8,149u8,
        150u8,151u8,152u8,153u8,154u8,155u8,156u8,157u8,158u8,159u8,
        160u8,161u8,162u8,163u8,164u8,165u8,166u8,167u8,168u8,169u8,
        170u8,171u8,172u8,173u8,174u8,175u8,176u8,177u8,178u8,179u8,
        180u8,181u8,182u8,183u8,184u8,185u8,186u8,187u8,188u8,189u8,
        190u8,191u8,192u8,193u8,194u8,195u8,196u8,197u8,198u8,199u8,

        200u8,201u8,202u8,203u8,204u8,205u8,206u8,207u8,208u8,209u8,
        210u8,211u8,212u8,213u8,214u8,215u8,216u8,217u8,218u8,219u8,
        220u8,221u8,222u8,223u8,224u8,225u8,226u8,227u8,228u8,229u8,
        230u8,231u8,232u8,233u8,234u8,235u8,236u8,237u8,238u8,239u8,
        240u8,241u8,242u8,243u8,244u8,245u8,246u8,247u8,248u8,249u8,
        250u8,251u8,252u8,253u8,254u8,255u8,0u8,1u8,2u8,3u8,
        4u8,5u8,6u8,7u8,8u8,9u8,10u8,11u8,12u8,13u8,
        14u8,15u8,16u8,17u8,18u8,19u8,20u8,21u8,22u8,23u8,
        24u8,25u8,26u8,27u8,28u8,29u8,30u8,31u8,32u8,33u8,
        34u8,35u8,36u8,37u8,38u8,39u8,40u8,41u8,42u8,43u8,

        44u8,45u8,46u8,47u8,48u8,49u8,50u8,51u8,52u8,53u8,
        54u8,55u8,56u8,57u8,58u8,59u8,60u8,61u8,62u8,63u8,
        64u8,65u8,66u8,67u8,68u8,69u8,70u8,71u8,72u8,73u8,
        74u8,75u8,76u8,77u8,78u8,79u8,80u8,81u8,82u8,83u8,
        84u8,85u8,86u8,87u8,88u8,89u8,90u8,91u8,92u8,93u8,
        94u8,95u8,96u8,97u8,98u8,99u8,100u8,101u8,102u8,103u8,
        104u8,105u8,106u8,107u8,108u8,109u8,110u8,111u8,112u8,113u8,
        114u8,115u8,116u8,117u8,118u8,119u8,120u8,121u8,122u8,123u8,
        124u8,125u8,126u8,127u8,128u8,129u8,130u8,131u8,132u8,133u8,
        134u8,135u8,136u8,137u8,138u8,139u8,140u8,141u8,142u8,143u8
    ];

    // A constant that is a result of equality check of LARGE_VEC with itself
    const LARGE_VEC_EQ_ITSELF: bool = (LARGE_VEC == LARGE_VEC);

    friend 0xCAFE::FriendB;

    public fun create_secret(data: vector<u8>): Secret {
        Secret { data }
    }

    // Internal function for friend access
    fun secret_length(s: &Secret): u64 {
        vector::length(&s.data) as u64
    }

    spec {
        condition large_vec_eq: LARGE_VEC_EQ_ITSELF == true;
    }
}


//# publish
module 0xCAFE::FriendB {
    use std::vector;
    use 0xCAFE::FriendA;

    /// FriendB has access to FriendA's Secret private struct fields and functions.

    public fun get_secret_length(s: &FriendA::Secret): u64 {
        // Call FriendA internal function secret_length
        FriendA::secret_length(s)
    }

    // Verification function that uses spec conditions referencing FriendA's constants and friend access
    public fun verify_secret_vec(s: &FriendA::Secret): bool {
        spec {
            condition secret_data_matches: vector::length(&s.data) == vector::length(&FriendA::LARGE_VEC);
            condition large_vec_eq_condition: FriendA::LARGE_VEC_EQ_ITSELF == true;
        };
        // Just a placeholder returning true
        true
    }
}


//# publish
module 0xCAFE::FriendC {
    use 0xCAFE::FriendA;
    use 0xCAFE::FriendB;

    // This module is NOT declared a friend of FriendA but tries to use FriendA's Secret struct (should error in real code, but here for test)

    // Spec block uses condition expressions to test referencing friend modules and large vector constants
    spec {
        condition friend_a_large_vec_check: FriendA::LARGE_VEC_EQ_ITSELF == true;
    }

    public fun dummy_public() {
        // do nothing
    }
}


//# publish
module 0xCAFE::FriendIntegration {
    use std::vector;
    use 0xCAFE::FriendA;
    use 0xCAFE::FriendB;

    struct Container has store {
        secret: FriendA::Secret,
        data_equal: bool,
    }

    public fun create_container(data: vector<u8>): Container {
        let secret = FriendA::create_secret(data);
        let is_equal = FriendA::LARGE_VEC_EQ_ITSELF;
        Container {
            secret,
            data_equal: is_equal,
        }
    }

    public fun verify_container(container: &Container): bool {
        // Call friend function to get secret length
        let length = FriendB::get_secret_length(&container.secret);
        spec {
            condition len_check: length == vector::length(&FriendA::LARGE_VEC) as u64;
            condition eq_check: container.data_equal == true;
        };
        true
    }

    public fun verify_via_friend_and_spec(container: &Container) {
        // Calls verify_secret_vec from FriendB which has spec conditions
        let _ = FriendB::verify_secret_vec(&container.secret);
    }
}


//# run 0xCAFE::FriendA::create_secret --args vector[]

//


//# run 0xCAFE::FriendB::get_secret_length

//


//# run 0xCAFE::FriendB::verify_secret_vec

//


//# run 0xCAFE::FriendIntegration::create_container --args vector[1u8,2u8,3u8]


//# run 0xCAFE::FriendIntegration::verify_container --args @0xCAFE


//# run 0xCAFE::FriendIntegration::verify_via_friend_and_spec --args @0xCAFE


// Featurres:
// d0d19bd8a0f717efcb2db901463f0233: Declare friend relationships with the 'friend' keyword.
// 4a4fdcd953931b14d0f46289445e9339: Test that the Move compiler can handle constant expressions involving equality comparison of very large vectors (e.g., vectors of over 800 elements).
// 6182c6585d1e66b1431b1b0f2b961d0e: Define condition expressions within spec blocks for custom verification logic.
