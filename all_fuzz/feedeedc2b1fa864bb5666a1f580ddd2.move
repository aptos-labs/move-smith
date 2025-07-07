
//# publish
module 0xCAFE::AdditionModule {
    // Test addition and return fixed u8 number
    public fun add_and_return(x: u8, y: u8): u8 {
        let _sum = x + y;  // renamed to _sum to avoid unused warning
        let fixed_value = 42u8;
        fixed_value
    }

    public fun get_sum(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::AdditionModule::add_and_return --args 10u8 32u8



//# run 0xCAFE::AdditionModule::get_sum --args 5u8 7u8



//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }

    public fun call_lambda_on_result(x: u8, y: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |z: u8| z * 2;
        let (sum, _) = run_lambda_example(x, y);
        lambda(sum)
    }
}



//# run 0xCAFE::LambdaModule::run_lambda_example --args 3u8 4u8



//# run 0xCAFE::LambdaModule::call_lambda_on_result --args 3u8 4u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_sum(a: u8, b: u8): u8 {
        AdditionModule::get_sum(a, b)
    }

    public fun nested_addition(x: u8, y: u8): u8 {
        let z = inline_sum(x, y);
        AdditionModule::add_and_return(z, 5u8)
    }
}



//# run 0xCAFE::NestedCallModule::nested_addition --args 10u8 20u8



//# publish
module 0xCAFE::NamedAddressAccess {
    use 0xCAFE::AdditionModule;

    public fun call_addition(x: u8, y: u8): u8 {
        AdditionModule::add_and_return(x, y)
    }
}



//# run 0xCAFE::NamedAddressAccess::call_addition --args 1u8 2u8



//# publish
module 0xCAFE::StructVariantModule {
    struct Person has copy, drop, store {
        name: vector<u8>,
        age: u8,
    }

    enum Event has copy, drop, store {
        Birth {
            who: Person,
            location: vector<u8>,
        },
        Marriage {
            partner1: Person,
            partner2: Person,
            date: u64,
        },
        Death {
            who: Person,
            date: u64,
            cause: vector<u8>,
        }
    }

    public fun create_birth_event(name: vector<u8>, age: u8, location: vector<u8>): Event {
        let p = Person {name, age};
        Event::Birth {
            who: p,
            location
        }
    }

    public fun create_marriage_event(name1: vector<u8>, age1: u8, name2: vector<u8>, age2: u8, date: u64): Event {
        let p1 = Person {name: name1, age: age1};
        let p2 = Person {name: name2, age: age2};
        Event::Marriage {
            partner1: p1,
            partner2: p2,
            date,
        }
    }
}



//# run 0xCAFE::StructVariantModule::create_birth_event --args b"Alice" 0x14 b"City"



//# run 0xCAFE::StructVariantModule::create_marriage_event --args b"Bob" 30 b"Carol" 28 1654041600u64



//# publish
module 0xCAFE::MutableLoopModule {
    public fun update_and_loop(x_ref: &mut u8): u8 {
        *x_ref = 3u8;

        let bound = *x_ref;
        let sum = 0u8;
        let i = 0u8;
        while (i < bound) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }
}



//# run 0xCAFE::MutableLoopModule::update_and_loop --args 0u8
