# Функция декодирования URL, кроме %20 (пробелов)
decode_except_spaces() {
    local input="$1"
    # Сначала заменим %20 на уникальный маркер, чтобы не трогать пробелы
    local marker="___SPACE___"
    local tmp="${input//%20/$marker}"

    # Декодируем все остальные %XX
    # Заменяем %XX на \xXX для printf
    tmp=$(echo -e "$(sed -E 's/%([0-9A-Fa-f]{2})/\\x\1/g' <<< "$tmp")")

    # Восстанавливаем пробелы
    tmp="${tmp//$marker/%20}"

    echo "$tmp"
}

if [ $# -ne 1 ]; then
    echo "Использование: $0 <url>"
    exit 1
fi

input_url="$1"
result=$(decode_except_spaces "$input_url")
echo "$result"
