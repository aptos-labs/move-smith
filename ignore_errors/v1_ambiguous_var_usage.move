//# publish
module 0xCAFE::Module0 {
    public fun function1(sref: &signer, var2: u32, var3: u16) { /* _block1 */
        let var22 = &(var3);
        if (false)  { /* _block15 */
            var3;
        } else { /* _block16 */
            copy var3;
        };
        var22 = copy var22;
    }
}
