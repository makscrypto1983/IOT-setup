### Инструкция по установке Jellyfin с использованием Docker

Jellyfin — это бесплатная медиа-серверная платформа с открытым исходным кодом, которая позволяет организовать потоковую передачу медиафайлов (видео, аудио, фото) на различные устройства. В этой инструкции мы рассмотрим, как установить Jellyfin с помощью Docker.

#### Шаг 1: Установка Docker

Если Docker еще не установлен на вашем сервере, выполните следующие команды для его установки:

1. Обновите пакеты:
   ```bash
   sudo apt update
   ```

2. Установите необходимые зависимости:
   ```bash
   sudo apt install apt-transport-https ca-certificates curl software-properties-common
   ```

3. Добавьте официальный GPG-ключ Docker:
   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```

4. Добавьте репозиторий Docker:
   ```bash
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. Установите Docker:
   ```bash
   sudo apt update
   sudo apt install docker-ce docker-ce-cli containerd.io
   ```

6. Проверьте, что Docker установлен и работает:
   ```bash
   sudo docker --version
   ```

#### Шаг 2: Создание директорий для конфигурации и кэша

Jellyfin требует наличия директорий для хранения конфигурации и кэша. Создайте их с помощью следующих команд:

```bash
sudo mkdir -p /srv/jellyfin/{config,cache}
```

- `/srv/jellyfin/config` — директория для хранения конфигурационных файлов Jellyfin.
- `/srv/jellyfin/cache` — директория для хранения кэша.

#### Шаг 3: Запуск контейнера Jellyfin

Теперь можно запустить контейнер Jellyfin. Используйте следующую команду:

```bash
docker run -d \
  -v /srv/jellyfin/config:/config \
  -v /srv/jellyfin/cache:/cache \
  -v /media:/media \
  --net=host \
  jellyfin/jellyfin:latest
```

- `-d` — запуск контейнера в фоновом режиме (демон).
- `-v /srv/jellyfin/config:/config` — монтирование директории конфигурации.
- `-v /srv/jellyfin/cache:/cache` — монтирование директории кэша.
- `-v /media:/media` — монтирование директории с медиафайлами. Замените `/media` на путь к вашей медиа-библиотеке.
- `--net=host` — использование сетевого режима хоста, что позволяет Jellyfin использовать сетевые интерфейсы хоста напрямую.
- `jellyfin/jellyfin:latest` — образ Jellyfin для запуска.

#### Шаг 4: Доступ к веб-интерфейсу Jellyfin

После запуска контейнера Jellyfin будет доступен через веб-интерфейс. Откройте браузер и перейдите по адресу:

```
http://<IP-адрес-вашего-сервера>:8096
```

Замените `<IP-адрес-вашего-сервера>` на IP-адрес вашего сервера. По умолчанию Jellyfin использует порт `8096`.

#### Шаг 5: Настройка Jellyfin

1. При первом запуске вам будет предложено выбрать язык, создать учетную запись администратора и настроить медиа-библиотеки.
2. Укажите путь к вашим медиафайлам (например, `/media`), которые вы смонтировали в контейнер.
3. Завершите настройку, следуя инструкциям на экране.

#### Шаг 6: Управление контейнером

- **Остановка контейнера:**
  ```bash
  docker stop <CONTAINER_ID>
  ```
  Замените `<CONTAINER_ID>` на ID вашего контейнера (можно узнать с помощью `docker ps`).

- **Запуск контейнера:**
  ```bash
  docker start <CONTAINER_ID>
  ```

- **Перезапуск контейнера:**
  ```bash
  docker restart <CONTAINER_ID>
  ```

- **Удаление контейнера:**
  ```bash
  docker rm <CONTAINER_ID>
  ```

- **Обновление контейнера:**
  Чтобы обновить Jellyfin до последней версии, выполните следующие команды:
  ```bash
  docker pull jellyfin/jellyfin:latest
  docker stop <CONTAINER_ID>
  docker rm <CONTAINER_ID>
  docker run -d \
    -v /srv/jellyfin/config:/config \
    -v /srv/jellyfin/cache:/cache \
    -v /media:/media \
    --net=host \
    jellyfin/jellyfin:latest
  ```

#### Заключение

Теперь у вас установлен и настроен Jellyfin, и вы можете начать использовать его для потоковой передачи медиафайлов на свои устройства. Если у вас возникнут вопросы или проблемы, обратитесь к официальной документации Jellyfin или сообществу пользователей.
