use std::env;
use url::Url;
use urlencoding::decode;

fn url_to_uri(url: &str) -> String {
    let decoded = decode(url).unwrap_or_else(|_| url.into());
    decoded.replace(" ", "%20")
}

fn print_help(program_name: &str) {
    println!("Использование: {} <url>", program_name);
    println!("Обрабатывает переданный URL и выводит результат.");
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program_name = &args[0];

    match args.len() {
        1 => {
            print_help(program_name);
        }
        2 => {
            let input_url = &args[1];
            if Url::parse(input_url).is_err() {
                eprintln!("Ошибка: переданный параметр не является корректным URL");
                std::process::exit(1);
            }
            let uri = url_to_uri(input_url);
            println!("{}", uri);
        }
        _ => {
            eprintln!("Ошибка: параметр должен быть только один");
            std::process::exit(1);
        }
    }
}
