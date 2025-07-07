// This transactional test covers:
// 1. Friend modules to declare friendship
// 2. Struct variants named with uppercase identifiers
// 3. Running compiler and VM to surface any compile/runtime errors

// Using address 0xCAFE for publishing and running.

//# publish
module 0xCAFE::FriendModuleA {
    friend 0xCAFE::FriendModuleB; // Declaring friend module

    /// Struct with uppercase variant names
    struct DataVariant has store {
        A: u64,
        B: bool,
    }

    // public function to return an A variant value
    public fun create_a(): DataVariant {
        DataVariant { A: 42, B: false }
    }

    // runner function to test publishing
    public fun runner() {
        // No-op function to be called from run command
        let _v = Self::create_a();
    }
}

//# publish
module 0xCAFE::FriendModuleB {
    // Declare friendship with FriendModuleA to access its internals if needed
    friend 0xCAFE::FriendModuleA;

    struct Wrapper has store {
        data: 0xCAFE::FriendModuleA::DataVariant,
    }

    public fun create_wrapper(): Wrapper {
        let data = 0xCAFE::FriendModuleA::create_a();
        Wrapper { data }
    }

    public fun runner() {
        let _w = Self::create_wrapper();
    }
}

//# run 0xCAFE::FriendModuleA::runner
//# run 0xCAFE::FriendModuleB::runner

//# run
script {
    use 0xCAFE::FriendModuleA;
    use 0xCAFE::FriendModuleB;

    fun main() {
        // Create data variant instance from FriendModuleA
        let data = FriendModuleA::create_a();
        // Use friend module's function to create a wrapper
        let wrapper = FriendModuleB::create_wrapper();

        // Just binding variables to simulate usage
        let _a_val = data.A;
        let _b_val = data.B;

        let _inner_a_val = wrapper.data.A;
    }
}

// Featurres:
// 48bcef3e5728d07c977956d97a08cf47: Add 'friend' modules to declare module friendships.
// 63949fbb5139c8cf84ce3283660c1dd3: Name struct variants with identifiers starting with an uppercase letter ('A'..'Z').
// dba6ccc33a58baa3a452a37cd0f7d3c0: Run the Move compiler and output errors to the standard error stream.
