extern fn nanoarrowzig_validate(
    input_array: *const anyopaque,
    input_schema: *const anyopaque,
    validate_fail: *const fn () callconv(.c) void,
) void;

pub fn validate(
    input_array: *const anyopaque,
    input_schema: *const anyopaque,
) void {
    nanoarrowzig_validate(input_array, input_schema, validate_fail);
}

fn validate_fail() callconv(.c) void {
    unreachable;
}
