//# publish
module 0x1::Dependency {
    use std::vector;

    #[skip(unknown_check, missing_docs)]
    resource struct R { value: u64 }

    public fun create_r(v: u64): R {
        R { value: v }
    }

    public fun get_value(r: &R): u64 {
        r.value
    }

    public fun set_value(r: &mut R, v: u64) {
        r.value = v;
    }

    /// A runner function to test creating and modifying R
    public fun do(): R {
        let mut r = create_r(42);
        set_value(&mut r, 84);
        r
    }
}

//# run 0x1::Dependency::do

//# publish
module 0x1::FriendMod {
    use 0x1::Dependency;

    friend 0x1::Dependency;

    #[skip(lint1, lint2)]
    resource struct FriendR { inner: Dependency::R }

    public fun new_friend_r(v: u64): FriendR {
        let r = Dependency::create_r(v);
        FriendR { inner: r }
    }

    public fun update_inner(friend_r: &mut FriendR, v: u64) {
        // Use friend access to Dependency::R resource internals
        Dependency::set_value(&mut friend_r.inner, v);
    }

    public fun get_inner_value(friend_r: &FriendR): u64 {
        Dependency::get_value(&friend_r.inner)
    }

    public fun do(): u64 {
        let mut fr = new_friend_r(7);
        update_inner(&mut fr, 21);
        get_inner_value(&fr)
    }
}
//# run 0x1::FriendMod::do

//# publish
module 0x1::VectorBorrow {
    use std::vector;

    #[skip(no_mut_borrow)]
    struct FunReturnHasFunParam;

    // Function parameter whose return type contains a function - test 6
    public fun returns_fun(x: u8): (u8, fun(u8): u8) {
        let f = fun (y: u8): u8 {
            x + y
        };
        (x, f)
    }

    // Test vector operations and borrows
    #[skip(some_lint)]
    public fun do(): u64 {
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);

        let first = *vector::borrow(&v, 0);
        let second_mut_ref = vector::borrow_mut(&mut v, 1);
        *second_mut_ref = 20;

        let sum = first + *vector::borrow(&v, 1) + *vector::borrow(&v, 2);
        sum
    }
}
//# run 0x1::VectorBorrow::do

//# run
script {
    use 0x1::Dependency;
    use 0x1::FriendMod;
    use 0x1::VectorBorrow;

    fun main() {
        // Create R and modify
        let r = Dependency::do();
        // Friend module test
        let friend_val = FriendMod::do();
        // Vector and borrow test
        let vec_sum = VectorBorrow::do();

        // Call function returning function
        let (x, f) = VectorBorrow::returns_fun(100u8);
        let fun_result = f(23);

        // No assertions needed per instructions - just run these
        let _ = r;
        let _ = friend_val;
        let _ = vec_sum;
        let _ = fun_result;
    }
}