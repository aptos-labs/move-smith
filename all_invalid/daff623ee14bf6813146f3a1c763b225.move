//# publish
module 0x1::FieldMutateTest {
    use std::signer;

    struct Data has store {
        a: u64,
        b: bool,
    }

    public fun new_data(): Data {
        Data { a: 42, b: true }
    }

    public fun mutate_fields(mut d: &mut Data) {
        // Mutate using explicit colon syntax for field access and mutation
        d:Data.a = 100;
        d:Data.b = false;
    }

    public fun runner() {
        let mut d = new_data();
        // initial state: a=42, b=true
        mutate_fields(&mut d);
        // after mutation: a=100, b=false
    }
}

//# run 0x1::FieldMutateTest::runner

//# publish
module 0x1::AliasValidationTest {
    use std::vector;

    /// Simulated alias names for members
    const ALIAS_NAME_A: vector<u8> = b"valid_name";
    const ALIAS_NAME_B: vector<u8> = b"_invalidName!";

    struct Record has store {
        valid_name: u64,
        invalid_name: u64,
    }

    // Simple validation: alias must only contain ascii letters, digits, or underscore, and not start with digit
    fun is_valid_alias_name(name: &vector<u8>): bool {
        if (vector::is_empty(name)) {
            return false;
        }
        let first = *vector::borrow(name, 0);
        // must be letter or underscore
        if (!(is_alpha(first) || first == 95)) {
            return false;
        }
        let mut i = 1;
        while (i < vector::length(name)) {
            let c = *vector::borrow(name, i);
            if (!(is_alpha_num(c) || c == 95)) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    fun is_alpha(c: u8): bool {
        (c >= 65 && c <= 90) || (c >= 97 && c <= 122)
    }

    fun is_alpha_num(c: u8): bool {
        is_alpha(c) || (c >= 48 && c <= 57)
    }

    public fun runner() {
        let rec = Record { valid_name: 1, invalid_name: 2 };
        // Check aliases
        let valid_check = is_valid_alias_name(&ALIAS_NAME_A);
        let invalid_check = is_valid_alias_name(&ALIAS_NAME_B);
        // Use results in no-op to avoid unused var warnings
        let _ = rec.valid_name;
        let _ = rec.invalid_name;
        let _ = valid_check;
        let _ = invalid_check;
    }
}

//# run 0x1::AliasValidationTest::runner

//# run 0x1::FieldMutateTest::mutate_fields --signers 0x1 --args 0x0