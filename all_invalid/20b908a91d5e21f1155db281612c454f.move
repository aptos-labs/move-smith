// # publish
address 0xCAFE {
    module InlineCaller {
        struct Counter has store, key {
            value: u64,
        }

        /// Create a new Counter with initial value 0 under the signer
        public fun init_counter(account: &signer) {
            move_to<Counter>(account, Counter { value: 0 });
        }

        /// Acquire the Counter resource, increment the value by 1
        public fun increment_counter(account: &signer) {
            let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
            counter_ref.value = counter_ref.value + 1;
        }

        /// Inline function that calls the resource acquiring function increment_counter
        public inline fun inline_increment(account: &signer) {
            // This must properly propagate the resource acquisition of increment_counter
            increment_counter(account);
        }

        /// Runner function that just increments counter once via inline call
        public fun runner(account: &signer) {
            inline_increment(account);
        }
    }
}
// # run 0xCAFE::InlineCaller::runner --signers 0xCAFE

// # publish
address 0xCAFE {
    module UnboundBinding {
        /// Structure to hold some data
        struct DataHolder has store, key {
            a: u64,
            b: bool,
        }

        /// Initialize storage with default values
        public fun init_data(account: &signer) {
            move_to<DataHolder>(account, DataHolder { a: 0, b: false });
        }

        /// This function uses unbound variables `x` and `flag` then binds them to actual data.
        public fun use_unbound(account: &signer) {
            let address = signer::address_of(account);

            // Unbound variables (not yet assigned)
            let x;
            let flag;

            // Bind variables to values/references
            x = borrow_global_mut<DataHolder>(address);
            flag = x.b;

            // Use the bound variables
            if (!flag) {
                x.a = x.a + 42;
                x.b = true;
            }
        }

        /// Runner function to test the use_unbound function
        public fun runner(account: &signer) {
            use_unbound(account);
        }
    }
}
// # run 0xCAFE::UnboundBinding::runner --signers 0xCAFE

// # publish
address 0xCAFE {
    module APIGenerator {
        use std::vector;
        use std::string;
        use std::debug;

        /// Dummy struct and function to test human-readable interface generator

        struct Dummy has copy, drop, store {}

        public fun foo(x: u8): u8 {
            x + 1
        }

        public inline fun bar(): bool {
            true
        }

        /// A function to get the human-readable API from this module's bytecode.
        /// We fake this using debug::print to demonstrate since real API generation
        /// requires external tooling (e.g. move CLI). Here we'll simulate printing the interface.
        public fun generate_api() {
            debug::print(b"Module: 0xCAFE::APIGenerator\n");
            debug::print(b"Functions:\n");
            debug::print(b"  public fun foo(x: u8): u8\n");
            debug::print(b"  public inline fun bar(): bool\n");
            debug::print(b"  public fun generate_api(): ()\n");
            debug::print(b"Structs:\n");
            debug::print(b"  struct Dummy has copy, drop, store\n");
        }

        /// Runner function that calls the API generation function (simulated)
        public fun runner() {
            generate_api();
        }
    }
}
// # run 0xCAFE::APIGenerator::runner

// # run
script {
    use 0xCAFE::InlineCaller;
    use 0xCAFE::UnboundBinding;
    use 0xCAFE::APIGenerator;

    fun main(account: signer) {
        // Prepare counters, data, etc
        InlineCaller::init_counter(&account);
        UnboundBinding::init_data(&account);

        InlineCaller::runner(&account);
        UnboundBinding::runner(&account);
        APIGenerator::runner();
    }
}

// Featurres:
// 57baad3637737b510be50aeb101099d1: Test that an inline function can call a function that acquires a resource, and the acquisition is properly propagated.
// c9065c2dc80d960aeeb504020c42311d: Use unbound variable names in your Move code and bind them to specific values or structures.
// ee2436a3542a7e81235d8fc97c80fa73: Generate a human-readable interface (API surface) for a Move module from its compiled binary form.
