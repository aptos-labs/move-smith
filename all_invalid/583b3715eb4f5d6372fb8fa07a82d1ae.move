//# publish
module 0x1::TestModule {
    use std::vector;

    // A native function declared and later implemented by the VM (dummy here)
    native public fun native_add(a: u64, b: u64): u64;

    // Regular Move function with a body: sums two numbers and returns the result
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Function demonstrating binding local variables and creating vectors
    public fun vec_and_bind(): vector<u8> {
        let x = 10u8;
        let y = 20u8;
        let sum = x + y;
        // Create a vector of u8 with elements x, y, and sum
        let v = vector::empty<u8>();
        vector::push_back(&mut v, x);
        vector::push_back(&mut v, y);
        vector::push_back(&mut v, sum);
        v
    }

    // Runner function invoking the above functions inside the module
    public fun run_tests() {
        let _ = add(1, 2);
        let _ = native_add(3, 4);
        let _ = vec_and_bind();
    }
}
//# run 0x1::TestModule::run_tests


//# run
script {
    use 0x1::TestModule;
    use std::vector;

    fun main() {
        // Call the add function
        let sum = TestModule::add(100, 200);

        // Call the native function native_add
        let native_sum = TestModule::native_add(300, 400);

        // Create vector with explicit type argument and elements binding to local vars
        let a = 1u64;
        let b = 2u64;
        let v = vector::empty<u64>();
        vector::push_back(&mut v, a);
        vector::push_back(&mut v, b);
        vector::push_back(&mut v, sum);
        vector::push_back(&mut v, native_sum);

        // Use module function to create a vector as well
        let v2 = TestModule::vec_and_bind();

    }
}