
//# publish
module 0xCAFE::SpecConditional {
    struct Data has store {
        val1: u64,
        val2: u64,
        flag: bool,
    }

    public fun new_data(v1: u64, v2: u64, f: bool): Data {
        Data { val1: v1, val2: v2, flag: f }
    }

    public fun update(data: &mut Data, new_val: u64) {
        data.val1 = new_val;
        if (data.flag) {
            data.val2 = new_val * 2;
        } else {
            data.val2 = new_val / 2;
        };
    }

    spec {
        condition primary_cond(data: Data): bool {
            data.val1 > 0
        }

        condition additional_cond(data: Data): bool {
            data.val2 == data.val1 * 2
        }

        condition with_and(data: Data): bool {
            (primary_cond(data) && additional_cond(data))
        }

        condition with_or(data: Data): bool {
            (primary_cond(data) || additional_cond(data))
        }

        public fun binop_exp_example(val: u64): u64 {
            val + 10 - 5 * 2 / 1 % 3
        }

        public fun exp_list_example(vals: vector<u64>): u64 {
            // sum all elements inside expression list styled loop
            let sum = 0;
            let i = 0;
            loop {
                if (i >= vector::length(&vals)) {
                    break;
                };
                sum = sum + *vector::borrow(&vals, i);
                i = i + 1;
            };
            sum
        }
    }
}



//# run 0xCAFE::SpecConditional::update --args 42u64


//# run 0xCAFE::SpecConditional::binop_exp_example --args 20u64



//# publish
module 0xCAFE::FieldMutate {
    struct Obj has store {
        f1: u8,
        f2: u64,
        nested: Nested,
    }

    struct Nested has store {
        x: u8,
        y: u8,
    }

    public fun init_obj(f1_val: u8, f2_val: u64, x_val: u8, y_val: u8): Obj {
        Obj {
            f1: f1_val,
            f2: f2_val,
            nested: Nested { x: x_val, y: y_val },
        }
    }

    public fun mutate_fields(obj: &mut Obj, new_f1: u8, new_x: u8) {
        // Mutate top level field
        obj.f1 = new_f1;

        // Mutate nested field via dotted expression
        obj.nested.x = new_x;
    }

    public fun run_full_test() {
        let o = Obj {
            f1: 1,
            f2: 2,
            nested: Nested { x: 3, y: 4 },
        };
        mutate_fields(&mut o, 10, 20);
        // Consume to avoid drop error
        let Obj { f1: _, f2: _, nested: Nested { x: _, y: _ } } = o;
    }
}



//# run 0xCAFE::FieldMutate::mutate_fields --args 7u8 8u8



//# run 0xCAFE::FieldMutate::run_full_test
