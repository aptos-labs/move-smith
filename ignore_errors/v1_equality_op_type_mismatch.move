//# publish
module 0xCAFE::Module0 {
    public fun function7() {
        let x = 0u16;
        let y: &u16 =  &(x);
        (if (true)  { &mut (x) } else { &mut (copy x) } != &mut (*(copy y)));
    }
}
