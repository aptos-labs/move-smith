
//# publish
module 0xCAFE::WhitespaceLogicNotNamedAddr {
    use std::signer;
    use std::move_to;
    use std::borrow_global;
    use std::borrow_global_mut;

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
        !flag_ref.enabled
    }

    public fun update_flag(s: signer, enabled: bool) {
        let addr = signer::address_of(&s);
        let flag_mut_ref = borrow_global_mut<Flag>(addr);
        flag_mut_ref.enabled = enabled;
    }

    public fun runner(s: signer) {
        // Create flag with true
        create_flag(s, true);

        // Negate flag --> expect false, but no asserts needed
        let _neg = negate_flag(s);

        // Update flag to false
        update_flag(s, false);

        // Negate flag --> expect true
        let _neg2 = negate_flag(s);
    }
}



//# run 0xCAFE::WhitespaceLogicNotNamedAddr::runner --signers 0xCAFE
