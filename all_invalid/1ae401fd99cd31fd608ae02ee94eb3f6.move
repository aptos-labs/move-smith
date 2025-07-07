
//# publish
module 0xCAFE::RegularModule {
    // A regular module validating spec features and named address usage

    // Removed unused use std::vector;

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
        // Correct axiom syntax: use `axiom` without colon
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

        // Consume `data` by unpacking it to avoid drop error
        let RegularModule::Data { val } = data;

        // Reconstruct data mutable so we can use add_to_val
        let data = RegularModule::Data { val };

        // The unused variables produce warnings, so prefix with underscore
        let _initial_val = RegularModule::get_val(&data);
        RegularModule::add_to_val(&mut data, 5);
        let _updated_val = RegularModule::get_val(&data);
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

        // Consume `holder` by unpacking to avoid drop error
        let NamedAddrModule::Holder { x } = holder;

        let _x = x;
        // Test completed without assertions
    }
}
