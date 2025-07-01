decode_except_spaces() {
    local input="$1"
    local marker="___SPACE___"

    # Заменяем %20 на маркер
    local tmp="${input//%20/$marker}"

    # Функция для замены %XX на соответствующие символы
    # Используем цикл и printf для декодирования
    local output=""
    local i=0
    local len=${#tmp}

    while (( i < len )); do
        local c="${tmp:i:1}"
        if [[ "$c" == "%" && i+2 < len ]]; then
            local hex="${tmp:i+1:2}"
            # Проверяем, что hex - это валидный шестнадцатеричный код
            if [[ "$hex" =~ ^[0-9A-Fa-f]{2}$ ]]; then
                # Конвертируем hex в символ
                printf -v decoded_char "\\x$hex"
                output+="$decoded_char"
                ((i+=3))
                continue
            fi
        fi
        output+="$c"
        ((i++))
    done

    # Восстанавливаем %20 обратно
    output="${output//$marker/%20}"

    echo "$output"
}

if [ $# -ne 1 ]; then
    echo "Использование: $0 <url>"
    exit 1
fi

input_url="$1"
result=$(decode_except_spaces "$input_url")
echo "$result"
