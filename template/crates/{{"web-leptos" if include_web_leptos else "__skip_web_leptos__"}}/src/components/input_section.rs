use leptos::prelude::*;

#[component]
pub(crate) fn InputSection(
    input: ReadSignal<String>,
    set_input: WriteSignal<String>,
    on_greet: impl Fn() + 'static,
) -> impl IntoView {
    view! {
        <div>
            <h2 class="heading-section-spaced">"Recipient"</h2>
            <textarea
                class="textarea-input"
                placeholder="Enter a recipient"
                on:input=move |ev| set_input.set(event_target_value(&ev))
                prop:value=input
            ></textarea>
            <button class="btn-primary" on:click=move |_| on_greet()>
                "Greet"
            </button>
        </div>
    }
}
