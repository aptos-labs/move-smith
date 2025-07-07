//# run
script {
    use 0x1::constant_borrow_test;

    fun main() {
        constant_borrow_test::run();
    }
}