//# publish
module 0xabcde::nested_structs {
    struct Inner {
        m: u64,
        n: u64,
    }

    struct Outer has copy, drop {
        a: u64,
        b: Inner,
        c: u64,
    }

    public fun create_outer(): Outer {
        let inner = Inner { m: 10, n: 20 };
        Outer { a: 5, b: inner, c: 15 }
    }

    public fun destructure_and_sum(o: Outer): u64 {
        let Outer { a, b: Inner { m, n }, c } = o;
        a + m + n + c
    }

    public fun run_test(): u64 {
        let outer = create_outer();
        destructure_and_sum(outer)
    }
}

 //# run 0xabcde::nested_structs::run_test

//# publish
module 0x12345::struct_mutation {
    struct Data has copy, drop {
        x: u64,
        y: u64,
    }

    public fun create_data(): Data {
        Data { x: 42, y: 100 }
    }

    public fun modify_x(data: &mut Data): u64 {
        *data.x = *data.x + 58;
        *data.x
    }

    public fun run(): u64 {
        let mut d = create_data();
        let new_x = modify_x(&mut d);
        d.y // return y to verify it is unaffected
    }
}

 //# run 0x12345::struct_mutation::run

//# publish
module 0x67890::struct_destruct {
    struct Entity has copy, drop {
        hp: u64,
        dmg: u64,
        def: u64,
    }

    public fun create_entity(): Entity {
        Entity { hp: 50, dmg: 15, def: 10 }
    }

    public fun get_total_stats(e: Entity): u64 {
        let Entity { hp, dmg, def } = e;
        hp + dmg + def
    }

    public fun run(): u64 {
        let e = create_entity();
        get_total_stats(e)
    }
}

 //# run 0x67890::struct_destruct::run