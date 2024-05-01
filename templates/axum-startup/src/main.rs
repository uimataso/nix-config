use axum::http::StatusCode;
use axum::routing::get;

#[tokio::main]
pub async fn main() {
    // Build our application by creating our router.
    let app = axum::Router::new()
        .route("/hello", get(get_hello))
        .fallback(fallback);

    // Run our application as a hyper server on http://localhost:3000.
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();

    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

pub async fn fallback(uri: axum::http::Uri) -> impl axum::response::IntoResponse {
    (StatusCode::NOT_FOUND, format!("No route {uri}"))
}

pub async fn get_hello() -> String {
    "Hello".into()
}
