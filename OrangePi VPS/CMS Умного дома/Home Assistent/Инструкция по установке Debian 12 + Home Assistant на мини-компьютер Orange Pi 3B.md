### Инструкция по установке Debian 12 + Home Assistant на мини-компьютер Orange Pi 3B

---

### Оборудование:
1. **Мини-компьютер**: Orange Pi (например, 3B).  
2. **Память**: eMMC модуль Orange Pi или NVMe.  
3. **Карточка microSD**: минимум 16 ГБ.  
4. **Персональный компьютер** (например, Windows).  
5. **Картридер** для работы с microSD.  
6. **Корпус с охлаждением** для Orange Pi (по желанию).  
7. **Кабели**:  
   - USB Type-C для питания,  
   - HDMI для вывода изображения.  
8. **Сетевой кабель** для подключения к роутеру.  
9. **Монитор** с HDMI (опционально).  

---

### Программное обеспечение:
- **SD Memory Card Formatter**: для форматирования microSD.  
- **Balena Etcher**: для записи образа ОС на microSD.  
- **PuTTY**: для работы по SSH.  
- **WinSCP**: для передачи файлов по SCP.  

---

### Этапы установки

#### 1. Подготовка microSD и загрузка образа
1. Скачайте образ **Debian 12 Bookworm server** с официального сайта Orange Pi:  
   Раздел **Download > Official Images > Debian Images**.  
   Пример имени файла: `Orangepi3b_1.0.6_debian_bookworm_server_linux5.10.160.7z`.  
2. Подключите microSD к ПК и отформатируйте с помощью **SD Memory Card Formatter**.  
3. Распакуйте скачанный образ (формат `7z`) и запишите его на microSD с помощью **Balena Etcher**.  
4. После записи извлеките microSD и вставьте её в Orange Pi.  

---

#### 2. Первая загрузка Orange Pi
1. Подключите:  
   - microSD в Orange Pi,  
   - сетевой кабель к роутеру,  
   - HDMI кабель к монитору (опционально).  
2. Подключите питание через USB Type-C.  
3. Подождите, пока устройство загрузится, и найдите его IP-адрес:  
   - Посмотрите список выданных IP в настройках роутера.  

---

#### 3. Подготовка eMMC или NVMe
1. Подключитесь по SSH (например, через **PuTTY**):  
   ```bash
   ssh orangepi@<IP-адрес>
   ```
2. Убедитесь, что eMMC или NVMe распознаётся системой:  
   - Для eMMC:  
     ```bash
     lsblk
     ```
   - Для NVMe:  
     ```bash
     lspci
     ```
3. Скопируйте распакованный образ Debian (формат `.img`) на Orange Pi через **WinSCP** (в каталог `/home/orangepi`).  

---

#### 4. Установка образа на eMMC
1. Проверьте наличие файла образа:  
   ```bash
   ls
   ```
2. Занулите память eMMC:  
   ```bash
   sudo dd bs=1M if=/dev/zero of=/dev/mmcblk0 count=1000 status=progress
   sudo sync
   ```
3. Установите образ на eMMC:  
   ```bash
   sudo dd bs=1M if=<имя_образа>.img of=/dev/mmcblk0 status=progress
   sudo sync
   ```
4. Выключите устройство:  
   ```bash
   sudo poweroff
   ```
5. Извлеките microSD и загрузите устройство для проверки.  

---

### Установка Home Assistant

#### 1. Подключение и обновление
1. Подключитесь к Orange Pi по SSH.  
2. Обновите систему:  
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

---

#### 2. Установка зависимостей
1. Установите требуемые пакеты:  
   ```bash
   sudo apt install -y \
   apparmor bluez cifs-utils curl dbus jq \
   libglib2.0-bin lsb-release network-manager \
   nfs-common systemd-journal-remote systemd-resolved \
   udisks2 wget
   ```
2. Перезагрузите систему:  
   ```bash
   sudo reboot
   ```

---

#### 3. Установка Docker
1. Скачайте и установите Docker:  
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh ./get-docker.sh
   ```

---

#### 4. Установка OS Agent
1. Скачайте актуальный агент Home Assistant:  
   Перейдите на [страницу релизов OS Agent](https://github.com/home-assistant/os-agent/releases) и найдите версию для `aarch64`.  
   Пример команды:  
   ```bash
   wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb
   ```
2. Установите пакет:  
   ```bash
   sudo dpkg -i os-agent_1.6.0_linux_aarch64.deb
   ```

---

#### 5. Установка Home Assistant
1. Скачайте установщик:  
   ```bash
   wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
   ```
2. Установите Home Assistant:  
   ```bash
   sudo apt install ./homeassistant-supervised.deb
   ```
3. При запросе выберите архитектуру **`raspberrypi4-64`**.  

---

### Завершение
1. После установки дождитесь появления ссылки на веб-интерфейс (может занять до 25 минут).  
2. Проверьте состояние устройства:  
   ```bash
   htop
   ```
3. Перейдите в браузер по указанному адресу (обычно: `http://<IP-адрес>:8123`).  

Если возникнут проблемы, сверяйтесь с [официальной документацией](https://www.home-assistant.io/installation/).
