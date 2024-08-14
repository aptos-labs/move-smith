//# publish
module 0xCAFE::Module0 {
    public fun function5() {
        let x = &mut 0u8;
        let y = x;
        (copy y != if (false) { y } else { x });
    }
}
