//# publish
module 0xCAFE::RefSafety {
    use std::signer;

    // Add `key` ability to allow storing under address and borrowing globally.
    struct RefObj has store, key {
        val: u8,
    }

    public fun create_obj(s: signer, v: u8) {
        let obj = RefObj {val: v};
        move_to<RefObj>(&s, obj);
    }

    public fun get_ref_val(s: signer): u8 {
        let obj_ref: &RefObj = borrow_global<RefObj>(signer::address_of(&s));
        obj_ref.val
    }

    public fun mutate_val(s: signer, new_val: u8) {
        let obj_mut_ref: &mut RefObj = borrow_global_mut<RefObj>(signer::address_of(&s));
        obj_mut_ref.val = new_val;
    }

    public fun create_and_mutate(s: signer) {
        create_obj(s, 10u8);
        mutate_val(s, 42u8);
    }
}

//# run 0xCAFE::RefSafety::create_and_mutate --signers 0xBABE

//# run 0xCAFE::RefSafety::get_ref_val --signers 0xBABE

//# publish
module 0xCAFE::FirstClassFunction {
    // Mark function as `copy` compatible by adding `copy` to the function type in `call_twice`.
    public fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_twice(f: &(|u8, u8| u8), x: u8, y: u8): u8 {
        let first_call = (*f)(x, y);
        let second_call = (*f)(first_call, y);
        second_call
    }

    public fun runner(): u8 {
        let f = &add;
        call_twice(f, 3u8, 4u8)
    }
}

//# run 0xCAFE::FirstClassFunction::runner

//# run 0xCAFE::FirstClassFunction::call_twice 2u8 3u8 --signers 0xBEEF


//# run
script {
    fun main() {
        let f = &0xCAFE::FirstClassFunction::add;
        let z = (*f)(7u8, 8u8);
        let res = 0xCAFE::FirstClassFunction::call_twice(f, 1u8, z);
        let _ignored = res;
    }
}