//# publish
module 0xCAFE::Module0 {
    public fun function2(sref: &signer, var8: bool, var9: u32, var10: u32, var11: u32, var12: u16) {
        let var44: &mut bool =  &mut (var8);
        if (var8)  {
        } else {
            *var44 = false;
        };
        if (copy var8)  { } else { };
    }
}
