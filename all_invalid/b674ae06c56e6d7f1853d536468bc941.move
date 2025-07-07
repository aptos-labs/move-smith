//# publish
module 0xCAFE::TestSum {

    // A simple struct to hold initial values; must have copy, drop, store and key abilities to be stored globally
    struct InitialValues has copy, drop, store, key {
        a: u8,
        b: u8
    }

    // Public function that returns a u8 value equal to 123 (previously was from pragma)
    public fun get_pragma_value(): u8 {
        123u8
    }

    public fun sum_down_from_10(): u8 {
        let mut sum = 0u8;
        let mut i = 10u8;
        // Sum from 10 down to 1 inclusive
        while (i > 0) {
            sum = sum + i;
            i = i - 1;
        };
        sum
    }

    // Function to test match as function call with no argument
    //
    // We define a zero-argument enum and match on a constant variant
    enum ZeroArgsEnum has copy, drop, store {
        Variant
    }

    public fun match(): u64 {
        // match() called here as function with no arguments
        let v = ZeroArgsEnum::Variant;
        match (v) {
            ZeroArgsEnum::Variant => 1u64,
        }
    }

    // Runner function that combines initial values and sum_down_from_10 and adds pragma literal value
    public fun runner(): u64 {
        // call pragma getter
        let p = get_pragma_value();
        // Revised initial values for the test: a=5, b=5 to get total 65 later
        let initial = InitialValues { a: 5u8, b: 5u8 };
        // sum from 10 down to 1 = 55
        let sum = sum_down_from_10();

        // total = initial.a + initial.b + sum = 5 + 5 + 55 = 65
        let total: u64 = (initial.a + initial.b + sum) as u64;

        total
    }
}
//# run 0xCAFE::TestSum::runner

//# run
script {
    use 0xCAFE::TestSum;

    fun main() {
        let total = TestSum::runner();
        // no assertion needed, just to run and exercise compiler + VM
        // also test use of function call to match()
        let _ = TestSum::match();
    }
}