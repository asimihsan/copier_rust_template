mod app;
mod components;
mod parser;

use app::*;
use leptos::{logging, mount};

fn main() {
    _ = console_log::init_with_level(log::Level::Debug);
    console_error_panic_hook::set_once();
    logging::log!("csr mode - mounting to body");
    mount::mount_to_body(App);
}
