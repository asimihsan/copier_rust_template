use leptos::prelude::*;

#[component]
pub(crate) fn GreetingResult(result: ReadSignal<Option<String>>) -> impl IntoView {
    view! {
        <div>
            <h2 class="heading-section">Greeting</h2>
            <p>{result}</p>
        </div>
    }
}
