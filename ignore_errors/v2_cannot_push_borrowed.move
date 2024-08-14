//# publish
module 0xCAFE::Module0 {
    use std::vector;
    public fun function1() {
        let x: vector<u8> =  vector[];
        let y =  vector::borrow<u8>(&x, 0);
        vector::push_back<u8>(&mut x, *y);
    }
}
