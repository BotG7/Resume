#!/bin/bash

pon=$(whoami)
# Задание, которое нужно проверить
CRON_JOB="* * * * * /home/$pon/Документы/haha.sh"

# Проверка на наличие задания в crontab
if crontab -l | grep -Fxq "$CRON_JOB"; then
    echo "Задание уже существует в crontab."
else
    # Добавление задания в crontab
    (crontab -l; echo "$CRON_JOB") | crontab -
    echo "Задание добавлено в crontab."
fi

# Выполнение команды xrandr и проверка ее успешности
xrandr --output DP-1 --rotate inverted
xdg-open "https://avatars.mds.yandex.net/i?id=660e9b2dd1843177da8c26ea775a6b5d_l-5300097-images-thumbs&n=13"

# Создаем временный файл для хранения crontab
temp_file=$(mktemp)
# Сохраняем текущий crontab в временный файл
crontab -l > "$temp_file"
# Удаляем последнюю строку из временного файла
sed -i '$d' "$temp_file"
# Устанавливаем новый crontab без последней записи
crontab "$temp_file"
# Удаляем временный файл
rm "$temp_file"

echo "Последняя запись из crontab была удалена."

