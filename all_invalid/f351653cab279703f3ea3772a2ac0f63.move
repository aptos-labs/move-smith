//# publish
module 0xA550C18::TestFriendModule {
    use std::signer;

    friend 0xA550C18::FriendUserModule;

    struct Data has store {
        value: u64,
    }

    public fun new_data(): Data {
        Data { value: 0 }
    }

    public fun update_data(data: &mut Data, val: u64) {
        data.value = val;
    }
}

//# publish
module 0xA550C18::FriendUserModule {
    use std::signer;

    friend 0xA550C18::TestFriendModule;

    // Access friend module struct and functions

    public fun friend_update_value(_: &signer, data: &mut 0xA550C18::TestFriendModule::Data, val: u64) {
        // Allowed to mutate Data because of friend
        0xA550C18::TestFriendModule::update_data(data, val);
    }

    public fun runner() {
        let mut d = 0xA550C18::TestFriendModule::new_data();
        friend_update_value(&signer::spec_address(), &mut d, 42);
    }
}
//# run 0xA550C18::FriendUserModule::runner

//# publish
module 0xA550C18::FieldMutateModule {
    use std::signer;

    struct FieldHolder has store {
        field: u8,
    }

    public fun new(): FieldHolder {
        FieldHolder { field: 0 }
    }

    public fun mutate_field(holder: &mut FieldHolder, val: u8) {
        // Direct field mutation
        holder.field = val;
    }

    public fun mutate_and_return(holder: &mut FieldHolder, val: u8): u8 {
        // mutate again and return
        holder.field = val;
        holder.field
    }

    #[test(address = "0xA550C18")]
    public fun test_mutate_field() {
        let mut holder = Self::new();
        Self::mutate_field(&mut holder, 123);
    }

    #[test(address = "0xA550C18")]
    public fun test_mutate_and_return() {
        let mut holder = Self::new();
        let v = Self::mutate_and_return(&mut holder, 255);
        let _ = v;
    }

    public fun runner() {
      let mut h = Self::new();
      Self::mutate_field(&mut h, 50);
      let _ = Self::mutate_and_return(&mut h, 51);
    }
}
//# run 0xA550C18::FieldMutateModule::runner

//# publish
module 0xA550C18::TestExpectedFailure {
    use std::signer;

    #[expected_failure(major_status_code(42u16, 7u8))]
    #[test(address = "0xA550C18")]
    public fun fail_with_status(_: &signer) {
        abort 42;
    }
}

//# run 0xA550C18::TestExpectedFailure::fail_with_status --signers 0xA550C18

//# run
script {
    use std::signer;

    fun main(account: signer) {
        let mut data = 0xA550C18::TestFriendModule::new_data();
        0xA550C18::TestFriendModule::update_data(&mut data, 100);

        0xA550C18::FriendUserModule::friend_update_value(&account, &mut data, 200);

        let mut holder = 0xA550C18::FieldMutateModule::new();
        0xA550C18::FieldMutateModule::mutate_field(&mut holder, 77);
        let val = 0xA550C18::FieldMutateModule::mutate_and_return(&mut holder, 88);
        let _ = val;

        // We won't catch the abort here but it'll exercise VM error handling
        // abort 42; 
    }

    main(signer::spec_address());
}