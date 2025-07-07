
//# publish
module 0xCAFE::Adder {
    /// Public function to add two u8 values and return the sum plus one
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Private function that returns a lambda adding two u8 values
    fun get_adder_lambda(): |u8, u8| u8 {
        |x: u8, y: u8| { x + y }
    }

    /// Public function that uses the private lambda internally
    public fun sum_using_lambda(a: u8, b: u8): u8 {
        let lambda = get_adder_lambda();
        lambda(a, b)
    }

    /// Friend function, callable by friend modules, that returns sum of two u8 + 10
    friend fun friend_add(a: u8, b: u8): u8 {
        (a + b) + 10
    }

    /// Inline function for nested calls demonstration, returns sum + 5
    public inline fun inline_add_and_offset(a: u8, b: u8): u8 {
        add_and_increment(a, b) + 4 // add_and_increment returns sum + 1, total +5
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    /// Public function that calls Adder::inline_add_and_offset
    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::inline_add_and_offset(a, b)
    }
}



//# publish
module 0xCAFE::AccessControl {
    use std::signer;
    use 0xCAFE::Adder;

    struct MyResource has key, store {
        val: u8,
    }

    /// Public function that creates MyResource under sender's account
    public fun acquire_resource(s: signer, val: u8) {
        let r = MyResource { val };
        move_to<MyResource>(&s, r);
    }

    /// Public function specifying it reads the resource
    public fun read_resource(addr: address): u8 acquires MyResource {
        let r = borrow_global<MyResource>(addr);
        r.val
    }

    /// Public function specifying it writes to the resource
    public fun write_resource(addr: address, new_val: u8) acquires MyResource {
        let r = borrow_global_mut<MyResource>(addr);
        r.val = new_val;
    }

    /// Private function to demonstrate private visibility, returns 42
    fun private_fn(): u8 {
        42
    }

    /// Friend function to test friend visibility, calls Adder's friend_add to add 20 to input
    friend fun friend_fn(x: u8): u8 {
        Adder::friend_add(x, 20u8)
    }

    /// Public function to test calling private and friend functions inside the module
    public fun call_visibility_functions(x: u8): (u8, u8) {
        let priv_val = private_fn();
        let friend_val = friend_fn(x);
        (priv_val, friend_val)
    }
}



//# run 0xCAFE::Adder::add_and_increment --args 10u8 20u8



//# run 0xCAFE::Adder::sum_using_lambda --args 7u8 8u8



//# run 0xCAFE::Caller::call_inline_add --args 3u8 6u8



//# run 0xCAFE::AccessControl::acquire_resource --signers 0xBEEF --args 11u8



//# run 0xCAFE::AccessControl::read_resource --args 0xBEEF



//# run 0xCAFE::AccessControl::write_resource --args 0xBEEF 33u8



//# run 0xCAFE::AccessControl::read_resource --args 0xBEEF



//# run 0xCAFE::AccessControl::call_visibility_functions --args 9u8
