//# run
script {
    use std::vector;

    fun main() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42u8);
        vector::push_back(&mut v, 133u8);
    }
}
