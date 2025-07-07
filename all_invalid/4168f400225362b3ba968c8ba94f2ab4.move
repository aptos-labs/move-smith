//# run
script {
    use 0xCAFE::ShadowingTest;

    fun main(x: u8, y: u8) {
        ShadowingTest::run_shadowing_test(x, y);
    }
}
