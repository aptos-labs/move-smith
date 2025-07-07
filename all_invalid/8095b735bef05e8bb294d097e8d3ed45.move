//# publish
module 0xCAFE::FriendModule {
    friend 0xCAFE::TestScript;

    struct Data has store, key {
        value: u64,
    }

    public fun create_data(value: u64): Data {
        Data { value }
    }

    public fun get_value(data: &Data): u64 {
        data.value
    }
}

//# run
script 0xCAFE::TestScript {
    use 0xCAFE::FriendModule;

    fun main() {
        // Test reassignment and shadowing of let variables
        let a = 10u64;
        let a = a + 5; // Shadowing a
        let b = a;
        let b = b * 2; // Shadowing b
        let mut_result = b;

        // Create a Data struct with the final value of b via the friend module
        let data = FriendModule::create_data(mut_result);
        let retrieved = FriendModule::get_value(&data);

        // Shadow a variable again to test all cases
        let retrieved = retrieved + 1;

        // End of script, no return needed
    }
}

// Featurres:
// 227efe2da5fb36e42127bf56ac1ae73a: Define a script with attributes and optional use declarations
// 431feb4d6c714a223a719930f11d883b: Specify the friend entity or module using a name access chain.
// f220e10aef1700da27c6cd5ef1de5599: Test that Move allows reassignment to let variables within a function and that variable shadowing and reassignment behave as expected.
