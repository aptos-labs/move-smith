
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::string::{String, utf8};
    use std::vector::{Vector, empty};

    struct Wrapper<T> has copy, drop, store {
        value: T,
    }

    struct Container<T, U> has store {
        first: Wrapper<T>,
        second: Wrapper<U>,
    }

    // Package visibility function - accessible within the same package
    fun package_function(x: u64): u64 {
        x + 42
    }

    public fun call_package_function(x: u64): u64 {
        package_function(x)
    }

    public fun make_container(x: u8, y: u16): Container<u8, u16> {
        Container {
            first: Wrapper { value: x },
            second: Wrapper { value: y },
        }
    }
}


//# run 0xCAFE::AdvancedFeatures::call_package_function --args 100u64


//# run 0xCAFE::AdvancedFeatures::make_container --args 10u8 20u16


//# publish
module 0xCAFE::PackageUser {
    use 0xCAFE::AdvancedFeatures;

    public fun use_package_function(x: u64): u64 {
        AdvancedFeatures::package_function(x)
    }
}


//# run 0xCAFE::PackageUser::use_package_function --args 123u64


// Featurres:
// c27bfd0ddff886e382b79619db313d1a: Organize spec block contents using a syntax that allows multiple 'use' declarations and members inside braces.
// acc09288ac948ff4171637016b3627bd: Use type parameters in struct definitions.
// 7042ca367147ef9da6aff64ec2f7255b: Declare functions with package visibility that can be called from any module in the same package.
