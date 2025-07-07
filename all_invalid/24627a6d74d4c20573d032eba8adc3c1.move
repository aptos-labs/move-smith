
//# publish
module 0xDEAD::TestFeature1 {
    use std::signer;

    struct DataHolder has store, key {
        value: u64,
    }

    public fun initialize_holder(s: signer): () {
        let dh = DataHolder { value: 0 };
        move_to(&s, dh);
    }

    public fun update_holder(s: signer, new_value: u64): () {
        let dh_ref: &mut DataHolder = borrow_global_mut<DataHolder>(signer::address_of(&s));
        dh_ref.value = new_value;
    }

    public fun get_value(s: signer): u64 {
        let dh_ref: &DataHolder = borrow_global<DataHolder>(signer::address_of(&s));
        dh_ref.value
    }
}



//# run 0xDEAD::TestFeature1::initialize_holder --signers 0xFACE



//# run 0xDEAD::TestFeature1::update_holder --signers 0xFACE --args 12345u64



//# run 0xDEAD::TestFeature1::get_value --signers 0xFACE



//# publish
module 0xBADD::TestFeature2 {
    use std::vector;

    struct Container has store, key {
        items: vector<u8>,
    }

    public fun create_container(s: signer, items: vector<u8>): () {
        let container = Container { items };
        move_to(&s, container);
    }

    public fun add_item(s: signer, item: u8): () {
        let container_ref: &mut Container = borrow_global_mut<Container>(signer::address_of(&s));
        vector::push_back(&mut container_ref.items, item);
    }

    public fun get_items(s: signer): vector<u8> {
        let container_ref: &Container = borrow_global<Container>(signer::address_of(&s));
        vector::clone(&container_ref.items)
    }
}



//# run 0xBADD::TestFeature2::create_container --signers 0xC0FF --args vector[b"abc", b"def"]


//# run 0xBADD::TestFeature2::add_item --signers 0xC0FF --args 100u8


//# run 0xBADD::TestFeature2::get_items --signers 0xC0FF



//# publish
module 0xC0FF::TestFeature3 {
    use std::vector;

    // Define a generic enum with nested options
    enum Option<T> has copy, drop {
        None,
        Some(T),
        Nested(Box<Option<T>>),
    }
    
    // Function returning nested enum
    public fun create_nested_option<T: copy + drop>(val: T): Option<T> {
        Option::Nested(Box::new(Option::Some(val)))
    }

    // Match over nested enum
    public fun process_option<T: copy + drop>(opt: Option<T>): bool {
        match (opt) {
            Option::None => false,
            Option::Some(_) => true,
            Option::Nested(inner) => {
                match (*inner) {
                    Option::None => false,
                    Option::Some(_) => true,
                    _ => false,
                }
            }
        }
    }

    // Test inline primitive handling
    public fun test_inline(): bool {
        let nested = create_nested_option(255u8);
        process_option(nested)
    }
}



//# run 0xC0FF::TestFeature3::test_inline



//# publish
module 0xFEED::TestFeature4 {
    use std::table;

    // Use table for key-value storage
    struct KVStore has store, key {
        mapping: table::Table<u64, vector<u8>>,
    }

    public fun init_store(s: signer): () {
        let store = KVStore { mapping: table::new() };
        move_to(&s, store);
    }

    public fun insert_entry(s: signer, key: u64, value: vector<u8>): () {
        let store_ref: &mut KVStore = borrow_global_mut<KVStore>(signer::address_of(&s));
        table::add(&mut store_ref.mapping, key, value);
    }

    public fun get_entry(s: signer, key: u64): vector<u8> {
        let store_ref: &KVStore = borrow_global<KVStore>(signer::address_of(&s));
        table::lookup(&store_ref.mapping, key)
    }
}



//# run 0xFEED::TestFeature4::init_store --signers 0xFACE


//# run 0xFEED::TestFeature4::insert_entry --signers 0xFACE --args 42u64 vector[b"val"]


//# run 0xFEED::TestFeature4::get_entry --signers 0xFACE --args 42u64
