//# publish
module 0xabc::resource_test {
    fun increment_field(val: &mut u64): u64 {
        *val = *val + 2;
        *val
    }

    struct SharedResource has drop {
        count: u64,
        total: u64,
        sum: u64,
    }

    public fun create_resource(): SharedResource {
        let initial_count = 10;
        let total_value = inc_total(&mut initial_count);
        let sum_fields = inc_total(&mut total_value);
        SharedResource { count: initial_count, total: total_value, sum: sum_fields }
    }

    fun inc_total(val: &mut u64): u64 {
        *val = *val + 5;
        *val
    }

    public fun deconstruct_resource(s: SharedResource): u64 {
        let SharedResource { count, total, sum } = s;
        // Integrate fields to produce a final result
        count + total + sum
    }
}

//# run 0xabc::resource_test::create_resource
//# run 0xabc::resource_test::deconstruct_resource --signers 0x1 --args 0xabc::resource_test::SharedResource