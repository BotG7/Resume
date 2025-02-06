#!/bin/bash
#Нынешний пользователь пк
pol=$(whoami)

#Путь к файлам браузера
Ch_Link="$HOME/.config/chromium/Default"
pkill chromium

#Чтобы посмотреть какие есть файлы в папке хрома:
#ls -a "$HOME/.config/chromium/Default"

#Удаление файлов-паролей
rm -f "$Ch_Link/Login Data"
rm -f "$Ch_Link/Login Data-journal"

#Чистка кеша, закрытие вкладок, чистка истории и тп.
rm -rf "$Ch_Link/Cache"
rm -rf "$Ch_Link/Cache Storage"
rm -rf "$Ch_Link/IndexedDB"
rm -rf "$Ch_Link/Local Storage"
rm -rf "$Ch_Link/Service Worker"
rm -rf "$Ch_Link/Sessions"
rm -f "$Ch_Link/Preferences"
rm -f "$Ch_Link/Cookies"
rm -f "$Ch_Link/Cookies-journal"
rm -f "$Ch_Link/Web Data"
rm -f "$Ch_Link/Web Data-journal"
rm -f "$Ch_Link/Top Sites"
rm -f "$Ch_Link/Top Sites-journal"
rm -f "$Ch_Link/Favicons"
rm -f "$Ch_Link/Favicons-journal"
rm -f "$Ch_Link/TransportSecurity"
rm -rf "$Ch_Link/Sync Data"
rm -f "$Ch_Link/Shortcuts"
rm -f "$Ch_Link/Shortcuts-journal"
rm -f "$Ch_Link/MediaDeviceSalts"
rm -f "$Ch_Link/MediaDeviceSalts-journal"
rm -f "$Ch_Link/heavy_ad_intervention_opt_out.db"
rm -rf "$Ch_Link/DIPS"
rm -rf "$Ch_Link/History Provider Cache"

echo "Пароли удалены. Данные пользователей Google сохранены."
#Чистка папок пк
rm -rf /home/$pol/Видео/*
rm -rf /home/$pol/Загрузки/*
rm -rf /home/$pol/Изображения/*
rm -rf /home/$pol/Музыка/*
rm -rf ~/.local/share/Trash/files/* 
rm -rf ~/.local/share/Trash/info/*
#Обновление пк, скачивание кеша и отключение 
sudo dnf makecache
sudo dnf upgrade -y
sudo shutdown -a
