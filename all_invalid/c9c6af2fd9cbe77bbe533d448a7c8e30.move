//# publish
module 0x1::UnaryOps {
    /// Applies unary operators to a value.
    public fun apply_not(v: bool): bool {
        !v
    }

    public fun apply_neg(v: i64): i64 {
        -v
    }

    public fun apply_bnot(v: u8): u8 {
        ~v
    }

    /// Runner function for testing unary ops
    public fun run_unary_ops() {
        let _ = Self::apply_not(true);
        let _ = Self::apply_neg(-123);
        let _ = Self::apply_bnot(0b1010u8);
    }
}
//# run 0x1::UnaryOps::run_unary_ops


//# publish
module 0x1::ResourceTest {
    resource struct R { value: u64 }

    public fun create_r(account: &signer, initial: u64) {
        move_to(account, R { value: initial });
    }

    public fun read_r(r: &R): u64 {
        r.value
    }

    /// The do() function modifies R if v > 0, otherwise does nothing
    public fun do(r: &mut R, v: i64) {
        if (v > 0) {
            r.value = r.value + (v as u64);
        }
    }

    /// Runner to test do()
    public fun run_do(account: &signer) {
        let r = borrow_global_mut<R>(Signer::address_of(account));
        Self::do(&mut r, 42);
        Self::do(&mut r, -10);
    }
}
//# run 0x1::ResourceTest::create_r --signers 0x1 --args 100u64
//# run 0x1::ResourceTest::run_do --signers 0x1


//# publish
module 0x1::QualifiedChains {
    /// Returns a u8 value 7 through a 4-segment qualified module access chain
    public fun four_segment_chain(): u8 {
        0x1::Inner::Middle::InnerMost::get_seven()
    }
}

module 0x1::Inner {
    public fun get_value(): u8 { 3 }
}

module 0x1::Inner::Middle {
    public fun get_value(): u8 { 5 }
}

module 0x1::Inner::Middle::InnerMost {
    public fun get_seven(): u8 { 7 }
}
//# run 0x1::QualifiedChains::four_segment_chain()


//# publish
module 0x1::TokenMatcher {
    public fun is_token(token: u8, expected: u8): bool acquires TokenState {
        let match_ = (token == expected);
        match_
    }

    resource struct TokenState { dummy: bool }
}
//# run 0x1::TokenMatcher::is_token --args 10u8 10u8
//# run 0x1::TokenMatcher::is_token --args 10u8 20u8


//# publish
module 0x1::TypeProcessor {
    // Dummy type constructors for test
    struct MyType<T> has copy, drop {}

    public fun process_type_mn(t: MyType<u8>): bool {
        // Dummy processing
        true
    }

    public fun run_type_processor() {
        let t = MyType<u8> {};
        let _ = Self::process_type_mn(t);
    }
}
//# run 0x1::TypeProcessor::run_type_processor


//# run
script {
    use 0x1::UnaryOps;
    use 0x1::ResourceTest;
    use 0x1::QualifiedChains;
    use 0x1::TokenMatcher;
    use 0x1::TypeProcessor;

    fun main(account: &signer) {
        // test unary ops runner
        UnaryOps::run_unary_ops();

        // create resource R with initial 100
        ResourceTest::create_r(account, 100);

        // test do() fn on R
        ResourceTest::run_do(account);

        // test qualified chains
        let _val = QualifiedChains::four_segment_chain();

        // test token matcher matching and non matching
        let _ = TokenMatcher::is_token(10u8, 10u8);
        let _ = TokenMatcher::is_token(10u8, 20u8);

        // test user-defined type processor
        TypeProcessor::run_type_processor();
    }
}