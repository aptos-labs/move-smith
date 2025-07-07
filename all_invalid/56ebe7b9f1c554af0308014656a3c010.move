//# run
script {
    use 0xA550::TestModule;

    fun main() {
        // Invoke the runner function that tests logging and debug info
        TestModule::run_tests();
    }
}