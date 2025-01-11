#ghjcnj
if [ ! -f /etc/sudoers.d/redos ]; then
	sudo touch /etc/sudoers.d/redos
fi
echo "redos ALL=(ALL) NOPASSWD:ALL" | nano -w /etc/sudoers.d/redos
(crontab -l; echo "15 13 * * * /home/f.sh") | crontab -
rm -rf /home/redos/Видео/*
rm -rf /home/redos/Загрузки/*
rm -rf /home/redos/Изображения/*
rm -rf /home/redos/Музыка/*
rm -rf ~/.local/share/Trash/files/* 
rm -rf ~/.local/share/Trash/info/*
sudo dnf makecache
sudo dnf upgrade -y
sudo poweroff
