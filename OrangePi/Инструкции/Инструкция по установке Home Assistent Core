Вначале ставим Docker, потом вот команда для запуска Home Assistant с использованием Docker, настроенная для хранения конфигурации в директории `/home/orangepi/homeassistent`:

```bash
docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Europe/Moscow \
  -v /home/orangepi/homeassistent:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
```

Замените `Europe/Moscow` на ваш корректный временной пояс, если необходимо, и выполните эту команду в терминале. После этого Home Assistant будет доступен по адресу `http://localhost:8123` или `http://<IP_адрес_вашего_сервера>:8123`.
