//# publish
address 0xBEEF {
    module GenericPhantom<T, PhantomPhantom> {
        use std::marker;

        // Generic struct with phantom type parameter
        struct PhantomStruct<T, PhantomPhantom> has store {
            value: u64,
            phantom: marker::PhantomData<PhantomPhantom>,
            _t: marker::PhantomData<T>,
        }

        public fun new(value: u64): PhantomStruct<u8, u64> {
            PhantomStruct { value, phantom: marker::PhantomData, _t: marker::PhantomData }
        }

        public fun runner() {
            let x = Self::new(42);
            // Dummy usage so nothing optimized away
            let _v = x.value;
        }
    }
}
//# run 0xBEEF::GenericPhantom::runner --signers 0xBEEF

//# publish
module LogSpecParser {
    use std::string;
    use std::vector;

    struct LogSpec has store {
        tags: vector::Vector<string::String>,
    }

    /// Parses a comma separated log spec string
    /// Returns a LogSpec resource with tags vector
    public fun parse(spec: &string::String): LogSpec {
        let parts = string::split(spec, string::utf8(b","), 10);
        let tags = vector::empty<string::String>();
        let i = 0;
        while (i < vector::length(&parts)) {
            let tag = vector::borrow(&parts, i);
            let trimmed = string::trim_whitespace(tag);
            vector::push_back(&mut tags, trimmed);
            i = i + 1;
        }
        LogSpec { tags }
    }

    public fun runner() {
        let s = string::utf8(b"event1,event2,event3");
        let spec = Self::parse(&s);
        let len = vector::length(&spec.tags);
        let _ = len;
    }
}
//# run LogSpecParser::runner

//# run main_script

script {
    use 0xBEEF::GenericPhantom;
    use LogSpecParser;

    fun main() {
        // Using the generic module with phantom parameters
        let instance = GenericPhantom::new(100);
        let _ = instance.value;

        // Parse log spec config string and check length
        let s = "log1,log2,log3,log4";
        let string_s = std::string::utf8(s);
        let spec = LogSpecParser::parse(&string_s);
        let len = std::vector::length(&spec.tags);
        let _ = len;
    }
}