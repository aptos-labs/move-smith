//# run
script {
    use std::debug;

    fun main(a0: u64, a1: u64, a2: u64) {
        let sum: u64 = a0 + a1 + a2;
        debug::print(&sum);
    }
}
