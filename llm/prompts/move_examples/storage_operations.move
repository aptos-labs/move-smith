//# publish
module 0xCAFE::StorageOperations {
    use std::signer;

    struct Obj has store, key {
        x: u8,
        y: u8,
    }

    public fun store_at_signer_address(s: signer, x: u8, y: u8) {
        let obj = Obj {x, y};
        move_to<Obj>(&s, obj);
        let a = 1;
        let b = a;
    }

    public fun inspect_value(s: signer): (u8, u8) {
        let obj_ref: &Obj = borrow_global<Obj>(signer::address_of(&s));
        (obj_ref.x, obj_ref.y)
    }

    public fun update_value(s: signer, x: u8, y:u8) {
        let obj_mut_ref: &mut Obj = borrow_global_mut<Obj>(signer::address_of(&s));
        obj_mut_ref.x = x;
        obj_mut_ref.y = y;
    }

    public fun remove_at_signer_address(s: signer) {
        let obj = move_from<Obj>(signer::address_of(&s));
        // let Obj {x: _x, y: _y} = obj;
        let Obj { .. } = obj;
    }

    public fun several_args(s1: signer, s2: signer, x: u8, y: u8): u8 {
        x + y
    }
}

//# run 0xCAFE::StorageOperations::store_at_signer_address --signers 0xBEEF --args 1u8 2u8

//# run 0xCAFE::StorageOperations::inspect_value --signers 0xBEEF

//# run 0xCAFE::StorageOperations::update_value --signers 0xBEEF --args 3u8 4u8

//# run 0xCAFE::StorageOperations::inspect_value --signers 0xBEEF

//# run 0xCAFE::StorageOperations::remove_at_signer_address --signers 0xBEEF

//# run 0xCAFE::StorageOperations::several_args --signers 0xBEEF --signers 0xAA01 --args 5u8  6u8