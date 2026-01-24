// src/unsafe.rs
// ScrapeC Unsafe/Low-level Features (Stub)

pub unsafe fn raw_ptr<T>(val: &T) -> *const T {
    val as *const T
}
