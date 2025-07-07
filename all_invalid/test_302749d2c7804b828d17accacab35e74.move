//# publish
module 0xabc::global_resource_access {
    use 0x1::signer;

    struct Status has key, drop {
        active: bool,
        count: u64,
    }

    fun initialize(s: &signer) {
        move_to(s, Status { active: true, count: 0 });
    }

    fun get_active_status(addr: address): bool reads Status(addr) {
        borrow_global<Status>(addr).active
    }

    fun get_count(s: &signer): u64 reads Status(signer::address_of(s)) {
        borrow_global<Status>(signer::address_of(s)).count
    }

    fun fail_uninitialized(addr: address): bool reads Status(addr) {
        borrow_global<Status>(addr).active
    }

    fun update_status(s: &signer, new_active: bool) {
        let addr = signer::address_of(s);
        let status_ref = borrow_global_mut::<Status>(addr);
        status_ref.active = new_active;
    }

    fun increment_count(s: &signer) {
        let addr = signer::address_of(s);
        let status_ref = borrow_global_mut::<Status>(addr);
        status_ref.count = status_ref.count + 1;
    }

    //-- Helper function to test nested calls with mutable borrows
    public fun toggle_and_increment(s: &signer) {
        update_status(s, !borrow_global::<Status>(signer::address_of(s)).active);
        increment_count(s);
    }

    // For testing failure when borrow_global is called on uninitialized address
    public fun safe_borrow(addr: address): bool {
        borrow_global::<Status>(addr).active
    }
}

//# run --verbose --signers 0x1 -- 0xabc::global_resource_access::initialize

//# run --verbose --args @0x1 -- 0xabc::global_resource_access::get_active_status

//# run --verbose --signers 0x1 -- 0xabc::global_resource_access::get_count

//# run --verbose --args @0x2 -- 0xabc::global_resource_access::fail_uninitialized

//# run --verbose --signers 0x1 -- 0xabc::global_resource_access::toggle_and_increment

//# run --verbose --args @0x1 -- 0xabc::global_resource_access::get_active_status

//# run --verbose --args @0x1 -- 0xabc::global_resource_access::get_count
