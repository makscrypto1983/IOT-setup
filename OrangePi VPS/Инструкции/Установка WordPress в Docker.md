 

### **Создание скрипта установки WordPress**
Создайте файл `install_wordpress.sh`:  

```bash
nano install_wordpress.sh
```

Вставьте этот код:  

```sh
#!/bin/bash

# Переменные
DB_NAME="wordpress"
DB_USER="имя пользователя"
DB_PASSWORD="пароль"
WP_ADMIN_USER="логин"
WP_ADMIN_PASSWORD="пароль"
WP_CONTAINER="wordpress"
DB_CONTAINER="wordpress-db"

# Определяем IP сервера
SERVER_IP=$(hostname -I | awk '{print $1}')

# Проверка и установка Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не найден. Устанавливаю..."
    curl -fsSL https://get.docker.com | sh
    sudo systemctl enable --now docker
    echo "Docker установлен."
fi

# Запуск контейнера с MariaDB
echo "Запускаем контейнер с MariaDB..."
docker run -d \
  --name $DB_CONTAINER \
  -e MYSQL_ROOT_PASSWORD=$DB_PASSWORD \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -v wordpress_db_data:/var/lib/mysql \
  --restart unless-stopped \
  mariadb:latest

# Ждем несколько секунд, чтобы база данных успела запуститься
sleep 10

# Запуск контейнера с WordPress
echo "Запускаем контейнер с WordPress..."
docker run -d \
  --name $WP_CONTAINER \
  --link $DB_CONTAINER:mysql \
  -e WORDPRESS_DB_HOST=$DB_CONTAINER:3306 \
  -e WORDPRESS_DB_USER=$DB_USER \
  -e WORDPRESS_DB_PASSWORD=$DB_PASSWORD \
  -e WORDPRESS_DB_NAME=$DB_NAME \
  -v wordpress_data:/var/www/html \
  -p 80:80 \
  --restart unless-stopped \
  wordpress:latest

# Вывод информации об установке
echo -e "\n✅ WordPress успешно установлен!"
echo -e "🌍 Сайт доступен по адресу: http://$SERVER_IP"
echo -e "🔑 Панель администратора: http://$SERVER_IP/wp-admin"

exit 0
```

### **2. Дать права на выполнение**
```bash
chmod +x install_wordpress.sh
```

### **3. Запуск скрипта**
```bash
./install_wordpress.sh
```

После успешного выполнения скрипта в конце появятся ссылки на сайт и админку.  
