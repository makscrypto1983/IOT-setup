Для установки клиента WireGuard в Ubuntu и использования готового конфигурационного файла `client.conf` выполните следующие шаги:

### 1. Установка WireGuard
Откройте терминал и выполните следующие команды:

```bash
sudo apt update
sudo apt install wireguard
```

WireGuard будет установлен вместе с утилитами командной строки.

---

### 2. Подготовка конфигурационного файла
1. Убедитесь, что у вас есть готовый конфигурационный файл `client.conf`. Обычно он выглядит так:
   ```conf
   [Interface]
   PrivateKey = <Ваш_приватный_ключ>
   Address = 10.0.0.2/24
   DNS = 8.8.8.8

   [Peer]
   PublicKey = <Публичный_ключ_сервера>
   Endpoint = <IP_адрес_сервера>:51820
   AllowedIPs = 0.0.0.0/0
   ```

2. Скопируйте этот файл в директорию `/etc/wireguard`:
   ```bash
   sudo cp client.conf /etc/wireguard/
   ```

3. Убедитесь, что права доступа к файлу настроены правильно (чтобы только root имел доступ):
   ```bash
   sudo chmod 600 /etc/wireguard/client.conf
   ```

---

### 3. Запуск WireGuard
Активируйте соединение с помощью следующей команды:

```bash
sudo wg-quick up client
```

- Если всё настроено правильно, соединение будет установлено.
- Чтобы проверить статус соединения, выполните:
  ```bash
  sudo wg
  ```

---

### 4. Отключение WireGuard
Чтобы отключить соединение, выполните:

```bash
sudo wg-quick down client
```

---

### 5. Автозапуск WireGuard при загрузке
Если вы хотите, чтобы WireGuard автоматически запускался при старте системы:

```bash
sudo systemctl enable wg-quick@client
```

---

Если возникнут проблемы, дайте знать, и я помогу разобраться!

Вот пример скрипта `install_wireguard.sh`, который автоматизирует установку WireGuard, копирование конфигурационного файла и настройку подключения:

```sh
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
```

---

### Как использовать этот скрипт:
1. Сохраните код в файл, например, `install_wireguard.sh`.
2. Поместите ваш файл `client.conf` в ту же директорию, где находится скрипт.
3. Сделайте скрипт исполняемым:
   ```bash
   chmod +x install_wireguard.sh
   ```
4. Запустите скрипт с правами root:
   ```bash
   sudo ./install_wireguard.sh
   ```

После выполнения скрипт автоматически установит WireGuard, скопирует конфигурационный файл и запустит подключение.