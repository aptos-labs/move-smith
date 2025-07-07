//# publish
module 0xCAFE::BinaryOps {

    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    public fun mul_i64(a: i64, b: i64): i64 {
        a * b
    }

    public fun sub_u8(a: u8, b: u8): u8 {
        a - b
    }

    public fun div_u16(a: u16, b: u16): u16 {
        a / b
    }

    public fun friend friend_only_function(a: u64, b: u64): u64 {
        a ^ b // xor operator as binary operator
    }

    fun package_only_function(a: u8, b: u8): u8 {
        a & b // and operator as binary operator
    }

    #[spec]
    fun specification_add(x: u64, y: u64): u64 {
        x + y
    }

    #[spec(friend)]
    fun specification_friend_sub(x: u64, y: u64): u64 {
        x - y
    }

    #[spec]
    fun specification_mul(x: u8, y: u8): u8 {
        x * y
    }

    // A runner function callable without arguments to test access to friend and package functions internally
    public fun runner(): u64 {
        let a = 10u64;
        let b = 20u64;
        // call friend_only_function internally (allowed)
        let f = friend_only_function(a, b);
        // call package_only_function internally (allowed)
        let p = package_only_function(2u8, 3u8);

        // Return sum of friend_only_function output and package_only_function output casted to u64
        f + (p as u64)
    }
}
//# run 0xCAFE::BinaryOps::runner --signers 0xCAFE

//# run 0xCAFE::BinaryOps::friend_only_function --signers 0xCAFE --args 5u64 7u64

//# publish
module 0xCAFE::FriendTest {

    friend 0xCAFE::BinaryOps;

    // This function is friend visible, so allowed only to friend modules (like BinaryOps)
    friend fun call_binaryops_friend(a: u64, b: u64): u64 {
        0xCAFE::BinaryOps::friend_only_function(a, b)
    }

    // Package only function, accessible only inside this module.
    fun package_only(): u64 {
        42
    }

    public fun call_package_only(): u64 {
        // Allowed internally
        package_only()
    }

    // Runner that uses the friend call to BinaryOps and internal package calls
    public fun runner(): u64 {
        let res1 = call_binaryops_friend(15u64, 3u64);
        let res2 = call_package_only();
        res1 + res2
    }
}
//# run 0xCAFE::FriendTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::BinaryOps;
    use 0xCAFE::FriendTest;

    fun main() {
        let sum = BinaryOps::add_u64(5, 10);
        let mul = BinaryOps::mul_i64(-7, 6);
        let friend_result = BinaryOps::friend_only_function(2,3);
        let friend_call = FriendTest::call_binaryops_friend(4,5);
        let friend_runner_res = FriendTest::runner();

        // no assertions needed, just run operations exercising the compiler and VM
    }
}

// Featurres:
// 67f3c99431dcc7ed5f47fde8005c65a8: Write regular binary operator expressions in code.
// c97d16ca4d327179d64cbaa15d06c6b2: Declare functions in specifications with parameter lists enclosed in parentheses.
// 2056f17708d282991858422ba732d384: Use 'friend' visibility for functions accessible only within the same crate or to friends, and distinguish it from package visibility.
