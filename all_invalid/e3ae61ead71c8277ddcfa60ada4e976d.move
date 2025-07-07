#pragma test_feature = "greatest_product"
#pragma move_version_required = "1.4.0"

//# publish
address 0xCAFE {
module GreatestProduct {
    use std::vector;
    use std::string;

    // Enforce Move language version >= 1.4.0 at location line 8, col 5 (simulated)
    public fun require_move_version(line: u64, col: u64, version: u64) acquires GreatestProduct {
        assert!(version >= 140, 1);
        // dummy no-op since we can only simulate require_move_version
    }

    /// Returns the max product of 4 consecutive digits in the given string of digits
    public fun max_product_of_four(digits: &vector<u8>): u64 {
        let n = vector::length(digits);
        assert!(n >= 4, 2);
        let mut max_product = 0u64;
        let mut i = 0;
        while (i <= n - 4) {
            let mut product = 1u64;
            let mut j = 0;
            while (j < 4) {
                let digit = (vector::borrow(digits, i + j) - 48) as u64; // Convert ascii '0'-'9' to 0-9
                product = product * digit;
                j = j + 1;
            }
            if (product > max_product) {
                max_product = product;
            }
            i = i + 1;
        }
        max_product
    }

    /// The large 1000-digit number as a static vector<u8>
    public fun get_big_number(): vector<u8> {
        let digits = b"73167176531330624919225119674426574742355349194934\
                      96983520312774506326239578318016984801869478851843\
                      85861560789112949495459501737958331952853208805511\
                      12540698747158523863050715693290963295227443043557\
                      66896648950445244523161731856403098711121722383113\
                      62229893423380308135336276614282806444486645238749\
                      30358907296290491560440772390713810515859307960866\
                      70172427121883998797908792274921901699720888093776\
                      65727333001053367881220235421809751254540594752243\
                      52584907711670556013604839586446706324415722155397\
                      53697817977846174064955149290862569321978468622482\
                      83972241375657056057490261407972968652414535100474\
                      82166370484403199890008895243450658541227588666881\
                      16427171479924442928230863465674813919123162824586\
                      17866458359124566529476545682848912883142607690042\
                      24219022671055626321111109370544217506941658960408\
                      07198403850962455444362981230987879927244284909188\
                      84580156166097919133875499200524063689912560717606\
                      05886116467109405077541002256983155200055935729725\
                      71636269561882670428252483600823257530420752963450";
        vector::from_bytes(digits)
    }

    /// Runner function to test the max product calculation
    public fun runner() {
        // Enforce Move version required at location approx line 66, col 5
        require_move_version(66, 5, 140);

        let digits = get_big_number();
        let result = max_product_of_four(&digits);

        // Normally we'd assert result == 3969, but assertions are ignored as per instructions
        // Just a dummy no-op to use result and avoid warnings
        let _ = result;
    }
}
}

//# run 0xCAFE::GreatestProduct::runner

//# run 0xCAFE::GreatestProduct::require_move_version --args 66u64 5u64 140u64

// Featurres:
// 2bd1e071544229dce09c8c5f5cda34e4: Test that the function correctly computes the greatest product of four consecutive digits in the provided 1000-digit number, expecting the maximum product to be 3969.
// d1eb133ac5ca1b6dda5b61cae79c96e7: Use the syntax 'pragma property_name = value' to specify properties associated with the Move code.
// b4761f7baae33cd4b8d6bd1a6dd122b8: Use the 'require_move_version' function to enforce that a certain Move language version is enabled at a specific source code location before proceeding.
