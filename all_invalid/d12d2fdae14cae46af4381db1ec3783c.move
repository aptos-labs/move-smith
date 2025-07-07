//# publish
module 0x1::Target {

// 1. Define a resource R with a value field
resource struct R has store {
    v: u64,
}

// 2. Define a function do() that modifies R based on v
public fun do(r: &mut R) {
    if (r.v > 10) {
        r.v = r.v * 2;
    } else {
        r.v = r.v + 1;
    }
}

// 3. We'll add a runner function that creates an R resource in storage, runs do(), and updates it
public fun runner(account: &signer) {
    // Create R with v = 5
    move_to(account, R { v: 5 });
    // Borrow a mutable reference
    let r_ref = borrow_global_mut<R>(signer::address_of(account));
    do(r_ref);

    // Change v to 20 to test other branch
    r_ref.v = 20;
    do(r_ref);
}

// 4. Define a schema spec with type parameters (for point 5)
spec schema MySchema<T> { x: T }

// 5. Convert list of type parameters with abilities into a set-based
// We'll define a dummy ability enum and a function for the conversion
enum Ability { copy, drop, store, key }

public fun abilities_to_set(abilities: vector<Ability>): u8 {
    // Just a dummy implementation that returns a bit mask (0..15)
    let mut set = 0u8;
    let len = vector::length(&abilities);
    let mut i = 0;
    while (i < len) {
        let ab = *vector::borrow(&abilities, i);
        let bit = match ab {
            Ability::copy => 1,
            Ability::drop => 2,
            Ability::store => 4,
            Ability::key => 8,
        };
        set = set | bit;
        i = i + 1;
    }
    set
}

}

//# run 0x1::Target::runner --signers 0x1

//# publish
module 0x1::SkipLint {

// 3. Using skip attribute with lint names
#[skip("non_address_literal", "unused_import")]
use std::vector;

public fun run_dummy() {
// empty function just to test skip attribute processing
}

}

//# run 0x1::SkipLint::run_dummy

//# publish
module 0x1::SeqTrailingUnit {

// 4. Function to demonstrate automatic trailing unit append
public fun seq_without_final_expr() {
    let _x = 1;
    let _y = 2;
    // no final expression here, should implicitly have unit trailing
}

public fun runner() {
    seq_without_final_expr();
}

//# run 0x1::SeqTrailingUnit::runner

}