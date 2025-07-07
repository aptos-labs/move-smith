//# publish
module 0xc0ffee::m {
    // Existing add function for use in test
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // New test function to verify complex arithmetic operations involving x
    public fun test(): u64 {
        let x = 4;
        // Perform multiple updates with various operations
        let y = {x = x + 2; x * 3};       // (4 + 2) * 3 = 18
        let z = {x = y.x - 4; x / 2};     // 18 - 4 = 14, 14 / 2 = 7
        // Final addition of results
        add(y.x, z.x)  // 18 + 7 = 25
    }
}

//# run 0xc0ffee::m::test

//# publish
module 0x42::test {
    struct Coin(u256) has drop;

    struct Wrapper<T>(T) has drop;

    // Increment functions for primitive u256 types
    fun add1_old(x: u256): u256 {
        x = x + 1;
        x
    }

    fun add1_new(x: u256): u256 {
        x += 1;
        x
    }

    // Increment functions for mutable references of u256
    fun inc_new(x: &mut u256) {
        *x += 1;
    }

    fun inc_old(x: &mut u256) {
        *x = *x + 1;
    }

    // Increment functions for Coin structs
    fun coin_inc_new_1(self: &mut Coin) {
        self.0 += 1;
    }

    fun coin_inc_new_2(self: &mut Coin) {
        let p = &mut self.0;
        *p = *p + 1;
    }

    fun coin_inc_old_1(self: &mut Coin) {
        self.0 = self.0 + 1;
    }

    fun coin_inc_old_2(self: &mut Coin) {
        let p = &mut self.0;
        *p = *p + 1;
    }

    // Increment functions for wrapped Coin type
    fun inc_wrapped_coin_new(x: &mut Wrapper<Coin>) {
        x.0.0 += 1;
    }

    fun inc_wrapped_coin_old(x: &mut Wrapper<Coin>) {
        x.0.0 = x.0.0 + 1;
    }

    // Increment functions for vector of u256
    fun inc_vec_new(x: &mut vector<u256>, index: u64) {
        x[index] += 1;
    }

    fun inc_vec_old(x: &mut vector<u256>, index: u64) {
        x[index] = x[index] + 1;
    }

    // Increment functions for vector of Coin
    fun inc_vec_coin_new(x: vector<Coin>, index: u64): vector<Coin> {
        let mut x = x;
        x[index].0 += 1;
        x
    }

    fun inc_vec_coin_old(x: vector<Coin>, index: u64): vector<Coin> {
        let mut x = x;
        x[index].0 = x[index].0 + 1;
        x
    }

    // Increment functions for vector of wrapped Coin
    fun inc_vec_wrapped_coin_new(x: vector<Wrapper<Coin>>, index: u64): vector<Wrapper<Coin>> {
        let mut x = x;
        x[index].0.0 += 1;
        x
    }

    fun inc_vec_wrapped_coin_old(x: vector<Wrapper<Coin>>, index: u64): vector<Wrapper<Coin>> {
        let mut x = x;
        x[index].0.0 = x[index].0.0 + 1;
        x
    }

    // Function to simulate postfix increment for u64
    fun x_plusplus(x: &mut u64): u64 {
        let res = *x;
        *x += 1;
        res
    }

    // Test for various increment implementations across types
    public fun run_all_tests() {
        // Test primitive add
        assert!(add1_old(42) == add1_new(42));
        // Test increment on u256
        let mut val = 100u256;
        inc_new(&mut val);
        assert!(val == 101u256);
        // Test Coin increment
        let mut coin1 = Coin(50);
        let mut coin2 = Coin(50);
        let mut coin3 = Coin(50);
        let mut coin4 = Coin(50);
        coin_inc_new_1(&mut coin1);
        coin_inc_new_2(&mut coin2);
        coin_inc_old_1(&mut coin3);
        coin_inc_old_2(&mut coin4);
        assert!(&coin1 == &coin2);
        assert!(&coin1 == &coin3);
        assert!(&coin1 == &coin4);
        // Test wrapped Coin
        let mut wrapped_x = Wrapper(Coin(60));
        let mut wrapped_y = Wrapper(Coin(60));
        inc_wrapped_coin_new(&mut wrapped_x);
        inc_wrapped_coin_old(&mut wrapped_y);
        assert!(wrapped_x == wrapped_y);
        // Test vector of u256
        let mut vec_x = vector<u256>[42, 43];
        let mut vec_y = vector<u256>[42, 43];
        inc_vec_new(&mut vec_x, 0);
        inc_vec_old(&mut vec_y, 0);
        assert!(vec_x == vec_y);
        // Test vector of Coins
        let coin_vec_x = vector<Coin>[Coin(10)];
        let coin_vec_y = vector<Coin>[Coin(10)];
        let updated_x = inc_vec_coin_new(coin_vec_x, 0);
        let updated_y = inc_vec_coin_old(coin_vec_y, 0);
        assert!(updated_x == updated_y);
        // Test vector of Wrapped Coins
        let wrapped_vec_x = vector<Wrapper<Coin>>[Wrapper(Coin(20))];
        let wrapped_vec_y = vector<Wrapper<Coin>>[Wrapper(Coin(20))];
        let updated_x = inc_vec_wrapped_coin_new(wrapped_vec_x, 0);
        let updated_y = inc_vec_wrapped_coin_old(wrapped_vec_y, 0);
        assert!(updated_x == updated_y);
        // Test postfix increment
        let mut count = 0u64;
        let index = x_plusplus(&mut count);
        assert!(index == 0);
        assert!(count == 1);
    }
}

//# run --verbose -- 0x42::test::run_all_tests
