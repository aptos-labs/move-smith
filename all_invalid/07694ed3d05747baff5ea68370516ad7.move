//# publish
module 0xCAFE::Standalone {
    // A module with no dependencies, tests dependency analysis of Move compiler

    // A copyable, droppable struct for testing
    struct Data has copy, drop, store {
        value: u64,
    }

    // simple function with mutable variables, no explicit type annotation
    public fun inc(x: u64): u64 {
        let y = x + 1;
        y
    }

    // function with mutable variable WITH explicit type annotation
    public fun add_and_multiply(a: u32, b: u32): u64 {
        let result: u64 = (a + b) as u64 * 2;
        result
    }

    // A runner function to be called with test runner
    public fun runner() {
        let x = 5;
        let y: u64 = Self::inc(x);
        let z: u64 = Self::add_and_multiply(10, 20);
        // Create a copyable struct and copy it
        let d = Data { value: z };
        let d2 = d;
        let v = d2.value;
        // Use address() in a statement, to reference this module's address using named access
        let mod_addr = Self::address();
        // Mutable reassignment with explicit type
        let a: u8 = 1;
        let b = a + 1;
        let c: u8 = b + 2;
        let c = c + 1;
        // All variables are consumed or copy types, nothing remains
    }
}

//# run 0xCAFE::Standalone::runner

//# publish
module 0xCAFE::TestAddress {
    // Use named address reference `Self::address()`, and declare mutable variables

    public fun runner() {
        // Use named address reference to get this module's address
        let my_addr = Self::address();

        // Another variable declared with explicit type
        let mut_addr: address = Self::address();

        // Reassign mutable variable
        let x = 1u8;
        let x = x + 1;

        // Another mutable variable, no type
        let y = 2;
        let y = y + 3;
        let _z = x + y;

        // Use address variable again
        let _addr_again = mut_addr;
    }
}
//# run 0xCAFE::TestAddress::runner

//# run
script {
    fun main() {
        // Declare mutable variable without and with type, then update

        let a = 3;
        let b: u64 = 4;
        let a = a + 1;
        let b = b + 2;
        let _sum: u64 = (a as u64) + b;

        // Reference named address for this script's context. Since scripts have no module context, we use a direct literal address
        let literal_addr = @0xCAFE;

        // Use in a dummy fashion
        let _literal_addr_2 = literal_addr;
    }
}

// Featurres:
// 4e804c793431fa44b1953c8ed9ecb514: Ensure modules without dependencies are included in dependency analyses by defining them without dependent modules
// c7794908d750127a6fd9f2005ef753ea: Use named addresses by referencing the 'address' function with the provided context and leading name access.
// 6ca462047b1b8af1819da8263369f405: Declare mutable variables with or without explicit type annotations
