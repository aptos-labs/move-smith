// # publish
module 0xCAFE::ModuleA {
    struct Data has store {
        x: u64,
        nested: Nested,
    }

    struct Nested has store {
        y: u8,
    }

    public fun new_data(): Data {
        Data {
            x: 1,
            nested: Nested { y: 2 }
        }
    }

    public fun modify_x(data: &mut Data, new_x: u64) {
        data.x = new_x;
    }

    public fun modify_nested_y(data: &mut Data, new_y: u8) {
        data.nested.y = new_y;
    }

    public fun aliasing_test(data: &mut Data) {
        let r1 = &mut data.x;
        // This should alias with r1 and change x again through it.
        let r2 = &mut data.x;
        *r2 = *r1 + 10;
    }

    public fun conditional_borrow(data: &mut Data, cond: bool) {
        let v: &mut u64;
        if (cond) {
            v = &mut data.x;
        } else {
            v = &mut 100u64; // local mutable reference to a temporary value
        }
        *v = *v + 1;
    }

    public fun runner() {
        let mut d = Self::new_data();
        Self::modify_x(&mut d, 10);
        Self::modify_nested_y(&mut d, 20);
        Self::aliasing_test(&mut d);
        Self::conditional_borrow(&mut d, true);
        Self::conditional_borrow(&mut d, false);
    }
}
// # run 0xCAFE::ModuleA::runner --signers 0xCAFE


// # publish
module 0xBEEF::ModuleB {
    struct Container has store {
        value: u64,
    }

    public fun create_container(val: u64): Container {
        Container { value: val }
    }

    public fun update_value(c: &mut Container, new_val: u64) {
        c.value = new_val;
    }

    public fun multiple_borrows(c: &mut Container) {
        let r1 = &mut c.value;
        // Immutable borrow after mutable borrow not allowed - so use nested scopes
        *r1 = *r1 + 1;
        {
            let r2 = &mut c.value;
            *r2 = *r1 + 2;
        }
    }

    public fun runner() {
        let mut c = Self::create_container(5);
        Self::update_value(&mut c, 100);
        Self::multiple_borrows(&mut c);
    }
}
// # run 0xBEEF::ModuleB::runner --signers 0xBEEF


// # publish
spec 0xDEAD::SpecModule {
    // Spec module can declare specifications only - no executable code.
    // This is to test 'spec' keyword parsing at address context.

    spec struct S {
        field: int,
    }

    spec fun invariant(s: &S) {
        // dummy spec function
    }
}


// # run
script {
    use 0xCAFE::ModuleA;
    use 0xBEEF::ModuleB;

    fun main() {
        // Directly call functions in ModuleA
        let mut da = ModuleA::new_data();
        ModuleA::modify_x(&mut da, 42);
        ModuleA::modify_nested_y(&mut da, 99);
        ModuleA::aliasing_test(&mut da);
        ModuleA::conditional_borrow(&mut da, false);

        // Call functions in ModuleB
        let mut cb = ModuleB::create_container(25);
        ModuleB::update_value(&mut cb, 50);
        ModuleB::multiple_borrows(&mut cb);
    }
}
// # run

// Featurres:
// b8fdec9e97e0f35e97b9b27ebb0a622d: Handle modules both at the package level and under specific address contexts.
// 136168fd43b03e5103901de66b029b08: Define modules using the 'module' or 'spec' keywords in Move files.
// c9b61f628663ae2b3a48fe15030889ab: Test that mutable references to data structures and values behave correctly across various scenarios, including borrowing, aliasing, updating nested fields, and conditional references.
