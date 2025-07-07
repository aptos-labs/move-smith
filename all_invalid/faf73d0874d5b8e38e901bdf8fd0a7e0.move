
//# run
script {
    use std::debug;

    fun main(a0: u64, a1: u64, a2: u64) {
        let sum: u64 = a0 + a1 + a2;
        debug::print(u64_to_string(sum));
    }

    fun u64_to_string(value: u64): vector<u8> {
        std::string::utf8(borrow &std::string::to_string(value))
    }
}
