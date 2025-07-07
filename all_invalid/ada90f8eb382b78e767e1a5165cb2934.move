public fun update_in_expression(val: u8): u8 {
    let s = X { val };
    let new_val = (
        {
            let updated_val = s.val + 1;
            X { val: updated_val }
        }
    ).val + 1;
    new_val
}
