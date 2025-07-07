//# publish
module 0x1::TestModule {
    // No need to define any resources or structs for these tests.
}

//# run
script {
    use std::vector;

    fun sum_bytes(v: vector<u8>): u64 {
        let mut total: u64 = 0;
        let mut vec = v;
        while (!vector::is_empty(&vec)) {
            total = total + (vector::pop_back(&mut vec) as u64);
        };
        total
    }

    fun main() {
        let data = b"abcde"; // ascii values: 97,98,99,100,101
        let sum = sum_bytes(data);
        assert!(sum == (97 + 98 + 99 + 100 + 101), sum);
    }
}

//# run 0x1::TestModule::sum_bytes