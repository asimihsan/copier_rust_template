use leptos::logging;
use leptos::prelude::*;
use leptos_meta::{Title, provide_meta_context};

use crate::components::{GreetingResult, InputSection};
use crate::greeting::create_greeting_action;

#[component]
pub(crate) fn App() -> impl IntoView {
    provide_meta_context();

    let (input, set_input) = signal("Ihsan".to_string());
    let (result, set_result) = signal(None);

    let greeting_action = create_greeting_action();

    let dispatch_greeting = move || {
        logging::log!("dispatching greeting for recipient: {}", input.get());
        greeting_action.dispatch(input.get());
    };

    Effect::new(move |_| {
        logging::log!("greeting action value: {:?}", greeting_action.value().get());
        match greeting_action.value().get() {
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
                        on_greet=dispatch_greeting
                    />

                    <div class="single-column-layout">
                        <GreetingResult
                            result=result
                        />
                    </div>
                </div>
            </div>
        </main>
    }
}
