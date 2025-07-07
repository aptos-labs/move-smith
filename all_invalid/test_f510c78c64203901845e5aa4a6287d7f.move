//# publish
module 0x66::protected {
    use 0x1::signer::address_of;

    struct AccessControl<(fun() -> bool, fun() -> bool)> has key {
        read_permission: fun() -> bool,
        write_permission: fun() -> bool,
    }

    public fun create(s: &signer, permit_read: fun() -> bool, permit_write: fun() -> bool) {
        move_to(s, AccessControl<(fun() -> bool, fun() -> bool)>>(permit_read, permit_write))
    }

    public fun check_read_permission(s: &signer): bool acquires AccessControl<(fun() -> bool, fun() -> bool)> {
        let access = borrow_global<AccessControl<(fun() -> bool, fun() -> bool+)>>(address_of(s));
        (access.read_permission)()
    }

    public fun check_write_permission(s: &signer): bool acquires AccessControl<(fun() -> bool, fun() -> bool)> {
        let access = borrow_global<AccessControl<(fun() -> bool, fun() -> bool+)>>(address_of(s));
        (access.write_permission)()
    }
}

//# publish
module 0x66::app {
    use 0x66::protected;
    use 0x1::signer;

    struct Data(u64) has store;

    fun init_module(s: &signer) {
        // Create access control with permissions
        fun allow_read() { true }
        fun deny_read() { false }
        fun allow_write() { true }
        fun deny_write() { false }

        // Assign permissions: owner gets permission to read and write
        protected::create(s, allow_read, allow_write);
        move_to(s, Data(0))
    }

    fun view(s: &signer): u64 {
        if (protected::check_read_permission(s)) {
            let data_ref = borrow_global<Data>(signer::address_of(s));
            data_ref.0
        } else {
            // Permission denied
            0
        }
    }

    fun increment(s: &signer): u64 {
        if (protected::check_write_permission(s)) {
            let data_ref = borrow_global_mut<Data>(signer::address_of(s));
            let current = data_ref.0;
            data_ref.0 = current + 1;
            current
        } else {
            // No permission to modify
            0
        }
    }
}

//# run 0x66::app::init_module --signers 0x66

//# run 0x66::app::increment --signers 0x66

//# run 0x66::app::view --signers 0x66

//# run 0x66::protected::create --signers 0x66 --args "fun() { false }"  // Attempt to revoke read permissions

//# run 0x66::app::view --signers 0x66

//# run 0x66::protected::create --signers 0x66 --args "fun() { false }"  // Attempt to revoke write permissions

//# run 0x66::app::increment --signers 0x66

//# run 0x66::app::view --signers 0x66