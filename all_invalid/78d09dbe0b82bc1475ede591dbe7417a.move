
//# publish
module 0xCAFE::RegularModule {
    // A regular module validating spec features and named address usage

    use std::vector;

    const VALUE_A: u64 = 10;

    struct Data has store {
        val: u64,
    }

    public fun create_data(): Data {
        Data { val: VALUE_A }
    }

    public fun get_val(d: &Data): u64 {
        d.val
    }

    public fun add_to_val(d: &mut Data, add: u64) {
        d.val = d.val + add;
    }
}


//# publish
module 0xCAFE::SpecModule {
    use 0xCAFE::RegularModule;

    // Spec block with axiom
    spec module {
        // The axiom that VALUE_A is always 10
        axiom VALUE_A_is_10: RegularModule::VALUE_A == 10;
    }

    // Spec for the create_data function
    spec create_data {
        ensures result.val == 10;
    }

    // Spec for add_to_val function increasing val by add parameter
    spec add_to_val {
        requires old(d).val + add >= old(d).val; // monotonicity
        ensures d.val == old(d).val + add;
    }
}


//# run
script {
    use 0xCAFE::RegularModule;

    fun main() {
        let data = RegularModule::create_data();
        let initial_val = RegularModule::get_val(&data);
        RegularModule::add_to_val(&mut data, 5);
        let updated_val = RegularModule::get_val(&data);
        // no assertion needed, just exercising the code with no error
    }
}


//# publish
module 0xDEED::NamedAddrModule {
    // Use a named address 0xDEED different from 0xCAFE and 0xBEEF

    struct Holder has store {
        x: u8,
    }

    public fun create_holder(): Holder {
        Holder { x: 42 }
    }

    public fun get_x(holder: &Holder): u8 {
        holder.x
    }
}


//# run
script {
    use 0xDEED::NamedAddrModule;

    fun main() {
        let holder = NamedAddrModule::create_holder();
        let x = NamedAddrModule::get_x(&holder);
        // Test completed without assertions
    }
}


// Featurres:
// aea66ddfaf245421240744cbb5227162: Separate spec modules from regular modules in your Move package
// 49b4b441ae2849b6cc3fddf30f4eaf8c: Add axioms to your specification by using the 'axiom' keyword in a spec block.
// 6e9d16bbd4bf6eaf49ba58d25e353bb3: Specify named addresses in code and have them resolved through the named address mapping
