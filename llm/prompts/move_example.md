Below are some examples of Move modules showing language features. You should NEVER directly use these module/functions.

```move
//# publish
module 0xCAFE::MyModule {
    // You NEVER try to use this 0xCAFE::MyModule
    // It is only an example
    use std::vector;

    const MODULE_MAGIC: u32 = 0xCADE;

    struct S has copy, drop, store, key {
        x: u32,
        y: u32, // Fields name cannot start with a number
    }

    struct StructWithTypeParameter<T> has copy, drop {
        field: T
    }

    enum E has copy, drop {
        V1,
        V2(u32, u32),
        V3 {
            a: bool
        }
    }

    public fun f1(x: u8, y: bool): u8 {
        // parentheses are required for if condition expressions
        if (y) {
            let _a = 1;
        } else {
            let _b = 2;
        };
        // All `if (...) {...}` or `if (...) {...} else {...}` MUST end with a semicolon if it's a statement.

        // parentheses are required for while condition expressions
        while( x < 10) {
            x = x + 1;
        };
        // `while` loops must end with a semicolon

        let z = x + 1;
        // last expression in a function is the return value
        z
    }

    // An inline function that returns a tuple
    public inline fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    public fun f3(x: u16): S {
        let (a, b) = f2(x);
        let s = S {x: a as u32, y: b as u32};

        // Instantiate generic struct with type parameter
        let s2 = StructWithTypeParameter<E> {field: E::V2(1, 2)};
        let s3 = StructWithTypeParameter<u16> {field: 3u16};
        s
    }

    public fun f4() {
        let e = E::V2(1, 2);
        let x = match (e) {
            E::V1 => 1,
            E::V2(x, y) => x+y,
            E::V3 { a } => if (a) {2} else {3},
        };

        // If assertion fails, abort with code 888
        assert!(x < 100, 888);
    }

    public fun f5() {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        let (c, d) = lambda(3u8, 4u8);

        // Copy a value that has the `copy` ability
        let another_lambda = copy lambda;
        let (_, _) = another_lambda(5u8, 6u8);
    }

    public fun f6(x: |u8|u8, y: u8): u8 {
        x(y)
    }

    public fun f7() {
        let byte_string: vector<u8> = b"Hello\nWorld";
        let hex_string: vector<u8> = x"deadbeef";
    }

    public fun f8(): u32 {
        let x: u32 = 1u32;
        for (i in 0..5) {
            x += i;
        };
        while (x > 5) {
            x -= 1;
        };
        loop {
            if (x == 0) {
                break;
            };
            x -= 1;
        };
        x
    }

    fun example_vector_usage() {
        (vector[]: vector<bool>);
        (vector[0u8, 1u8, 2u8]: vector<u8>);
        (vector<u128>[]: vector<u128>);
        (vector<address>[@0x42, @0x100]: vector<address>);

        let v = vector::empty<u64>();
        vector::push_back(&mut v, 5);
        vector::push_back(&mut v, 6);

        assert!(*vector::borrow(&v, 0) == 5, 42);
        assert!(*vector::borrow(&v, 1) == 6, 42);
        assert!(vector::pop_back(&mut v) == 6, 42);
        assert!(vector::pop_back(&mut v) == 5, 42);
    }
}

//# run 0xCAFE::MyModule::f1 --args 3u8 true

//# run 0xCAFE::MyModule::f3 --args 10u16

//# publish
module 0xCAFE::StorageUsage {
    // You NEVER try to use this 0xCAFE::StorageUsage
    // It is only an example

    use std::signer;
    use 0xCAFE::MyModule;

    struct Obj has store, key {
        x: u8,
        y: u8,
    }

    public fun store_at_signer_address(s: signer, x: u8, y: u8) {
        let obj = Obj {x, y};
        move_to<Obj>(&s, obj);
        let a = 1;
        let b = a;
    }

    public fun inspect_value(s: signer): (u8, u8) {
        let obj_ref: &Obj = borrow_global<Obj>(signer::address_of(&s));
        (obj_ref.x, obj_ref.y)
    }

    public fun update_value(s: signer, x: u8, y:u8) {
        let obj_mut_ref: &mut Obj = borrow_global_mut<Obj>(signer::address_of(&s));
        obj_mut_ref.x = x;
        obj_mut_ref.y = y;
    }

    public fun remove_at_signer_address(s: signer) {
        let obj = move_from<Obj>(signer::address_of(&s));
        // let Obj {x: _x, y: _y} = obj;
        let Obj { .. } = obj;
    }

    public fun cross_module_call() {
        let _ = 0xCAFE::MyModule::f1(1u8, true);
        let _ = MyModule::f3(10u16);
    }

    public fun several_args(s1: signer, s2: signer, x: u8, y: u8): u8 {
        x + y
    }
}

//# run 0xCAFE::StorageUsage::store_at_signer_address --signers 0xBEEF --args 1u8 2u8

//# run 0xCAFE::StorageUsage::inspect_value --signers 0xBEEF

//# run 0xCAFE::StorageUsage::update_value --signers 0xBEEF --args 3u8 4u8

//# run 0xCAFE::StorageUsage::inspect_value --signers 0xBEEF

//# run 0xCAFE::StorageUsage::remove_at_signer_address --signers 0xBEEF

//# run 0xCAFE::StorageUsage::cross_module_call

//# run 0xCAFE::StorageUsage::several_args --signers 0xBEEF --signers 0xAA01 --args 5u8  6u8
```
