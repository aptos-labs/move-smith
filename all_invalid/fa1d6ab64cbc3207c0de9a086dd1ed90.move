
//# publish
module 0xDEADBEEF::AccountStructures {
    struct Info has store {
        balance: u64,
        is_active: bool,
    }

    struct Profile has store {
        owner: address,
        nickname: vector<u8>,
        info: Info,
    }

    public fun create_profile(owner: address, nickname: vector<u8>, initial_balance: u64): Profile {
        let info = Info {balance: initial_balance, is_active: true};
        let profile = Profile {owner, nickname, info};
        profile
    }

    public fun get_balance(profile: &Profile): u64 {
        profile.info.balance
    }

    public fun update_balance(mut profile: &mut Profile, new_balance: u64) {
        profile.info.balance = new_balance;
    }

    public fun deactivate_profile(mut profile: &mut Profile) {
        profile.info.is_active = false;
    }

    public fun check_active(profile: &Profile): bool {
        profile.info.is_active
    }
}



//# run 0xDEADBEEF::AccountStructures::create_profile --args 0xDEADBEEF b"User1" 1000u64



//# run 0xDEADBEEF::AccountStructures::get_balance --args 0xDEADBEEF b"User1" 1000u64



//# run 0xDEADBEEF::AccountStructures::update_balance --args 0xDEADBEEF b"User1" 1000u64 1500u64



//# run 0xDEADBEEF::AccountStructures::deactivate_profile --args 0xDEADBEEF b"User1" 1000u64



//# run 0xDEADBEEF::AccountStructures::check_active --args 0xDEADBEEF b"User1" 1000u64




//# publish
module 0x12345678::HexAddressUsage {
    struct Container has store {
        owner: address,
        value: u64,
    }

    public fun new_container(): Container {
        Container {owner: @0x12345678, value: 42}
    }

    public fun update_value(mut container: &mut Container, new_value: u64) {
        container.value = new_value;
    }

    public fun read_owner(container: &Container): address {
        container.owner
    }
}



//# run 0x12345678::HexAddressUsage::new_container



//# run 0x12345678::HexAddressUsage::update_value --args 0x12345678::HexAddressUsage::new_container() 100u64



//# run 0x12345678::HexAddressUsage::read_owner --args 0x12345678::HexAddressUsage::new_container()




//# publish
module 0xFEEDFACE::FieldManipulation {
    struct Obj has store {
        a: u8,
        b: u8,
        c: u8,
    }

    public fun create_obj(): Obj {
        Obj {a: 1u8, b: 2u8, c: 3u8}
    }

    public fun mutate_fields(mut obj: &mut Obj) {
        obj.a = obj.a + 10;
        obj.b = obj.b * 2;
        // dynamic manipulation with dotted expressions
        let current_c = obj.c;
        obj.c = current_c - 1;
    }

    public fun sum_fields(obj: &Obj): u8 {
        obj.a + obj.b + obj.c
    }
}



//# run 0xFEEDFACE::FieldManipulation::create_obj



//# run 0xFEEDFACE::FieldManipulation::mutate_fields --args 0xFEEDFACE::FieldManipulation::create_obj()



//# run 0xFEEDFACE::FieldManipulation::sum_fields --args 0xFEEDFACE::FieldManipulation::create_obj()
