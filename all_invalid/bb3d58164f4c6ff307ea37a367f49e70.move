
//# publish
module 0xC0FF::UnitTypeTest {
    // Use unit type as a value in various contexts

    // Use with a struct that has copy, drop, store, key abilities
    struct TestResource has store, key {
        flag: bool,
        count: u64,
    }

    // Function to be inline, returns unit type, annotated with 'writes' to specify resource modification
    public inline fun set_resource_flag(resource_ref: &mut TestResource, flag: bool) acquires TestResource {
        resource_ref.flag = flag;
    }

    // Function to acquire and clone unit, with read access
    public fun read_standard_unit(): () {
        ()
    }

    // Function that takes a unit as a parameter and calls inline function
    public fun call_inline_with_unit(f: |()|: { }) acquires TestResource {
        f()
    }

    // Function to create a resource and modify it, uses inlined function
    public fun resource_lifecycle(s: &signer) acquires TestResource {
        let resource = move_to<TestResource>(s, TestResource {flag: false, count: 0});
        let resource_ref = borrow_global_mut<TestResource>(signer::address_of(s));
        set_resource_flag(&mut resource_ref, true);
        // read the unit value
        read_standard_unit();
        // test inline call
        call_inline_with_unit(|| {
            let res = borrow_global_mut<TestResource>(signer::address_of(s));
            res.count = res.count + 1;
        });
    }

    // Function that invokes the above to test resource access and inline functions
    public fun test_all(s: &signer) acquires TestResource {
        resource_lifecycle(s);
        ()
    }
}



//# run 0xC0FF::UnitTypeTest::test_all --signers 0xB0B0


// Features:
// 59d0366e034fa8533bb30a594ea89ad2: Use unit type as a value.
// 6fe834224fe7e9c75a09a8c028853009: Annotate Move functions with 'acquires', 'reads', or 'writes' access specifiers to declare resource or data accesses.
// 0c909f7846db87c27a23716fc9e4e66b: Use inline annotation to suggest inlining Move functions.
