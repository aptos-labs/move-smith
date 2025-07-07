let val = match (r) {
    ResultType::Ok(v) => v,
    ResultType::Err(e) => { /* ... */ 0 },
    ResultType::Unexpected => 255u8,
};