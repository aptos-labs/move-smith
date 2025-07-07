
//# publish
module 0xCAFE::OperatorTest {
    use std::signer;

    // Use all given operators in Move code, testing their syntactic validity
    public fun operator_usage_example(): u64 {
        let a: u64 = 10u64;
        let b: u64 = 2u64;

        // Compound assignment operators
        a += 5;   // +=
        b *= 3;   // *=
        a -= 1;   // -=
        b /= 2;   // /=
        a %= 6;   // %=
        b ^= 1;   // ^=

        // Comparison operators (==, !=, >=, <=)
        if (a == b) {
            a = a + 1;
        } else if (a != b) {
            a = a - 1;
        };

        if (a >= b) {
            b = b + 1;
        };

        if (b <= a) {
            a = a + 2;
        };

        // Shift operators (<<=, >>=, <<, >>)
        a <<= 1;
        b >>= 1;
        let c = a << 2;
        let d = b >> 1;

        // Logical operators: => Only used in specs, so using '=>' is valid in events/comments/notes but not in code.
        // '==>' and '<==>' also only in spec. We include comment lines to test parsing but no code can contain them:

        // Commenting them to test parsing in transaction tests:
        // assert!(a == b, "== operator works");
        // // Testing `==>`
        // // Testing `=>`
        // // Testing `<==>`
        // // Testing `::`
        // // Testing `#` (comments)
        // // Testing `@` (address literal)

        // Address and module operator ::
        let addr: address = @0xCAFE;
        let module_name = 0xCAFE::OperatorTest;

        // Range operator '..'
        let sum: u64 = 0;
        for i in 1..5 {
            sum += i;
        };

        // Dot operator '.' for field access
        let s = SampleStruct { f: 42u8 };
        let field_val = s.f;

        sum + field_val as u64 + c + d + a + b
    }

    // Struct to test '.' operator
    struct SampleStruct has copy, drop {
        f: u8
    }

    // Test variable declared with explicit types mutated properly
    public fun mutate_variables() {
        let x: u8 = 0u8;
        let y: u16 = 100u16;
        let z: u64 = 1000u64;

        // Incrementing variables using +=
        x += 10;
        y += 200;
        z += 3000;

        // Decrement variables using -=
        x -= 5;
        y -= 100;
        z -= 1000;

        // Multiply and divide
        x *= 2;
        y /= 2;
        z /= 3;

        // Modulo
        let _ = x % 7;
        let _ = y % 50;

        // Shift left/right
        x <<= 1;
        y >>= 1;
    }

    // Public function with friend visibility
    public(friend) fun friend_func(): u8 {
        7
    }

    // Private function
    fun private_func(): u8 {
        42
    }

    // Public function that calls friend and private
    public fun call_visibility_funcs(): (u8, u8) {
        let friend_val = friend_func();
        let priv_val = private_func();
        (friend_val, priv_val)
    }
}


//# run 0xCAFE::OperatorTest::operator_usage_example


//# run 0xCAFE::OperatorTest::mutate_variables


//# run 0xCAFE::OperatorTest::call_visibility_funcs


// Featurres:
// 3d648fea915f2390d347b5bf73e7a34b: Use various operators such as '==>', '=>', '==', '!=', '<==>', '<<=', '<=', '<<', '>>=', '>=', '>>', '::', '%=', '%', '*=', '*', '+=', '+', '-=', '-', '..', '.', '/=', '/', ';', '^=', '^', '{', '}', '#', '@' in Move code.
// 04bd7c2ae0fa0dd8e5422928ce691d29: Test that variables declared with explicit types can be mutated and incremented correctly within a function.
// 27856bf097f088e0bef1d99fc9535c12: Declare functions or modules with 'public', 'public(friend)', or 'private' visibility specifiers in Move.
