
//# publish
module 0xCAFE::AbilityConstraints {
    use std::vector;

    // Generic struct with ability constraints on T
    struct Container<T: copy + drop + store> has store {
        items: vector<T>
    }

    // Function to create a new container of u8 items
    public fun new_u8_container(): Container<u8> {
        let v = vector::empty<u8>();
        Container<u8> { items: v }
    }

    // Add an item to the container
    public fun add_item<T: copy + drop + store>(container: &mut Container<T>, item: T) {
        vector::push_back(&mut container.items, item);
    }

    // Get length of items inside container
    public fun length<T: copy + drop + store>(container: &Container<T>): u64 {
        vector::length(&container.items)
    }

    // Inline function that returns the sum of two u64 numbers
    public inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Inline function with generic u8 vector creation
    public inline fun inline_make_vector(): vector<u8> {
        vector[1u8, 2u8, 3u8]
    }

    // Runner function for tests
    public fun runner() {
        // To fix "local `c` of type Container<u8> does not have the drop ability"
        // consume it properly by destructuring before end of scope or using it fully.

        // change 'let c' to mutable and consume after usage:
        let c = new_u8_container();
        add_item(&mut c, 10u8);
        add_item(&mut c, 20u8);

        // safely use c by referencing it
        let len = length(&c);
        let sum = inline_add(100u64, 200u64);
        let v = inline_make_vector();

        // Consume or destructure values without drop (no action needed here since u64 and vector<u8> have drop)
        let _len = len;
        let _sum = sum;
        let _v = v;

        // To avoid drop issue with `c`, consume c explicitly by destructuring:
        // Since Container<u8> does not have drop, unpack it with let Container { items } = c;
        let Container { items: _ } = c;
    }
}




//# run 0xCAFE::AbilityConstraints::runner





//# publish
module 0xCAFE::ScriptBlockTest {
    use std::signer;

    // Fix: Add `key` ability for move_to and borrow_global
    struct Data has key, store, copy, drop {
        val: u8
    }

    public fun save_value(account: signer, v: u8) {
        let data = Data { val: v };
        move_to<Data>(&account, data);
    }

    public fun read_value(addr: address): u8 {
        let data_ref = borrow_global<Data>(addr);
        data_ref.val
    }

    public fun runner(account: signer) {
        // signer is not Copy, so pass it by reference to avoid move
        save_value(&account, 42u8);
        let v = read_value(signer::address_of(&account));
        let _v = v;
    }
}




//# run 0xCAFE::ScriptBlockTest::runner --signers 0xBEEFFEED


// Below is a script using the script keyword that will run as transaction script:


//# run
script {
    use std::signer;

    fun main(account: signer) {
        // Instantiate a container with ability constraints from AbilityConstraints module
        let container = 0xCAFE::AbilityConstraints::new_u8_container();
        0xCAFE::AbilityConstraints::add_item(&mut container, 123u8);
        let len = 0xCAFE::AbilityConstraints::length(&container);

        // Call inline function
        let res = 0xCAFE::AbilityConstraints::inline_add(5u64, 7u64);

        // Use ScriptBlockTest module calls
        0xCAFE::ScriptBlockTest::save_value(&account, 77u8);
        let val = 0xCAFE::ScriptBlockTest::read_value(signer::address_of(&account));

        // Fix: destructure tuple values to avoid tuple type error
        let _len = len;
        let _res = res;
        let _val = val;

        // Consume container explicitly to avoid drop errors by unpacking
        let 0xCAFE::AbilityConstraints::Container { items: _ } = container;
    }
}
