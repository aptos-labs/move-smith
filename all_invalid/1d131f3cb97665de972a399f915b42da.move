// Test for: 
// 1. Phantom type parameters;
// 2. Attributes with known and unknown names;
// 3. Parentheses in match expressions.

//# publish
module 0xC0FFEE::PhantomTest {
    use std::option::{Option, some, none};
    use std::signer;

    /// Struct with phantom type parameter T
    struct Wrapper<phantom T> has store { 
        value: u64 
    }

    /// Known attribute #[test_only], unknown #[fancy]
    #[test_only]
    #[fancy]
    public fun make_and_match(account: &signer) {
        let x: Option<u64> = some(123);
        let y: u64 = match (x) {
            some(v) => v,
            none => 0,
        };

        let _phantom: Wrapper<u8> = Wrapper<u8> { value: y };
        // Just to have some state change for VM exec
        let addr = signer::address_of(account);
        emit_event<Wrapper<u8>>(addr, _phantom);
    }

    /// "Runner" function
    public entry fun run(account: &signer) {
        Self::make_and_match(account);
    }
}

//# run 0xC0FFEE::PhantomTest::run --signers 0xC0FFEE

//# run 0xC0FFEE::PhantomTest::make_and_match --signers 0xC0FFEE

//# run
script {
    fun main() {
        let opt: option::Option<u8> = option::some(42);
        // Use parentheses in match expression.
        let out = match (opt) {
            option::some(val) => val,
            option::none => 0,
        };
        // Call a known attribute function with an unknown attribute
        #[test_only]
        #[does_not_exist]
        let _ = out + 1;
    }
}