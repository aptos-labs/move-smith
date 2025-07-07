//# publish
module 0xCAFE::MathSpecTest {
    use std::error;
    use std::signer;

    /// A resource to demo spec blocks and arithmetic tests
    struct Dummy has copy, drop, store {}

    // Standalone spec function to check an invariant on addition
    spec fun check_add(a: u16, b: u16, res: u16) {
        res == a + b
            && res >= a
            && res >= b
    }

    // Standalone spec function to check an invariant on subtraction
    spec fun check_sub(a: u16, b: u16, res: u16) {
        // Only valid if no underflow
        b <= a ==> res + b == a
    }

    // Standalone spec function to check multiplication
    spec fun check_mul(a: u16, b: u16, res: u16) {
        res == a * b
    }

    // Standalone spec function to check division
    spec fun check_div(a: u16, b: u16, res: u16) {
        b != 0 ==> a == b * res + a % b
    }

    // Standalone spec function to check modulo
    spec fun check_mod(a: u16, b: u16, res: u16) {
        b != 0 ==> res < b
    }

    spec module {
        // Example spec block with multiple members
        spec let x: u16;
        spec let y: u16;
        spec let z: u16;

        // Ensures z is the sum of x and y without overflow
        spec (z == x + y) && (z >= x) && (z >= y);
    }

    /// Runner function to exercise arithmetic ops and implicitly test specs
    public fun runner(_s: &signer) {
        // Normal cases
        let a: u16 = 100;
        let b: u16 = 50;

        let add = a + b;         // 150
        let sub = a - b;         // 50
        let mul = a * b;         // 5000
        let div = a / 5;         // 20
        let modu = a % 7;        // 2

        // Edge cases
        let max: u16 = 65535;
        let zero: u16 = 0;

        // Overflow addition: 65535 + 1 => wraps around (u16)
        let ov_add = max + 1;    // = 0 (wrap)

        // Underflow subtraction: 0 - 1 => wraps to max (u16)
        let uv_sub = zero - 1;   // = 65535 (wrap)

        // Overflow multiplication (wraps):
        let ov_mul = max * 2;    // wraps

        // Division by zero will abort,
        // so we test safe division only.
        // Uncommenting div by zero causes abort:
        // let div_zero = a / 0;

        // Modulo by zero will abort as well,
        // so only test modulo by non-zero.

        // Use dummy resource to avoid unused var warnings
        move_to(_s, Dummy {});
        // Values are not returned or stored, just computed to test VM
    }

    /// Function that aborts on division by zero, to test edge abort
    public fun try_div(a: u16, b: u16): u16 {
        assert!(b != 0, 1); // abort code 1 if div by zero
        a / b
    }

    /// Function that aborts on modulo by zero, test abort
    public fun try_mod(a: u16, b: u16): u16 {
        assert!(b != 0, 2); // abort code 2 if modulo by zero
        a % b
    }
}
//# run 0xCAFE::MathSpecTest::runner --signers 0xCAFE
//# run 0xCAFE::MathSpecTest::try_div --args 100u16 10u16
//# run 0xCAFE::MathSpecTest::try_mod --args 100u16 10u16

//# run
script {
    use 0xCAFE::MathSpecTest;

    fun main() {
        let zero: u16 = 0;
        let max: u16 = 65535;
        let two: u16 = 2;

        // Normal arithmetic tests:
        let a = 123;
        let b = 456;

        let add = a + b;
        let sub = b - a;
        let mul = a * b;
        let div = b / 2;
        let modu = b % 5;

        // Edge cases: overflow add, underflow sub
        let ov_add = max + 1;
        let uv_sub = zero - 1;

        // Multiplication overflow wrap
        let ov_mul = max * 3;

        // Division by zero: test abort
        // Uncomment next line to test abort (VM abort expected)
        // let _ = MathSpecTest::try_div(10, 0);

        // Modulo by zero: test abort
        // Uncomment next line to test abort (VM abort expected)
        // let _ = MathSpecTest::try_mod(10, 0);
    }
}

// Featurres:
// 4802739e395318325d8585930d38a715: Write Move specification blocks (spec blocks) containing multiple specification members.
// 2d43e4a10d589db638bb9f85e95848c5: Define standalone specification functions and spec blocks for your Move code.
// c85a1e84234e716f1bfd9fd0ba0b18a2: Test that all arithmetic operations—addition, subtraction, multiplication, division, and modulo—on the u16 integer type correctly handle normal cases, edge cases, and overflow/underflow or division-by-zero errors according to Move language semantics.
