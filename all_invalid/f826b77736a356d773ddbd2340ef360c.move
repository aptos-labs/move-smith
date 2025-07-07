//# publish
module 0xCAFE::TestModule {
    use std::signer;

    /// Constants in module
    const CONST_U8: u8 = 42;
    const CONST_U64: u64 = 0xCAFEu64;

    /// A struct with Store and Key abilities so it can be stored globally
    struct DataHolder has store, key {
        value: u64,
        flag: bool,
    }

    /// A simple non-native function to be called externally and linted
    public fun get_const_u8(): u8 {
        CONST_U8
    }

    /// Another non-native function returning both members in a tuple
    public fun get_data(holder: &DataHolder): (u64, bool) {
        (holder.value, holder.flag)
    }

    /// Function to create and publish a DataHolder resource
    public fun publish_data(account: &signer, val: u64, flg: bool) {
        let dh = DataHolder {
            value: val,
            flag: flg,
        };
        move_to(account, dh);
    }

    /// Function callable without argument to publish with fixed values
    public fun runner(account: &signer) {
        publish_data(account, CONST_U64, true);
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE

//# run
script 0xCAFE::TestScript {
    use 0xCAFE::TestModule;
    use std::signer;
    use std::vector;

    fun main(account: signer) {
        // Call get_const_u8 function and ignore the return value (just test run)
        let val = TestModule::get_const_u8();
        // Publish a DataHolder resource with custom values
        TestModule::publish_data(&account, 123u64, false);

        // Borrow the resource and call get_data
        let holder_ref = borrow_global<TestModule::DataHolder>(signer::address_of(&account));
        let (v, f) = TestModule::get_data(holder_ref);

        // Use some operations just to verify compiler & VM on constants and calls
        let sum = (v + val as u64);
        let prod = sum * 2u64;

        // Make a vector from a byte string to test vector<u8> literal
        let _vec = b"TestString";

        // Avoid warnings about unused variables by an if branch
        if f {
            // do nothing
        } else if prod > 100u64 {
            // do nothing
        }
    }
}

// Featurres:
// 2bb8788985e13a0a6c230da263b8553b: Write non-native functions in modules to be subject to external Move lint checking according to the configured checkers.
// cef92f7a645ac4c90856fea8bcbe1cdb: Define constants as members of a module
// 5e6eb221de9c0a2b2fa62cc8c865c0ab: Use the 'Store' ability to enable values to be stored in global storage.
