#!/bin/bash

# URL для скачивания RPM-пакета
DOWNLOAD_URL="https://github.com/jgraph/drawio-desktop/releases/download/v26.0.15/drawio-x86_64-26.0.15.rpm"

# Путь для сохранения скачанного файла
DOWNLOAD_PATH="/tmp/drawio-x86_64-26.0.15.rpm"

echo "Начинаем загрузку файла с GitHub..."

# Скачиваем файл
wget --no-check-certificate "$DOWNLOAD_URL" -O "$DOWNLOAD_PATH"

# Проверяем, успешно ли скачан файл
if [ $? -eq 0 ] && [ -f "$DOWNLOAD_PATH" ]; then
    echo "Файл успешно скачан: $DOWNLOAD_PATH"

    # Проверяем, является ли скачанный файл RPM-пакетом
    if file "$DOWNLOAD_PATH" | grep -q "RPM"; then
        echo "Файл является RPM-пакетом."

        # Устанавливаем RPM-пакет
        echo "Установка пакета..."
        sudo dnf install -y "$DOWNLOAD_PATH"

        # Проверяем успешность установки
        if [ $? -eq 0 ]; then
            echo "Пакет успешно установлен."
        else
            echo "Ошибка при установке пакета."
            exit 1
        fi
    else
        echo "Ошибка: Скачанный файл не является RPM-пакетом."
        exit 1
    fi
else
    echo "Ошибка при скачивании файла."
    exit 1
fi

# Удаляем скачанный файл после установки
rm -f "$DOWNLOAD_PATH"
