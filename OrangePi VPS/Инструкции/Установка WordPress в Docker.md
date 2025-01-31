### 1. Подготовка сервера
Убедитесь, что на вашем VPS установлены Docker и Docker Compose. Если нет, выполните следующие команды:

```bash
# Установка Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Установка Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')" /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

---

### 2. Создание директории для проекта
Создайте директорию для вашего проекта WordPress:

```bash
mkdir ~/wordpress
cd ~/wordpress
```

---

### 3. Создание `docker-compose.yml`
Создайте файл `docker-compose.yml`:

```bash
nano docker-compose.yml
```

Вставьте следующий код:

```yaml
version: '3.8'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      # Настройки PHP для увеличения лимита загрузки файлов
      PHP_UPLOAD_MAX_FILESIZE: 512M
      PHP_POST_MAX_SIZE: 512M
      PHP_MEMORY_LIMIT: 512M
      PHP_MAX_EXECUTION_TIME: 300
      PHP_MAX_INPUT_TIME: 300
    volumes:
      - ./wp-content:/var/www/html/wp-content
      # Монтируем кастомный php.ini (опционально)
      - ./php.ini:/usr/local/etc/php/conf.d/uploads.ini

volumes:
  db_data:
```

#### Пояснение:
- **`PHP_UPLOAD_MAX_FILESIZE`**: Максимальный размер загружаемого файла (установлен на 512 МБ).
- **`PHP_POST_MAX_SIZE`**: Максимальный размер данных, отправляемых через POST (установлен на 512 МБ).
- **`PHP_MEMORY_LIMIT`**: Лимит памяти для PHP (установлен на 512 МБ).
- **`PHP_MAX_EXECUTION_TIME`** и **`PHP_MAX_INPUT_TIME`**: Время выполнения скриптов (установлено на 300 секунд).
- **`volumes`**: Монтирование кастомного `php.ini` (опционально, см. шаг 4).

---

### 4. Создание кастомного `php.ini` (опционально)
Если вы хотите использовать кастомный `php.ini`, создайте файл `php.ini` в той же директории, где находится `docker-compose.yml`:

```bash
nano php.ini
```

Вставьте следующие параметры:

```ini
upload_max_filesize = 512M
post_max_size = 512M
memory_limit = 512M
max_execution_time = 300
max_input_time = 300
```

Этот файл будет автоматически подключен к контейнеру WordPress через монтирование в `docker-compose.yml`.

---

### 5. Запуск контейнеров
Запустите контейнеры с помощью Docker Compose:

```bash
docker-compose up -d
```

Эта команда:
- Скачает образы WordPress и MySQL.
- Запустит контейнеры с указанными настройками.

---

### 6. Настройка WordPress
1. Откройте браузер и перейдите по адресу `http://your_server_ip` (замените `your_server_ip` на IP-адрес вашего VPS).
2. Вы увидите начальную страницу установки WordPress.
3. Следуйте инструкциям на экране, чтобы завершить установку.

---

### 7. Проверка лимита загрузки файлов
После установки WordPress проверьте, что лимит загрузки файлов увеличен:
1. Перейдите в админку WordPress.
2. Откройте раздел **Инструменты → Здоровье сайта → Информация**.
3. Найдите раздел **PHP** и проверьте значения:
   - `upload_max_filesize`
   - `post_max_size`

Оба параметра должны быть равны `512M`.

---

### 8. Управление контейнерами
- **Остановка контейнеров:**
  ```bash
  docker-compose down
  ```

- **Запуск контейнеров:**
  ```bash
  docker-compose up -d
  ```

- **Просмотр логов:**
  ```bash
  docker-compose logs -f
  ```

---

### 9. Резервное копирование и восстановление
- **Резервное копирование базы данных:**
  ```bash
  docker exec -i $(docker-compose ps -q db) mysqldump -u wordpress -pwordpress wordpress > backup.sql
  ```

- **Восстановление базы данных:**
  ```bash
  docker exec -i $(docker-compose ps -q db) mysql -u wordpress -pwordpress wordpress < backup.sql
  ```

---

### 10. Обновление WordPress
Чтобы обновить WordPress до последней версии, выполните:

```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

---

### Заключение
Теперь у вас есть WordPress с увеличенным лимитом на загрузку файлов (512 МБ), настроенный в Docker. Вы можете изменить размер лимита, отредактировав параметры в `docker-compose.yml` или `php.ini`.
