
//# publish
module 0xCAFE::DefaultAddressModule {
    // Removed unused 'use std::signer;'

    /// Generic struct with resource drop ability, to test drop and safe access.
    struct GenericRes<T> has drop, store {
        value: T,
        counter: u64,
    }

    /// Create a new GenericRes instance with a counter initialized.
    public fun create<T>(v: T): GenericRes<T> {
        GenericRes { value: v, counter: 0 }
    }

    /// Read the value field by reference.
    public fun read_value<T>(g: &GenericRes<T>): &T {
        &g.value
    }

    /// Modify the counter field by mutable reference.
    public fun increment_counter<T>(g: &mut GenericRes<T>) {
        g.counter = g.counter + 1;
    }

    /// Read the counter field.
    public fun read_counter<T>(g: &GenericRes<T>): u64 {
        g.counter
    }

    /// Drop the resource explicitly by passing and letting it go out of scope.
    public fun drop_resource<T>(g: GenericRes<T>) {
        // just consume resource, drop runs automatically
    }

    /// Helper to get value and counter as tuple for convenience.
    public fun get_tuple<T>(g: &GenericRes<T>): (&T, u64) {
        (&g.value, g.counter)
    }

    /// Exercise field access and reference projections.
    public fun test_projections() {
        let g = create(7u8);
        increment_counter(&mut g);
        let val_ref = read_value(&g);
        let ctr = read_counter(&g);

        // Note: val_ref is &u8, calling read_value expects &GenericRes<T>
        // So, this line is invalid and removed to fix the compilation error:
        // let val_ref2 = read_value(val_ref);

        // call drop explicitly
        drop_resource(g);
    }

    /// Test resource drop semantics via generic struct in nested scopes.
    public fun test_drop_semantics<T>(v: T) {
        let g = create(v);
        let val_ref = read_value(&g);
        let _x = *val_ref;
        // g is dropped at end of function safely.
    }

    /// A runner function, no args.
    public fun runner() {
        test_projections();
        test_drop_semantics(42u64);
        test_drop_semantics(true);
    }
}



//# run 0xCAFE::DefaultAddressModule::runner




//# publish
module 0xCAFE::LambdaLiftTest {
    // Removed unused 'use std::vector;'

    /// Test lambdas lifted without inline keyword.
    public fun test_lambda_lift_no_inline(x: u8): u8 {
        let lambda = |a: u8| {
            let inner_lambda = |b: u8| b + 1;
            inner_lambda(a) + x
        };
        lambda(5)
    }

    /// Test lambdas lifted with inline keyword.
    public inline fun test_lambda_lift_inline(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| {
            let inner_lambda: |u8| u8 has copy + drop = |b: u8| b + 1;
            (inner_lambda(a)) + x
        };
        lambda(5)
    }

    /// Test borrowing in lambda with generic parameters.
    public fun test_lambda_with_generic_ref<T: copy>(v: &T): T {
        let lambda = |x: &T| *x;
        lambda(v)
    }

    /// Runner function - no args.
    public fun runner() {
        let _no_inline_res = test_lambda_lift_no_inline(3);
        let _inline_res = test_lambda_lift_inline(3);
        let x = 10u64;
        let _generic_ref_res = test_lambda_with_generic_ref(&x);
    }
}



//# run 0xCAFE::LambdaLiftTest::runner




//# publish
module 0xDEADBEEF::FallbackAddressModule {
    /// Generic struct with simple value field.
    struct Container<T> has store, copy, drop {
        field: T,
    }

    /// Create a Container.
    public fun new_container<T: copy>(v: T): Container<T> {
        Container { field: v }
    }

    /// Access field with references and updates.
    public fun update_field<T: copy>(c: &mut Container<T>, new_val: T) {
        c.field = new_val;
    }

    /// Return value of field.
    public fun get_field<T: copy>(c: &Container<T>): T {
        c.field
    }

    /// Test a lambda that captures generic and modifies.
    public fun test_lambda_generic<T: copy>(val: T): T {
        let c = new_container(val);
        // To fix "captured variable `c` cannot be modified inside of a lambda", declare as mutable.
        let updater = |new_val: T| {
            update_field(&mut c, new_val);
        };
        updater(val);
        get_field(&c)
    }

    /// Runner no args.
    public fun runner() {
        let c = new_container(100u64);
        update_field(&mut c, 200u64);
        let _val = get_field(&c);

        let _lambda_res = test_lambda_generic(42u8);
    }
}



//# run 0xDEADBEEF::FallbackAddressModule::runner




//# publish
module 0xDEADBEEF::IntegratedTest {
    use 0xDEADBEEF::FallbackAddressModule;

    struct GStruct<T> has store, drop {
        inner: FallbackAddressModule::Container<T>,
        flag: bool,
    }

    public fun new_gstruct<T: copy>(v: T): GStruct<T> {
        GStruct {
            inner: FallbackAddressModule::new_container(v),
            flag: true,
        }
    }

    public fun update_inner_field<T: copy>(gs: &mut GStruct<T>, val: T) {
        FallbackAddressModule::update_field(&mut gs.inner, val);
    }

    public fun read_inner_field<T: copy>(gs: &GStruct<T>): T {
        FallbackAddressModule::get_field(&gs.inner)
    }

    /// Signal flip function (toggle)
    public fun flip_flag<T>(gs: &mut GStruct<T>) {
        gs.flag = !gs.flag;
    }

    /// Test a lifted lambda that modifies generic struct fields.
    public fun test_lifted_lambda<T: copy>(val: T): T {
        let gs = new_gstruct(val);
        let modify = |new_val: T| {
            update_inner_field(&mut gs, new_val);
            flip_flag(&mut gs);
        };
        modify(val);
        read_inner_field(&gs)
    }

    public fun runner() {
        let gs = new_gstruct(500u16);
        update_inner_field(&mut gs, 600u16);
        let _val1 = read_inner_field(&gs);
        flip_flag(&mut gs);

        let _val2 = test_lifted_lambda(123u8);
    }
}



//# run 0xDEADBEEF::IntegratedTest::runner
