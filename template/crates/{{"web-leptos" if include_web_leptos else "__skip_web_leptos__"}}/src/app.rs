use leptos::logging;
use leptos::prelude::*;
use leptos_meta::{Title, provide_meta_context};

use crate::components::{InputSection, ParseResult};
use crate::parser::create_parse_action;

#[component]
pub fn App() -> impl IntoView {
    provide_meta_context();

    let (input, set_input) = signal("1+2+3".to_string());
    let (result, set_result) = signal(None);

    let parse_action = create_parse_action();

    let dispatch_parse = move || {
        logging::log!("dispatching parse with input: {}", input.get());
        parse_action.dispatch(input.get());
    };

    Effect::new(move |_| {
        logging::log!("parse action value: {:?}", parse_action.value().get());
        match parse_action.value().get() {
            Some(Ok(value)) => set_result.set(Some(value)),
            Some(Err(e)) => set_result.set(Some(e.to_string())),
            None => set_result.set(None),
        }
    });

    view! {
        <Title text="My Project" />
        <main>
            <div class="app-container">
                <div class="content-wrapper">
                    <h1 class="heading-primary">My Project</h1>

                    <InputSection
                        input=input
                        set_input=set_input
                        on_parse=dispatch_parse
                    />

                    <div class="single-column-layout">
                        <ParseResult
                            result=result
                        />
                    </div>
                </div>
            </div>
        </main>
    }
}
