// Thorough transactional test for visibility variants, 'if' expressions, and access modifiers in Move.

//# publish
module 0xCAFE::VisTest {
    // Public at module level (default)
    public fun pub_default(x: u8): u8 {
        if (x > 10) x else 5
    }

    // Public to scripts only
    public(script) fun pub_script_add(x: u8, y: u8): u8 {
        if (x + y > 100) 100 else x + y
    }

    // Public to same package
    public(package) fun pub_package_sub(x: u8, y: u8): u8 {
        if (x > y) x - y else 0
    }

    // Public to friends only
    public(friend) fun pub_friend_mul(x: u8, y: u8): u8 {
        if (x == 0 || y == 0) 0 else x * y
    }

    // Private internal to module
    fun only_me(x: u8): u8 {
        if (x % 2 == 0) x / 2 else x * 2
    }

    // "Runner" function to exercise all public functions
    public fun runner(): (u8, u8, u8, u8) {
        let a = Self::pub_default(12);
        let b = Self::pub_script_add(40, 70);
        let c = Self::pub_package_sub(50, 40);
        let d = Self::pub_friend_mul(4, 5);
        (a, b, c, d)
    }
}
//# run 0xCAFE::VisTest::runner --signers 0xCAFE

//# publish
module 0xBEEF::VisFriend {
    friend 0xCAFE::VisTest;

    // Call friend's friend-function
    public fun call_friend_mul(): u8 {
        0xCAFE::VisTest::pub_friend_mul(7, 8)
    }
}
//# run 0xBEEF::VisFriend::call_friend_mul --signers 0xBEEF

//# publish
module 0xF00D::VisPackage {
    use 0xCAFE::VisTest;

    public fun call_package_sub(): u8 {
        VisTest::pub_package_sub(30, 10)
    }
}
//# run 0xF00D::VisPackage::call_package_sub --signers 0xF00D

//# run
script {
    use 0xCAFE::VisTest;

    fun main() {
        let sum = VisTest::pub_script_add(44, 35);
        // Exercise an 'if' expression without else (unit result, not usable, just runs)
        if (sum > 70) {
            // no-op branch
        }
    }
}