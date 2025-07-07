
//# publish
module 0xCAFE::MultiReturn {
    use std::signer;

    // Return a tuple of two u64 values
    public fun get_two_values(): (u64, u64) {
        (42u64, 84u64)
    }

    // Return a tuple with different types
    public fun get_mixed_values(): (u8, bool, u64) {
        (7u8, true, 1000u64)
    }

    // Takes signer and returns two values to test passing parameters
    public fun from_signer(s: signer): (address, u64) {
        let addr = signer::address_of(&s);
        (addr, 1u64)
    }

    // Runner function to test tuple returns and destructuring
    public fun runner() {
        let (a, b) = get_two_values();
        let (x, y, z) = get_mixed_values();
        let _ = (a, b, x, y, z);

        let dummy_signer = signer::address_of(&signer::borrow_address());
        // dummy variable to silence unused var errors
        let _ = dummy_signer;
    }
}


//# run 0xCAFE::MultiReturn::runner



//# publish
module 0xCAFE::ScriptedModule {
    use std::signer;

    struct Data has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun create(s: signer, a: u8, b: u8): Data {
        Data { a, b }
    }

    public fun modify(data: Data, new_a: u8): Data {
        // Copy/Move inference tested here with parameter and return
        Data { a: new_a, b: data.b }
    }

    public fun drop_data(_data: Data) {
        // Implicit drop of _data on exit
    }

    // Runner function to test code using copy, move, drop inference
    public fun runner(s: signer) {
        let d0 = create(s, 10u8, 20u8);
        let d1 = modify(d0, 99u8);
        drop_data(d1);
    }
}


//# run 0xCAFE::ScriptedModule::runner --signers 0xBEEF


// Script inline test : define a script calling MultiReturn's get_two_values and ScriptedModule's create and modify

//# run
script {
    use 0xCAFE::MultiReturn;
    use 0xCAFE::ScriptedModule;
    use std::signer;

    fun main(s: signer) {
        let (val1, val2) = MultiReturn::get_two_values();
        let data = ScriptedModule::create(s, val1 as u8, val2 as u8);
        let _modified = ScriptedModule::modify(data, 50u8);
    }
}


// Featurres:
// 1300979e3b9b7c757af6fe6978a1cea6: Declare functions that return multiple values as a tuple
// 6994dad09f324b160b16e661e17ce3e7: Define and use scripts in your Move modules.
// c5e2e41c253447c9e6b7bd67b17111b2: Infer assignment kinds (copy or move) and handle drops for code generation.
