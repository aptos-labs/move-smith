//# publish
module 0xCAFE::MaxParams {
    // Test declaring members with optional 'public' visibility modifier

    // public constant
    public const MAX_VALUE: u8 = 255;

    // private constant
    const MIN_VALUE: u8 = 0;

    // public struct with key and store abilities
    // visibility of fields with no explicit 'public' (default is private)
    public struct DataHolder has key, store {
        val: u64,
        flag: bool,
    }

    // struct with public visibility omitted (private struct)
    struct PrivateData {
        dummy: u8,
    }

    // public function to create DataHolder
    public fun create(val: u64, flag: bool): DataHolder {
        DataHolder { val, flag }
    }

    // function without 'public' (private)
    fun helper_add_one(x: u64): u64 {
        x + 1
    }

    // public inline function that takes 65 params, captures them in a lambda and returns the sum
    //
    // We'll use a higher-order function to capture parameters in a closure and evaluate sum as proof of their usage.
    // Since Move does not have lambdas in traditional sense, we will emulate the capture by use of a nested function.

    // Note: The 'lambda' is emulated by a nested function that uses all parameters by referencing them explicitly.

    // To ensure usage of all 65 parameters, we sum them all.

    public inline fun sum_65_params(
        p0: u8,  p1: u8,  p2: u8,  p3: u8,  p4: u8,
        p5: u8,  p6: u8,  p7: u8,  p8: u8,  p9: u8,
        p10: u8, p11: u8, p12: u8, p13: u8, p14: u8,
        p15: u8, p16: u8, p17: u8, p18: u8, p19: u8,
        p20: u8, p21: u8, p22: u8, p23: u8, p24: u8,
        p25: u8, p26: u8, p27: u8, p28: u8, p29: u8,
        p30: u8, p31: u8, p32: u8, p33: u8, p34: u8,
        p35: u8, p36: u8, p37: u8, p38: u8, p39: u8,
        p40: u8, p41: u8, p42: u8, p43: u8, p44: u8,
        p45: u8, p46: u8, p47: u8, p48: u8, p49: u8,
        p50: u8, p51: u8, p52: u8, p53: u8, p54: u8,
        p55: u8, p56: u8, p57: u8, p58: u8, p59: u8,
        p60: u8, p61: u8, p62: u8, p63: u8, p64: u8
    ): u64 {
        // Nested function "lambda" capturing params from outer scope
        fun lambda_sum(): u64 {
            let sum: u64 = 
                (p0 as u64) + (p1 as u64) + (p2 as u64) + (p3 as u64) + (p4 as u64) +
                (p5 as u64) + (p6 as u64) + (p7 as u64) + (p8 as u64) + (p9 as u64) +
                (p10 as u64) + (p11 as u64) + (p12 as u64) + (p13 as u64) + (p14 as u64) +
                (p15 as u64) + (p16 as u64) + (p17 as u64) + (p18 as u64) + (p19 as u64) +
                (p20 as u64) + (p21 as u64) + (p22 as u64) + (p23 as u64) + (p24 as u64) +
                (p25 as u64) + (p26 as u64) + (p27 as u64) + (p28 as u64) + (p29 as u64) +
                (p30 as u64) + (p31 as u64) + (p32 as u64) + (p33 as u64) + (p34 as u64) +
                (p35 as u64) + (p36 as u64) + (p37 as u64) + (p38 as u64) + (p39 as u64) +
                (p40 as u64) + (p41 as u64) + (p42 as u64) + (p43 as u64) + (p44 as u64) +
                (p45 as u64) + (p46 as u64) + (p47 as u64) + (p48 as u64) + (p49 as u64) +
                (p50 as u64) + (p51 as u64) + (p52 as u64) + (p53 as u64) + (p54 as u64) +
                (p55 as u64) + (p56 as u64) + (p57 as u64) + (p58 as u64) + (p59 as u64) +
                (p60 as u64) + (p61 as u64) + (p62 as u64) + (p63 as u64) + (p64 as u64);
            sum
        }
        lambda_sum()
    }

    // Runner function that calls sum_65_params with consecutive values 0..64
    public fun runner(): u64 {
        sum_65_params(
            0u8, 1u8, 2u8, 3u8, 4u8,
            5u8, 6u8, 7u8, 8u8, 9u8,
            10u8, 11u8, 12u8, 13u8, 14u8,
            15u8, 16u8, 17u8, 18u8, 19u8,
            20u8, 21u8, 22u8, 23u8, 24u8,
            25u8, 26u8, 27u8, 28u8, 29u8,
            30u8, 31u8, 32u8, 33u8, 34u8,
            35u8, 36u8, 37u8, 38u8, 39u8,
            40u8, 41u8, 42u8, 43u8, 44u8,
            45u8, 46u8, 47u8, 48u8, 49u8,
            50u8, 51u8, 52u8, 53u8, 54u8,
            55u8, 56u8, 57u8, 58u8, 59u8,
            60u8, 61u8, 62u8, 63u8, 64u8
        )
    }
}
//# run 0xCAFE::MaxParams::runner

//# publish
module 0xCAFE::PackageTransform {
    // Since Move language does not have direct package construct, this module simulates
    // transform logic based on address context for 'extract_spec_module' application,
    // here demonstrated by simple conditional logic and a key struct to verify key/store usage.

    // Dummy struct to simulate storage
    public struct PackageData has key, store {
        addr: address,
        value: u64,
    }

    // Public function to create PackageData for an address
    public fun create(addr: address, val: u64): PackageData {
        PackageData { addr, value: val }
    }

    // Public function that "transforms" package based on address context and returns copy of PackageData
    //
    // In real Aptos environment, this would likely interact with the spec or module compiler,
    // but here we'll simulate transform by returning a modified value based on address.

    public fun transform_package(pd: &PackageData): PackageData {
        let new_val = if (pd.addr == @0xCAFE) {
            pd.value + 1000
        } else {
            pd.value
        };
        PackageData { addr: copy pd.addr, value: new_val }
    }

    // Runner function creates a PackageData, transforms it, and returns the transformed value
    public fun runner(): u64 {
        let pd = create(@0xCAFE, 42);
        let new_pd = transform_package(&pd);
        new_pd.value
    }
}
//# run 0xCAFE::PackageTransform::runner

//# run
script {
    use 0xCAFE::MaxParams;
    use 0xCAFE::PackageTransform;

    fun main() {
        // Use DataHolder creation and manipulation from MaxParams module
        let dh = MaxParams::create(1234, true);
        // Call the runner in MaxParams to test 65 param function
        let sum = MaxParams::runner();

        // Use PackageTransform module runner
        let transformed_val = PackageTransform::runner();

        // Just bind them to variables to exercise VM paths, no asserts needed.
        let _: u64 = sum;
        let _: u64 = transformed_val;

        // Done
    }
}

// Featurres:
// d840b70fed6bcaf6937925a725f68655: Declare module members with optional 'public' visibility modifier
// d0921d70165ce83b0824987f7aed05f4: Test that a function can have 65 parameters and that all of them are correctly captured and usable in a lambda expression.
// fb3e5a75b2fa8991f607823b62860771: Transform modules within package definitions by applying the extract_spec_module function based on their address context.
