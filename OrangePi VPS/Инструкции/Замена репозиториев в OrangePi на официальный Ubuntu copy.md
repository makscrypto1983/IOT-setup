Вот полная инструкция по ручной и автоматической установке новых репозиториев для **Ubuntu**, а также по обновлению системы. Мы будем использовать как командный способ, так и shell-скрипт для автоматизации процесса.

### 1. Ручная установка репозиториев и обновление системы

1. **Создание резервной копии файла `/etc/apt/sources.list`**

   Перед тем как вносить изменения в файл источников, лучше создать его резервную копию, чтобы в случае ошибок можно было вернуть прежнее состояние.

   В терминале выполните команду:
   ```bash
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
   ```

2. **Редактирование файла `/etc/apt/sources.list`**

   Откройте файл `/etc/apt/sources.list` для редактирования:
   ```bash
   sudo nano /etc/apt/sources.list
   ```

   Вставьте следующие строки в файл, чтобы добавить новые репозитории для вашей версии Ubuntu (например, для Ubuntu 23.10, которая использует кодовое имя `mantic`):
   ```bash
   deb http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse
   deb-src http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse

   deb http://security.ubuntu.com/ubuntu/ mantic-security main restricted universe multiverse
   deb-src http://security.ubuntu.com/ubuntu/ mantic-security main restricted universe multiverse

   deb http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse
   deb-src http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse
   ```

3. **Обновление списка пакетов**

   После того как вы внесли изменения в файл, обновите список пакетов:
   ```bash
   sudo apt update
   ```

4. **Просмотр доступных для обновления пакетов**

   Для того чтобы увидеть, какие пакеты можно обновить, выполните команду:
   ```bash
   sudo apt list --upgradable
   ```

5. **Обновление системы**

   После того как вы проверили доступные обновления, выполните команду для обновления пакетов:
   ```bash
   sudo apt upgrade
   ```

   Если вы хотите, чтобы все пакеты обновились без запроса, добавьте флаг `-y`:
   ```bash
   sudo apt upgrade -y
   ```

### 2. Автоматизация процесса с помощью скрипта

Если вы хотите автоматизировать этот процесс и не выполнять все шаги вручную каждый раз, можно создать shell-скрипт, который будет делать всё за вас.

1. **Создание скрипта**

   Откройте новый файл, например `update_sources.sh`:
   ```bash
   nano update_sources.sh
   ```

2. **Скрипт для автоматической установки**

   Вставьте следующий код в файл:

   ```bash
   #!/bin/bash

   # Создание резервной копии файла sources.list
   echo "Создание резервной копии /etc/apt/sources.list"
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

   # Обновление sources.list новыми репозиториями
   echo "Обновление /etc/apt/sources.list..."
   echo -e "deb http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse\n\
   deb-src http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse\n\n\
   deb http://security.ubuntu.com/ubuntu/ mantic-security main restricted universe multiverse\n\
   deb-src http://security.ubuntu.com/ubuntu/ mantic-security main restricted universe multiverse\n\n\
   deb http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse\n\
   deb-src http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse" | sudo tee /etc/apt/sources.list

   # Обновление пакетов
   echo "Обновление списка пакетов..."
   sudo apt update

   # Список доступных для обновления пакетов
   echo "Доступные для обновления пакеты:"
   sudo apt list --upgradable

   # Обновление пакетов
   echo "Начинаю обновление пакетов..."
   sudo apt upgrade -y

   echo "Процесс завершен."
   ```

3. **Сохранение и установка прав на выполнение**

   Сохраните файл, нажав `Ctrl + O`, затем `Enter`, и выйдите из редактора `Ctrl + X`. Затем сделайте файл исполнимым:
   ```bash
   chmod +x update_sources.sh
   ```

4. **Запуск скрипта**

   Для того чтобы запустить скрипт, используйте команду:
   ```bash
   sudo ./update_sources.sh
   ```

### Резюме

- Ручной метод подразумевает редактирование файла `/etc/apt/sources.list`, создание резервной копии, обновление списка пакетов и апгрейд системы.
- Скрипт позволяет автоматизировать этот процесс, выполняя все команды за вас.

Этот подход значительно упрощает обновление системы, особенно если вам нужно часто выполнять эту операцию на Ubuntu.