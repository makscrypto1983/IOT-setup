Инструкция по установке MQTT-сервера (например, Mosquitto) в Docker-контейнере:

### Шаг 1: Убедитесь, что Docker установлен и запущен
Проверьте, что Docker работает, выполнив команду:  
```bash
docker --version
```

Если команда возвращает версию Docker, то всё в порядке.

---

### Шаг 2: Запустите MQTT-сервер с использованием Docker
В данном примере мы будем использовать **Eclipse Mosquitto** — популярный MQTT-брокер.

#### 2.1. Запустите контейнер Mosquitto
Выполните следующую команду, чтобы запустить MQTT-сервер:  
```bash
docker run -d --name mosquitto -p 1883:1883 -p 9001:9001 eclipse-mosquitto
```

- `-d`: Запускает контейнер в фоновом режиме.
- `--name mosquitto`: Присваивает имя контейнеру.
- `-p 1883:1883`: Прокидывает стандартный MQTT-порт.
- `-p 9001:9001`: Прокидывает порт для WebSocket (если потребуется).
- `eclipse-mosquitto`: Имя Docker-образа для Mosquitto.

#### 2.2. Проверьте статус запущенного контейнера
После запуска убедитесь, что контейнер работает:  
```bash
docker ps
```

Вы должны увидеть контейнер с именем `mosquitto` в списке запущенных.

---

### Шаг 3: Настройка Mosquitto (по желанию)
Если требуется настроить сервер, выполните следующие шаги:

#### 3.1. Создайте локальную директорию для конфигурации
Создайте папку для хранения конфигурационных файлов Mosquitto:  
```bash
mkdir -p ~/mosquitto/config ~/mosquitto/data ~/mosquitto/log
```

#### 3.2. Создайте конфигурационный файл
Создайте файл `mosquitto.conf` в папке `~/mosquitto/config`. Например:  
```bash
nano ~/mosquitto/config/mosquitto.conf
```

Добавьте минимальную конфигурацию в файл:
```conf
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
```

Сохраните изменения и закройте файл.

---

#### 3.3. Запустите Mosquitto с использованием конфигурации
Перезапустите контейнер с монтированием локальных папок:  
```bash
docker stop mosquitto
docker rm mosquitto
docker run -d --name mosquitto -p 1883:1883 -p 9001:9001 \
  -v ~/mosquitto/config/mosquitto.conf:/mosquitto/config/mosquitto.conf \
  -v ~/mosquitto/data:/mosquitto/data \
  -v ~/mosquitto/log:/mosquitto/log \
  eclipse-mosquitto
```

---

### Шаг 4: Тестирование MQTT-сервера
Для тестирования MQTT-сервера можно использовать инструмент **MQTT.fx**, **mosquitto_pub** или **mosquitto_sub**.

#### Пример отправки сообщения
Подпишитесь на топик:  
```bash
docker exec -it mosquitto mosquitto_sub -t "test/topic"
```

Опубликуйте сообщение в топике:  
```bash
docker exec -it mosquitto mosquitto_pub -t "test/topic" -m "Hello, MQTT!"
```

Если всё настроено правильно, вы увидите сообщение в терминале подписчика.

