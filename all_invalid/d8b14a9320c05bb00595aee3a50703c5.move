//# publish
module 0xCAFE::RangeUtil {
    use std::vector;

    struct Location has copy, drop, store {
        start: u64,
        end_: u64,
    }

    struct ByteRange has copy, drop, store {
        start_byte: u64,
        end_byte: u64,
    }

    /// Converts a Location range to a ByteRange range assuming 1 location step = 2 bytes.
    /// This is an arbitrary example for testing numeric conversions and returns a new ByteRange.
    public fun convert_location_to_byte_range(loc: Location): ByteRange {
        // Multiply by 2 as example conversion
        let start_byte = loc.start * 2;
        let end_byte = loc.end_ * 2;
        ByteRange { start_byte, end_byte }
    }

    /// Runner function to test convert_location_to_byte_range without arguments.
    public fun runner() {
        let loc = Location { start: 10, end_: 15 };
        let _byte_range = Self::convert_location_to_byte_range(loc);
        // No assertions required
    }
}
//# run 0xCAFE::RangeUtil::runner

//# publish
module 0xCAFE::DefaultAddressTest {
    // This module is under default address 0xCAFE on purpose.
    struct Dummy has copy, drop, store {
        val: u64,
    }

    public fun new_dummy(): Dummy {
        Dummy { val: 42 }
    }

    public fun runner() {
        let d = Self::new_dummy();
        let _v = d.val;
    }
}
//# run 0xCAFE::DefaultAddressTest::runner

//# run
script {
    use 0xCAFE::RangeUtil;
    use 0xCAFE::DefaultAddressTest;

    fun main() {
        // Create a location and convert to byte range using the module function directly
        let loc = RangeUtil::Location { start: 5, end_: 8 };
        let br = RangeUtil::convert_location_to_byte_range(loc);

        // Also call DefaultAddressTest runner's dummy usage indirectly by creating a dummy
        let dummy = DefaultAddressTest::new_dummy();
    }
}

// Featurres:
// 88b39f65af0c16f5a55e26ae3f405a74: Convert a location's range to a range of byte positions within a source file.
// 2f1176a50aedba7210a09e1b87c0dc65: Define a module with a specific address or default address.
// 8f16851ba3aa50838a304a7eca3c785e: Add a script to the collection of scripts to be executed or published.
