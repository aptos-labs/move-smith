//# publish
module 0xabc::infinite_loop_test {

    // This module contains a script to test gas exhaustion by executing an infinite loop.

}

//# run --gas-budget 700 --signers 0x1
script {
    fun main(_s: signer) {
        // This will run out of gas due to the infinite loop
        loop {}
    }
}

//# publish
module 0xabc::resource_borrow {

    struct DataResource has key {
        value: u64
    }

    public fun store_resource(account: &signer, val: u64) {
        move_to<DataResource>(account, DataResource { value: val });
    }

    public fun get_resource_value() acquires DataResource {
        borrow_global<DataResource>(@0xabc)
    }
}

//# run --signers 0xabc
script {
    use 0xabc::resource_borrow;
    fun main(account: signer) {
        // Store resource in account 0xabc
        resource_borrow::store_resource(&account, 42);
        // Borrow the resource and verify its value
        let res_ref = resource_borrow::get_resource_value();
        assert!(res_ref.value == 42, 0);
    }
}