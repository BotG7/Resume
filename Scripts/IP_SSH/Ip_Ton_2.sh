#!/bin/bash
Ip_l='Ip.txt'
pon=$(whoami)

COMM="$HOME/Документы/smpl.sh" #Путь к скрипту На родительском пк
Voc="/home/$pon/Документы" #Путь куда будет перекинут скрипт. !!!СВЯЗАН С COMM. ПРИ ИЗМЕНЕНИИ ПУТИ СОММ ТАК ЖЕ ИЗМЕНИТЕ Voc!!!

#Подсчет количества айпи адресов в файле
ip_count=$(wc -l < "$Ip_l")
echo "Количество IP-адресов в файле: $ip_count"

#Цикл для выполнения основного процесса столько раз, сколько айпи адресов
for ((i=1; i<=ip_count; i++)); do
    ip=$(sed -n "${i}p" "$Ip_l")  # Получаем i-й IP-адрес из файла
    echo "Проверка соединения с $ip..."
    
    #Проверка доступности айпи адреса
    if ping -c 1 "$ip" &> /dev/null; then
        echo "Подключение к $ip..."

        #Определение имени пользователя на удаленном пк
        user=$(ssh -o StrictHostKeyChecking=no "$pon@$ip" "whoami" 2>/dev/null)
        exit_status=$?  #Сохраняем вывод $ после выполнения команды

        if [ $exit_status -eq 0 ]; then
            echo "Определён пользователь: $user"

#Копирование файла на удаленный пк
            scp "$COMM" "$user@$ip:$Voc"
            
            # Сохраняем PID процесса scp

#Выполнение команды на удаленном пк после копирования
            
                 #Ждем завершения scp
                if [ $? -eq 0 ]; then
                    echo "Файл успешно скопирован в $ip"

                    ssh "$user@$ip" "bash $COMM"
                    
                    if [ $? -eq 0 ]; then
                        echo "Команда успешно выполняется на $ip"
                    else
                        echo "Ошибка выполнения команды на $ip"
                    fi
                else
                    echo "Ошибка копирования на $ip"
                fi
            
        else
            echo "Не удалось определить пользователя на $ip"
        fi
    else
        echo "Host $ip не читаем. Пропуск..."
    fi
done

#Ждем завершения всех фоновых процессов(тестирование)
wait

echo "Все операции завершены."
