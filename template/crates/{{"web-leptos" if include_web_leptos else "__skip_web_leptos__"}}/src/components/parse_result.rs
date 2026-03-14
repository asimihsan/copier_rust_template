use leptos::prelude::*;

#[component]
pub fn ParseResult(result: ReadSignal<Option<String>>) -> impl IntoView {
    view! {
        <div>
            <h2 class="heading-section">Parse Result</h2>
            <p>This is the parse result.</p>
            <p>Result: {result}</p>
        </div>
    }
}
