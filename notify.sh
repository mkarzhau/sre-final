#!/bin/bash

# Запросить у пользователя текст сообщения
echo "Введите текст сообщения для отправки:"
read MESSAGE

# Преобразуем сообщение в кодировку UTF-8
ENCODED_MESSAGE=$(echo "$MESSAGE" | iconv -f WINDOWS-1251 -t UTF-8)

# Список chat_id (пользователь может сам добавить сюда chat_id)
echo "Введите chat_id (через пробел) для отправки сообщения:"
read -a CHAT_IDS  # Ввод нескольких chat_id через пробел
# 965417533 1044841557
# Ваш bot_token
BOT_TOKEN="7902458952:AAFfbNdAPjMTdaN6QjeLI9pJE1q7GLWZYJM"

# Отправляем сообщение каждому пользователю
for CHAT_ID in "${CHAT_IDS[@]}"
do
    response=$(curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$ENCODED_MESSAGE")

    # Проверяем успешность отправки
    if [[ $response == *"ok\":true"* ]]; then
        echo "✅ Сообщение отправлено в чат $CHAT_ID."
    else
        echo "❌ Ошибка при отправке сообщения в чат $CHAT_ID: $response"
    fi
done
БД снова работает, метрики восстановлены.