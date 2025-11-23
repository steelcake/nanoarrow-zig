pub extern fn nanoarrowzig_validate(
    input_array: *const anyopaque,
    input_schema: *const anyopaque,
    validate_fail: *const fn () callconv(.c) void,
) void;
