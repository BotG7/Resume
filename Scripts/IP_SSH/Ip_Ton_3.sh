#!/bin/bash

Ip_l='Ip.txt'
pon=$(whoami)

# Запрашиваем путь к скрипту на родительском ПК
read -p "Введите путь к скрипту на родительском ПК: " COMM
# Удаляем одинарные кавычки, если они есть
COMM=$(echo "$COMM" | sed "s/'//g")

# Проверка, что путь к скрипту не пустой
if [ -z "$COMM" ]; then
    echo "Ошибка: путь к скрипту не может быть пустым."
    exit 1
fi

#Запрашиваем путь для сохранения скрипта на удаленных ПК
read -p "Введите путь для сохранения скрипта на удаленных ПК: " VONN
#Удаляем одинарные кавычки, если они есть
VONN=$(echo "$VONN" | sed "s/'//g")

#Проверка, что путь для сохранения не пустой
if [ -z "$VONN" ]; then
    echo "Ошибка: путь для сохранения не может быть пустым."
    exit 1
fi

#Получаем имя последнего файла из указанного пути
script=$(basename "$COMM")

#Подсчет количества IP-адресов в файле
ip_count=$(wc -l < "$Ip_l")
echo "Количество IP-адресов в файле: $ip_count"

#Цикл для выполнения основного процесса столько раз, сколько айпи адресов
for ((i=1; i<=ip_count; i++)); do
    ip=$(sed -n "${i}p" "$Ip_l")  # Получаем i-й IP-адрес из файла
    echo "Проверка соединения с $ip..."
    
    #Проверка доступности айпи адреса
    if ping -c 1 "$ip" &> /dev/null; then
        echo "Подключение к $ip..."

    #Определение имени пользователя на удаленном ПК
        user=$(ssh -o StrictHostKeyChecking=no "$pon@$ip" "whoami" 2>/dev/null)
        exit_status=$?  # Сохраняем статус после выполнения команды

        if [ $exit_status -eq 0 ]; then
            echo "Определён пользователь: $user"

    #Копирование файла в домашнюю директорию пользователя на удаленном ПК
            scp "$COMM" "$user@$ip:~/$script"
            
            if [ $? -eq 0 ]; then
                echo "Файл успешно скопирован в домашнюю директорию на $ip"

    #Проверка существования пути для сохранения скрипта на удаленном ПК
                if ssh "$user@$ip" "[ ! -d $(dirname "$VONN") ]"; then
                    echo "Директория $(dirname "$VONN") не существует. Создание..."
                    ssh "$user@$ip" "mkdir -p $(dirname "$VONN")"
                fi
                
    #Перемещение файла из домашней директории в нужное место
                if ssh "$user@$ip" "[ -f ~/$script ]"; then
                    ssh "$user@$ip" "sudo mv ~/$script $VONN"
                    
    #Выполнение скрипта на удаленном ПК с использованием нового пути
                    ssh "$user@$ip" "bash $VONN/$script"
                    
                    if [ $? -eq 0 ]; then
                        echo "Команда успешно выполняется на $ip"
                    else
                        echo "Ошибка выполнения команды на $ip"
                    fi
                else
                    echo "Файл ~/$script не найден на $ip. Пропуск..."
                fi
                
            else
                echo "Ошибка копирования на $ip"
            fi
            
        else
            echo "Не удалось определить пользователя на $ip"
        fi
    else
        echo "Host $ip не доступен. Пропуск..."
    fi
done

echo "Все операции завершены."

