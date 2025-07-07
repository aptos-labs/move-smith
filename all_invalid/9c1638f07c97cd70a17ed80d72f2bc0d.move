//# publish
module 0x1::TestModule {
    use std::debug;

    // 1. Function to compute sum of three local variables and assert correctness
    public fun main() {
        let a = 10;
        let b = 20;
        let c = 30;
        let sum = a + b + c;
        assert!(sum == 60, 100); // 100 is an arbitrary error code
    }

    // 2. Reference types: immutable and mutable references
    public fun ref_demo() {
        let mut x = 42;
        let r1 = &x; // immutable reference
        let r2 = &mut x; // mutable reference
        // Use references to demonstrate mutability
        *r2 = *r1 + 1;
        debug::print(&*r2);
    }

    // 3. Function with different visibility modifiers
    // Public function that calls private and friend functions
    public fun public_func() {
        private_func();
        friend_func();
    }

    // Private function
    fun private_func() {
        debug::print(&"private_func called");
    }

    // Friend function (assuming from same module, as Move doesn't have 'friend' yet)
    friend fun friend_func() {
        debug::print(&"friend_func called");
    }

    // 4. Function to perform bytecode optimization passes in a configurable pipeline
    // This is conceptual, since runtime bytecode optimization is handled outside Move code.
    // But we can simulate a pipeline operation.
    public fun optimize_pipeline(passes: vector<u8>) {
        // Mock: iterate through passes and "apply" them
        let len = vector::length(&passes);
        let mut i = 0;
        while (i < len) {
            let pass_id = *vector::borrow(&passes, i);
            // Simulate applying an optimization pass
            debug::print(&vector::stringify(&pass_id));
            i = i + 1;
        }
    }

    // 5. Function to handle lexical analysis and tokenization
    // Since Move source code parsing happens outside VM, we simulate by accepting source as string
    public fun parse_source(source: vector<u8>) {
        // Mock parser: count number of tokens (simulate by counting spaces)
        let mut count = 0;
        let len = vector::length(&source);
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(&source, i) == 0x20 /* space */) {
                count = count + 1;
            }
            i = i + 1;
        }
        debug::print(&vector::stringify(&count));
    }
}

//# run 0x1::TestModule::main --signers 0x0 --args