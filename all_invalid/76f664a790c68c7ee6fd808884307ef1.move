
//# publish
module 0xCAFE::FunctionTypes {
    public inline fun identity(x: u8): u8 {
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

        let _ = (twice_result, combined_result, final_result);
    }
}


//# run 0xCAFE::FunctionTypes::runner


// Featurres:
// 71deadd259c8108c83b0f1ebcfc53c97: Represent function types with input and output signatures enclosed in '|' characters, with multiple parameters separated by commas.
// ff1512edbab62479df53703ac4442701: Declare public functions or modules using the 'public' visibility modifier.
// 0f73841b7d38953764a6f6cb7e505d4a: Use hexadecimal format for the numerical address when no named address is found.
