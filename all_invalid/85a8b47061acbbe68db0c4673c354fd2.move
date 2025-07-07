
//# publish
module 0xCAFE::FunctionTypes {
    public fun identity(x: u8): u8 {
        x
    }

    public fun apply_twice(f: |u8|u8, x: u8): u8 {
        let y = f(x);
        let z = f(y);
        z
    }

    public fun combine(f: |u8,u8|u8, a: u8, b: u8): u8 {
        f(a, b)
    }

    public fun runner() {
        let id: |u8|u8 = identity;
        let twice_result = apply_twice(id, 5u8);

        let add: |u8,u8|u8 = |a: u8, b: u8| { a + b };
        let combined_result = combine(add, 3u8, 4u8);

        let composed: |u8|u8 = |x: u8| {
            let sum = add(x, 1u8);
            identity(sum)
        };
        let final_result = apply_twice(composed, 2u8);

        let _ = twice_result;
        let _ = combined_result;
        let _ = final_result;
    }
}



//# run 0xCAFE::FunctionTypes::runner
