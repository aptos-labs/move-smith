use framework::export_all;
mod template;

export_all!(
    program,
    module,
    structs,
    function,
    signature,
    block,
    sequence,
    statement,
    expr,
    stmt_expr,
    stmt_let,
    number,
    tuple,
    call,
    assignment,
    expr_of_type,
    eot_var,
    eot_tuple,
    eot_number,
    eot_call,
    eot_struct,
    eot_enum,
    enums
);
