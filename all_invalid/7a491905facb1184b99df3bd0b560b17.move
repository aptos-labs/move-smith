//# publish
module 0xCAFE::TestModule {
    use std::signer;

    struct Container has store {
        value: u64,
        flag: bool,
    }

    struct Holder has store {
        container: Container,
        id: u8,
    }

    public fun create_holder(s: signer, id: u8, value: u64, flag: bool) {
        let c = Container { value, flag };
        let h = Holder { container: c, id };
        move_to<Holder>(&s, h);
    }

    public fun mutate_fields(s: signer) {
        let addr = signer::address_of(&s);
        let holder_ref = borrow_global_mut<Holder>(addr);

        // Mutate dotted expression fields directly
        holder_ref.container.value = holder_ref.container.value + 10;
        holder_ref.container.flag = !holder_ref.container.flag;
        holder_ref.id = holder_ref.id + 1;
    }

    public fun read_fields(s: signer): (u64, bool, u8) {
        let addr = signer::address_of(&s);
        let holder_ref = borrow_global<Holder>(addr);
        (holder_ref.container.value, holder_ref.container.flag, holder_ref.id)
    }

    public fun run_all(s: signer) {
        create_holder(s, 42u8, 100u64, true);
        mutate_fields(s);
        let (_v, _f, _id) = read_fields(s);
        // no output needed
    }
}

//# run 0xCAFE::TestModule::run_all --signers 0xBEEF

//# run 0xCAFE::TestModule::create_holder --signers 0xBEEF --args 1u8 123u64 false

//# run 0xCAFE::TestModule::mutate_fields --signers 0xBEEF

//# run 0xCAFE::TestModule::read_fields --signers 0xBEEF

//# run 0xCAFE::TestModule::create_holder --signers 0xDEAD --args 9u8 456u64 true

//# run 0xCAFE::TestModule::mutate_fields --signers 0xDEAD

//# run 0xCAFE::TestModule::read_fields --signers 0xDEAD

// Featurres:
// b67838f01f1672912a7cabc235296ed0: Include `struct` definitions in the module output.
// 2e88e719c2a4a03015f635a5bd3e72e9: Mutate fields of dotted expressions directly.
// dfcd98ac9f2f7d5b2a6467540fe5b143: Write code that can reference both numerical (anonymous) and named addresses in address positions
