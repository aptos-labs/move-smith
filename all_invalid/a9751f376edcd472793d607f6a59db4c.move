// Testing Move features in a transactional test

//--------------------
//# publish
module 0x1::FileUtils {
    use std::vector;

    /// Checks if the first 4 bytes of the bytes vector match the Move module magic
    public fun has_move_magic(bytes: &vector<u8>): bool acquires Global {
        // Move module magic: [0xA1, 0x1C, 0xEB, 0x0B]
        bytes.len() >= 4 &&
            *vector::borrow(bytes, 0) == 0xA1 &&
            *vector::borrow(bytes, 1) == 0x1C &&
            *vector::borrow(bytes, 2) == 0xEB &&
            *vector::borrow(bytes, 3) == 0x0B
    }

    public fun runner() {
        let correct = vector[0xA1u8, 0x1Cu8, 0xEBu8, 0x0Bu8, 0xFFu8];
        let incorrect = vector[0xAAu8, 0xBBu8, 0xCCu8, 0xDDu8];
        let valid = Self::has_move_magic(&correct);
        let invalid = Self::has_move_magic(&incorrect);
        // Just to consume them
        if (valid && !invalid) {
            // no-op
        }
    }
}

//# run 0x1::FileUtils::runner

//--------------------
//# publish
module 0x2::Nested {
    public struct Inner {
        public field: u64,
    }

    public struct Outer {
        public inner: Self::Inner,
    }

    public fun access_chain(): u64 {
        let inn = Inner { field: 42 };
        let out = Outer { inner: inn };
        // Access using dot notation chain
        out.inner.field
    }

    public fun runner() {
        let _v = Self::access_chain();
    }
}

//# run 0x2::Nested::runner

//--------------------
//# publish
module 0x3::PublicAccess {
    // Testing public field
    public const TEST_CONST: u8 = 7;

    public fun get_const(): u8 {
        Self::TEST_CONST
    }

    public fun runner() {
        let _c = Self::get_const();
    }
}

//# run 0x3::PublicAccess::runner

//--------------------
//# publish
module 0x4::SpecTest {
    use std::vector;

    /// Sample function to test spec language
    public fun process(x: u8, y: u8): u8 {
        assert!(x < 250, 100);
        assume!(y > 1);
        if (x * y > 200) {
            abort 99;
        }
        x + y
    }

    public fun runner() {
        let _ = Self::process(10, 20);
    }

    spec process {
        pragma: "specification test";
        assume x > 0;
        assert y < 255;
        decreases y;
        aborts_if x * y > 200;
        succeeds_if x < 250 && y > 1;
        modifies SpecTest;
        emits SpecTest::process;
        ensures result == x + y;
        requires x <= 250;
    }
}

//# run 0x4::SpecTest::runner

//--------------------
//# run
script {
    // Simple script to run and test compilation and VM
    let x = 1u8;
    let y = 2u8;
    let z = x + y;
}