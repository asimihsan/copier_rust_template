use std::os::raw::c_char;
use std::ffi::{CString, CStr};
use anyhow::Result;
use libc::free;

use {{ project_slug_underscore }}_core::parse;

/// Exported FFI function to parse an arithmetic expression
/// Caller is responsible for freeing the returned C string with free_rust_string()
#[no_mangle]
pub extern "C" fn parse_expression(input: *const c_char) -> *mut c_char {
    let input_str = unsafe { CStr::from_ptr(input).to_str().unwrap_or_default() };
    
    match parse(input_str) {
        Ok(result) => CString::new(result).unwrap().into_raw(),
        Err(e) => CString::new(format!("Error: {}", e)).unwrap().into_raw(),
    }
}

/// Helper function to free strings returned by parse_expression()
#[no_mangle]
pub extern "C" fn free_rust_string(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        CString::from_raw(s)
    };
}
