//# publish
module 0xA11D::capability_test {

    struct CapA has copy, store {
        owner: address
    }

    struct CapB has copy, store {
        owner: address
    }

    struct CapC has copy, store {
        owner: address
    }

    struct StorageHolder has key {
        cap_c: CapC
    }

    fun process_capb(c: CapB): vector<u8> {
        // Pretend to process CapB and produce some byte vector
        let CapB { owner } = c;
        // For testing, just return owner address as bytes
        let bytes: vector<u8> = vector::empty();
        vector::append(&mut bytes, address::to_bytes(&owner));
        bytes
    }

    fun init(s: &signer): (CapA, CapC) {
        // Initialize by creating CapA, CapB, CapC
        let cap_a = CapA { owner: signer::address_of(s) };
        let cap_b = CapB { owner: signer::address_of(s) };
        let cap_c = CapC { owner: signer::address_of(s) };

        // Move CapC into storage
        move_to(s, StorageHolder { cap_c: cap_c });

        // Process CapB (destroy it after processing)
        let _processed_bytes = process_capb(cap_b);
        // Explicitly destroy CapB to simulate cleanup
        // Note: in Move, no explicit destroy, just drop by not using it
        // For test, simulate destruction
        // (Assuming CapB is copied, so no special destruction needed)

        // Return CapA and CapC (the one stored)
        (cap_a, cap_c)
    }

    //# run 0x1::capability_test::init --signers 0x1

}