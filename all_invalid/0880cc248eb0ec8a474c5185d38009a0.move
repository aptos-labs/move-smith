//# publish
module 0x1::TestResource {
    use std::signer;

    struct R has key {
        value: u64,
    }

    public fun create_resource(s: &signer, v: u64) {
        let r = R { value: v };
        move_to(s, r);
    }

    public fun read_resource(addr: address): u64 acquires R {
        let r = borrow_global<R>(addr);
        r.value
    }

    public fun do(addr: address, v: u64) acquires R {
        let r = borrow_global_mut<R>(addr);
        if (v % 2 == 0) {
            // Even v doubles the resource value
            r.value = r.value * 2;
        } else {
            // Odd v increments the resource value
            r.value = r.value + 1;
        }
    }

    // runner function without args
    public fun run_do(addr: address) acquires R {
        // call do with some fixed value to see change
        do(addr, 3);
    }
}
//# run 0x1::TestResource::run_do --signers 0x1

//# publish
module 0x2::LintSkipper {
    #[skip(lint1, lint2, lint3)]
    public fun ignored_lints() {
        // function body irrelevant, only to test skip attribute
        let x = 1 + 1;
        let _ = x;
    }
}
//# run 0x2::LintSkipper::ignored_lints

//# publish
module 0x3::StringEscapeUtils {

    public fun find_closing_quote(data: &vector<u8>, start_index: u64): u64 {
        let len = Vector::length(data);
        let mut i = start_index;
        while (i < len) {
            let byte = *Vector::borrow(data, i);
            if (byte == 0x22) { // ASCII "
                // Check for escape sequences \"
                if (i > 0) {
                    let prev_byte = *Vector::borrow(data, i - 1);
                    if (prev_byte != 0x5C) { // ASCII \
                        return i;
                    }
                    else {
                        // escaped quote, keep scanning
                    }
                } else {
                    return i;
                }
            }
            i = i + 1;
        }
        // if not found, return length
        len
    }

    public fun test_find_quote(): u64 {
        // Example string: hello \"world\"
        // bytes: h e l l o SPACE \ " w o r l d \ "
        // indexes: 0 1 2 3 4 5 6 7 ...
        let example = b"hello \\\"world\\\"";
        // find first quote after index 0 (should find the quote at index 7)
        find_closing_quote(&example, 0)
    }
}
//# run 0x3::StringEscapeUtils::test_find_quote

//# publish
module 0x4::InvariantTest {
    #[invariant]
    spec R {
        value: u64,
    }

    #[invariant(update)]
    spec module {
        fun always_positive(val: u64): bool {
            val > 0
        }
    }

    #[invariant(property = "critical_property")]
    public fun check_invariant(x: u64): bool {
        x != 0 // dummy invariant condition for demo
    }
}
//# run 0x4::InvariantTest::check_invariant --args 10u64

//# run
script {
    use 0x1::TestResource;
    use std::signer;

    fun main(s: signer) {
        // Create resource R with value 10
        TestResource::create_resource(&s, 10);

        // Do operation with v = 2 (even, should double to 20)
        TestResource::do(signer::address_of(&s), 2);

        // Do operation with v = 3 (odd, should increment 20->21)
        TestResource::do(signer::address_of(&s), 3);

        // Read resource value to confirm modification (no assertion needed as per instructions)
        let _val = TestResource::read_resource(signer::address_of(&s));
    }
}