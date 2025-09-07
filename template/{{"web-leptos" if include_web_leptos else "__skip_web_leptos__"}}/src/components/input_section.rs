use leptos::prelude::*;

#[component]
pub fn InputSection(
    input: ReadSignal<String>,
    set_input: WriteSignal<String>,
    on_parse: impl Fn() + 'static,
) -> impl IntoView {
    view! {
        <div>
            <h2 class="heading-section-spaced">"Input"</h2>
            <textarea
                class="textarea-input"
                placeholder="Enter tokens like: 1+2+3"
                on:input=move |ev| set_input.set(event_target_value(&ev))
                prop:value=input
            ></textarea>
            <button class="btn-primary" on:click=move |_| on_parse()>"Parse"</button>
        </div>
    }
}
