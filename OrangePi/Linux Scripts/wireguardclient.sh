#!/bin/bash

# Скрипт для установки клиента WireGuard и настройки подключения
# Автор: ChatGPT

# Проверка, запущен ли скрипт с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root (sudo)." >&2
  exit 1
fi

echo "Обновление списка пакетов..."
apt update

echo "Установка WireGuard..."
apt install -y wireguard

# Проверка, есть ли файл client.conf в текущей директории
CONFIG_FILE="client.conf"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Ошибка: Файл $CONFIG_FILE не найден в текущей директории." >&2
  exit 1
fi

echo "Копирование конфигурационного файла в /etc/wireguard..."
cp "$CONFIG_FILE" /etc/wireguard/

echo "Установка прав доступа для конфигурационного файла..."
chmod 600 /etc/wireguard/client.conf

echo "Запуск подключения WireGuard..."
wg-quick up client

echo "Настройка автозапуска при загрузке системы..."
systemctl enable wg-quick@client

echo "Установка завершена. Проверяем статус подключения:"
wg

echo "Готово!"