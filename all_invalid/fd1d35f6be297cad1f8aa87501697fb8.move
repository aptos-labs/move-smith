//# run
script {
    use 0x1::Debug;
    use 0x1::Signer;
    use 0xBEEF::Item;

    fun main(account: &signer, threshold: u64) {
        if (exists<Item>(Signer::address_of(account))) {
            let item_ref = borrow_global<Item>(Signer::address_of(account));
            assert!(item_ref.value > threshold, 1001);
        } else {
            Debug::print(&"Item does not exist at this address");
            assert!(false, 1002);
        }
    }
}
