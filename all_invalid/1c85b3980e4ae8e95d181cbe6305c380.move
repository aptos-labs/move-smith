// Note: This file contains multiple modules and scripts with transactional test directives.
// Address 0xCAFE is used as the test address.

//# publish
address 0xCAFE {
    module EntryModuleTest {
        //
        // This module tests the use of 'entry' modifier on module functions.
        //

        // A simple struct with copy, drop, store, key abilities to allow key in global storage.
        struct Data has key, store, copy, drop {
            value: u64,
        }

        // A constant with an uppercase initial letter as schema/constant name.
        const InitValue: u64 = 123;

        // Entry function which creates a Data resource with InitValue.
        entry fun create_entry_account(account: &signer) {
            let data = Data { value: InitValue };
            move_to<Data>(account, data);
        }

        // Entry function which increments the Data value in global storage.
        entry fun increment_entry(account: &signer) {
            let data_ref = borrow_global_mut<Data>(signer::address_of(account));
            data_ref.value = data_ref.value + 1;
        }

        // Regular (non-entry) public function for reading the stored value.
        public fun get_value(account: address): u64 {
            let data_ref = borrow_global<Data>(account);
            data_ref.value
        }

        // Runner function that can be called without arguments.
        // It publishes Data with InitValue and increments it twice.
        entry fun runner(account: &signer) {
            create_entry_account(account);
            increment_entry(account);
            increment_entry(account);
        }
    }
}
//# run 0xCAFE::EntryModuleTest::runner --signers 0xCAFE

//# publish
address 0xCAFE {
    module PackageOrganizerTest {
        //
        // This module tests organizing code into packages with named address mapping.
        // This module defines multiple struct constants starting with uppercase.
        //

        // Struct for holding a simple pair of values
        struct Pair has store, copy, drop {
            a: u8,
            b: u8,
        }

        // Constant for a default Pair with uppercase initial letter
        const DefaultPair: Pair = Pair { a: 5, b: 10 };

        // Entry function to publish a Pair resource
        entry fun publish_pair(account: &signer) {
            move_to<Pair>(account, DefaultPair);
        }

        // Entry function that edits the stored Pair resource by swapping its fields.
        entry fun swap_fields(account: &signer) {
            let p = borrow_global_mut<Pair>(signer::address_of(account));
            let temp = p.a;
            p.a = p.b;
            p.b = temp;
        }

        // Runner function without arguments to be called.
        entry fun runner(account: &signer) {
            publish_pair(account);
            swap_fields(account);
        }
    }
}
//# run 0xCAFE::PackageOrganizerTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::EntryModuleTest;
    use 0xCAFE::PackageOrganizerTest;

    fun main(account: &signer) {
        // Directly call the runner functions which are entry functions.
        EntryModuleTest::runner(account);
        PackageOrganizerTest::runner(account);

        // Reading values from storage - no direct assertions, just a dummy usage
        let val = EntryModuleTest::get_value(signer::address_of(account));
        // val should be 125 now: initial 123 + 2 increments

        // Pair resource is swapped once - no direct return or assertion required
        let _pair_addr = signer::address_of(account);
        // All done
    }
}
//# run --signers 0xCAFE

// Featurres:
// 1d3f5417b818a4ff0c73905c1617597a: Use the 'entry' modifier on module members to indicate entry functions.
// c17a12b242a42c345e3c4c5630cdd985: Organize Move code into packages with named address mappings.
// 33a822d31d9a501c5ed6c5bdebc0581a: Name struct constants or schemas with an initial uppercase ASCII letter
