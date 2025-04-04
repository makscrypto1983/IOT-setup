Вот скрипт для установки **ioBroker** в Docker-контейнере на устройстве **Orange Pi 2W** (или любом другом устройстве с ARM-процессором), которое работает под управлением Linux:

---

### **Шаги по установке ioBroker в Docker**

#### **1. Установка Docker**
1. Убедитесь, что у вас установлен Docker. Если нет, выполните следующие команды:

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

2. Проверьте установку:
```bash
docker --version
```

---

#### **2. Установка Docker Compose (если требуется)**
Если вы используете Docker Compose для управления контейнерами, установите его:
```bash
sudo apt install -y docker-compose
```

---

#### **3. Создание папок для данных ioBroker**
Создайте директории на хосте для хранения данных контейнера:
```bash
mkdir -p ~/iobroker-data
```

---

#### **4. Создание файла `docker-compose.yml`**
Создайте файл `docker-compose.yml`:
```bash
nano ~/docker-compose.yml
```

Добавьте в файл следующий код:

```yaml
version: '3.7'

services:
  iobroker:
    image: buanet/iobroker:latest
    container_name: iobroker
    hostname: iobroker
    restart: unless-stopped
    ports:
      - "8081:8081" # ioBroker Web интерфейс
      - "8082:8082" # Admin интерфейс
      - "1883:1883" # MQTT (если потребуется)
    volumes:
      - ~/iobroker-data:/opt/iobroker
    environment:
      - PACKAGES="ffmpeg python3 build-essential" # Установите нужные пакеты (если необходимо)
```

Сохраните файл (`Ctrl+O`, затем `Enter`, потом `Ctrl+X`).

---

#### **5. Запуск ioBroker**
Запустите контейнер через Docker Compose:
```bash
sudo docker-compose -f ~/docker-compose.yml up -d
```

---

#### **6. Проверка работы**
После запуска ioBroker будет доступен через браузер:
```text
http://<IP_устройства>:8081
```

---

### **Особенности настройки для Orange Pi 2W**
- **Архитектура ARM:** Образ `buanet/iobroker:latest` поддерживает ARM, но если возникнут ошибки, попробуйте указать образ, поддерживающий вашу архитектуру (например, `armhf` или `arm64`).
- **Производительность:** Orange Pi 2W — энергоэффективное устройство, поэтому для больших сетей (много Zigbee-устройств или сложных сценариев) может потребоваться оптимизация или использование легких адаптеров.

Если вы столкнетесь с проблемами, напишите, и я помогу их решить!
