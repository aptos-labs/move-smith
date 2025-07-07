//# publish
module 0x42::map_opt {
    use std::option;
    /// Maps the content of an option
    public inline fun map<Element, OtherElement>(t: option::Option<Element>, f: |Element|OtherElement): option::Option<OtherElement> {
        if (option::is_some(&t)) {
            option::some(f(option::extract(&mut t)))
        } else {
            option::none()
        }
    }
}

//# publish
module 0x42::test_map_opt {
    use std::option;
    use 0x42::map_opt;

    // Create a test where the option is None, expect None after mapping
    public fun test_none(): option::Option<u64> {
        let t = option::none<u64>();
        map_opt::map(t, |e: u64| e + 10)
    }

    // Create a test where the option is Some, map should add 5
    public fun test_some(): option::Option<u64> {
        let t = option::some(7);
        let mapped = map_opt::map(t, |e: u64| e + 5);
        option::extract(&mut mapped)
    }

    // Create a nested option test: mapping an Option<Option<u64>>, inner None
    public fun test_nested_none(): option::Option<option::Option<u64>> {
        let inner_none = option::none::<u64>();
        let outer_some = option::some(inner_none);
        // Map only outer level
        map_opt::map(outer_some, |inner| {
            // Map inner Option to add 1 if Some
            if (option::is_some(&inner)) {
                option::some(option::extract(&mut inner) + 1)
            } else {
                option::none()
            }
        })
    }

    // Nested Option::Some
    public fun test_nested_some(): option::Option<option::Option<u64>> {
        let inner = option::some(42);
        let outer = option::some(inner);
        // Map outer, then inner
        let res = map_opt::map(outer, |inner_opt| {
            if (option::is_some(&inner_opt)) {
                option::some(option::extract(&mut inner_opt) + 100)
            } else {
                option::none()
            }
        });
        // Extract the final value
        match &res {
            option::Some(inner_res) => option::extract(&mut *inner_res),
            option::None => 0,
        }
    }
}

//# run 0x42::test_map_opt::test_none
//# run 0x42::test_map_opt::test_some
//# run 0x42::test_map_opt::test_nested_none
//# run 0x42::test_map_opt::test_nested_some


//# publish
module 0x42::m {
    fun test_borrowing_conflict(): bool {
        let x = 10;
        let y = 20;
        let r1 = &mut x;
        // Attempt to create a second mutable reference
        let r2 = &mut y;
        // Use the references
        *r1 + *r2 > 20
    }
}

//# run 0x42::m::test_borrowing_conflict


//# publish
module 0x42::pattern_matching {
    enum Status {
        Success { code: u64, message: vector<u8> },
        Failure { reason: vector<u8> }
    }

    struct Response<T> {
        status: Status,
        data: T
    }

    // Pattern match nested structures with ref
    public fun handle_response<T>(resp: &Response<T>): u64 {
        match (&resp.status) {
            Status::Success { code, message: _ } => *code,
            Status::Failure { reason: _ } => 0,
        }
    }

    // Pattern match with conditional
    public fun is_successful(resp: Response<u64>): bool {
        match (resp.status) {
            Status::Success { code, .. } if *code > 100 => true,
            _ => false,
        }
    }

    // Pattern matching with nested enums and generics
    enum OuterEnum {
        VariantA,
        VariantB { inner: Status }
    }

    public fun process_outer(e: OuterEnum): u64 {
        match (e) {
            OuterEnum::VariantA => 1,
            OuterEnum::VariantB { inner } => handle_response(&Response { status: inner, data: 0 }),
        }
    }
}

//# run 0x42::pattern_matching::handle_response --signers 0x1 --args 200u64 // expecting 200
//# run 0x42::pattern_matching::is_successful --signers 0x1 --args Response { status: Status::Success { code: 150, message: b"ok" }, data: 0 }