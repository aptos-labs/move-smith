
//# publish
module 0xCAFE::WhitespaceLogicNotNamedAddr {
    use std::signer;

    struct Flag has copy, drop, store, key {
        enabled: bool,
    }

    public fun create_flag(s: signer, enabled: bool) {
        let flag = Flag { enabled };
        move_to<Flag>(&s, flag);
    }

    public fun negate_flag(s: signer) : bool {
        let addr = signer::address_of(&s);
        let flag_ref = borrow_global<Flag>(addr);
        //!flag_ref.enabled
    }

    public fun update_flag(s: signer, enabled: bool) {
        let addr = signer::address_of(&s);
        let flag_mut_ref = borrow_global_mut<Flag>(addr);
        flag_mut_ref.enabled = enabled;
    }

    public fun runner() {
        // Create flag with true
        let addr = @0xCAFE;
        create_flag(signer::specify_signer(addr), true);

        // Negate flag --> expect false, but no asserts needed
        let _neg = negate_flag(signer::specify_signer(addr));

        // Update flag to false
        update_flag(signer::specify_signer(addr), false);

        // Negate flag --> expect true
        let _neg2 = negate_flag(signer::specify_signer(addr));
    }
}


//# run 0xCAFE::WhitespaceLogicNotNamedAddr::runner --signers 0xCAFE


// Featurres:
// a8d9906a2780c704085eed9086c6a9a1: Write code with leading whitespace characters such as spaces, tabs, and newlines, as they will be ignored by the parser.
// d803bc5e7b4f24c63c81f771f009e5ab: Apply the logical NOT operator (!) to expressions.
// 2796ec6023d6d8d52af1c333318fcb7f: Use named addresses to resolve addresses in access specifications, provided the address is explicitly mapped in the project's aliasing configuration.
