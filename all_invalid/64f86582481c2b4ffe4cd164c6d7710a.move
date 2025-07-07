//# publish
module 0xCAFE::FriendModuleA {
    friend 0xCAFE::FriendModuleB;

    struct Data has store {
        val: u8,
    }

    public fun create_data(): Data {
        Data { val: 42 }
    }

    public fun get_value(data: &Data): u8 {
        data.val
    }

    public fun set_value(data: &mut Data, new_val: u8) {
        data.val = new_val;
    }
}

//# publish
module 0xCAFE::FriendModuleB {
    friend 0xCAFE::FriendModuleA;

    use std::signer;
    use 0xCAFE::FriendModuleA;

    struct Holder has store, key {
        data: FriendModuleA::Data,
    }

    public fun store_data_to_account(s: signer) {
        let data = FriendModuleA::create_data();
        let holder = Holder { data };
        move_to<Holder>(&s, holder);
    }

    public fun read_and_update(s: signer) {
        let addr = signer::address_of(&s);
        let holder_ref = borrow_global_mut<Holder>(addr);

        // Pattern binding without explicit type
        let FriendModuleA::Data { val } = &holder_ref.data;
        let _ = val;

        // Pattern binding with explicit type
        let FriendModuleA::Data { val: v }: FriendModuleA::Data = &holder_ref.data;

        // Update value using friendship and mutability
        FriendModuleA::set_value(&mut holder_ref.data, v + 1);
    }

    // Runner function without arguments
    public fun runner() {
        // do nothing, just a placeholder for run command
    }
}

//# publish
module 0xCAFE::FileReader {
    use std::vector;
    use std::string;
    use std::address;

    // Simulate reading a Move source file by filename as a vector<u8>
    // Normally, this functionality is not directly accessible in Move,
    // so here it is mocked as returning a fixed vector to simulate reading.
    public fun read_source_file(_filename: vector<u8>): vector<u8> {
        // Return some fixed content representing a source file in bytes
        b"module 0xCAFE::TestModule { }"
    }
}

//# run 0xCAFE::FriendModuleB::store_data_to_account --signers 0xBEEF

//# run 0xCAFE::FriendModuleB::read_and_update --signers 0xBEEF

//# run 0xCAFE::FriendModuleB::read_and_update --signers 0xBEEF

//# run 0xCAFE::FriendModuleB::runner

//# run 0xCAFE::FileReader::read_source_file --args b"MoveFile.move"

// Featurres:
// 48bcef3e5728d07c977956d97a08cf47: Add 'friend' modules to declare module friendships.
// 0398755694b591d2da1013f326ff1117: Pattern-bind values to local variables in Move blocks, with or without an explicit type.
// 164ba562c4731671143e8b98bdd3d61c: Open and read a Move source file by filename.
