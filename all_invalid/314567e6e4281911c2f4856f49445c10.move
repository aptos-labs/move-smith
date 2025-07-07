
//# publish
module 0xBADD::TypeLiteralsAndUnpacking {
    use std::vector;

    // Function to test explicit type suffixes for integer literals
    public fun test_integer_literals(): u128 {
        let a = 255u8;
        let b = 65535u16;
        let c = 4294967295u32;
        let d = 18446744073709551615u64;
        let e = 340282366920938463463374607431768211455u128;
        let f = 1152921504606846976u256; // suppose u256 exists, for testing purposes
        // sum all values, promoting to u128 for example
        a as u128 + b as u128 + c as u128 + d as u128 + e
    }

    // Function to unpack a tuple into separate variables with different names
    public fun unpack_tuple_tuple3(): (u8, u16, u32) {
        let pair = (10u8, 3000u16);
        // Unpack into variables with different names
        let (unpack_u8, unpack_u16) = pair; 
        let z = 123u32;
        (unpack_u8, unpack_u16, z)
    }

    // Function to demonstrate sequence of code with scoped variables
    public fun scoped_sequence(): u8 {
        let result: u8;
        {
            let x = 5u8;
            // Intermediate computation
            let y = x + 10u8;
            result = y;
        };
        // Return result
        result
    }
}


//# run 0xBADD::TypeLiteralsAndUnpacking::test_integer_literals --args

//# run 0xBADD::TypeLiteralsAndUnpacking::unpack_tuple_tuple3 --args

//# run 0xBADD::TypeLiteralsAndUnpacking::scoped_sequence --args

// Featurres:
// 221307cdfdf0015dc7caaf85add65ff1: Write integer literals with explicit type suffixes u8, u16, u32, u64, u128, or u256 to specify their type in Move code.
// e72a272d426fefa1d35ea88d03eb3386: Use variable names to unbind variables during unpacking operations.
// 3d3f5b98f18ab88b84383a588733a309: Write sequences of code statements with proper scope handling and ensure the last statement is properly encapsulated as a sequence item.
