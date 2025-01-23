### Подробная инструкция на русском языке

---

#### **Шаг 1. Запись образа Linux на карту памяти TF**
1. Скачайте образ Linux для вашей платы Orange Pi с официального сайта [www.orangepi.cn](http://www.orangepi.cn).  
2. Используйте программу, например, `Etcher` или `dd`, чтобы записать скачанный образ на карту памяти TF.  
3. После завершения записи извлеките карту памяти из устройства.

---

#### **Шаг 2. Подключение карты памяти TF к Ubuntu**
1. Вставьте карту памяти TF с записанным образом Linux в картридер. Затем подключите картридер к компьютеру с Ubuntu.  
2. Ubuntu автоматически смонтирует файловую систему Linux с карты памяти.  
3. Проверьте точку монтирования с помощью команды:
   ```bash
   df -h | grep "media"
   ```
   Например, результат может быть таким:
   ```bash
   /dev/sdd1 1.4G 1.2G 167M 88% /media/test/opi_root
   ```
4. Убедитесь, что в точке монтирования видны стандартные папки Linux, используя команду:
   ```bash
   ls /media/test/opi_root
   ```
   Вывод должен быть примерно таким:
   ```
   bin boot dev etc home lib lost+found media mnt opt proc root run
   sbin selinux srv sys tmp usr var
   ```

---

#### **Шаг 3. Настройка сети на плате Orange Pi**
1. Перейдите в директорию `/boot`:
   ```bash
   cd /media/test/opi_root/boot/
   ```
2. Скопируйте файл шаблона для настройки сети:
   ```bash
   sudo cp orangepi_first_run.txt.template orangepi_first_run.txt
   ```
3. Откройте файл настроек для редактирования:
   ```bash
   sudo vim orangepi_first_run.txt
   ```

---

#### **Шаг 4. Параметры файла `orangepi_first_run.txt`**
- **Основные переменные**:
  - `FR_general_delete_this_file_after_completion`:  
    Указывает, нужно ли удалять файл после первого запуска системы.  
    Значение по умолчанию: `1` (удалить). Если `0`, файл переименуется в `orangepi_first_run.txt.old`.  
  - `FR_net_change_defaults`:  
    Включение изменения настроек сети. Установите `1`, чтобы включить.  
  - `FR_net_ethernet_enabled`:  
    Включение настройки Ethernet. Установите `1`, чтобы активировать Ethernet.  
  - `FR_net_wifi_enabled`:  
    Включение настройки Wi-Fi. Установите `1`, чтобы подключиться к Wi-Fi.  
    ⚠️ Если `FR_net_wifi_enabled=1`, настройки Ethernet игнорируются.  
  - `FR_net_wifi_ssid`:  
    Имя Wi-Fi сети, к которой нужно подключиться.  
  - `FR_net_wifi_key`:  
    Пароль Wi-Fi сети.  
  - `FR_net_use_static`:  
    Установите `1`, если хотите использовать статический IP.  
  - `FR_net_static_ip`:  
    Статический IP-адрес.  
  - `FR_net_static_gateway`:  
    Шлюз (gateway).  

---

#### **Примеры настройки файла `orangepi_first_run.txt`**
1. **Подключение к Wi-Fi**:
   ```txt
   FR_net_change_defaults=1
   FR_net_wifi_enabled=1
   FR_net_wifi_ssid=MyWiFi
   FR_net_wifi_key=MyPassword
   ```
2. **Подключение к Wi-Fi со статическим IP**:
   ```txt
   FR_net_change_defaults=1
   FR_net_wifi_enabled=1
   FR_net_wifi_ssid=MyWiFi
   FR_net_wifi_key=MyPassword
   FR_net_use_static=1
   FR_net_static_ip=192.168.1.100
   FR_net_static_gateway=192.168.1.1
   ```
3. **Настройка Ethernet с использованием статического IP**:
   ```txt
   FR_net_change_defaults=1
   FR_net_ethernet_enabled=1
   FR_net_use_static=1
   FR_net_static_ip=192.168.1.101
   FR_net_static_gateway=192.168.1.1
   ```

---

#### **Шаг 5. Завершение настройки**
1. Сохраните изменения в файле `orangepi_first_run.txt` и закройте редактор.  
2. Извлеките карту памяти TF из компьютера с Ubuntu.  
3. Вставьте карту памяти в плату Orange Pi и включите её.

---

#### **Шаг 6. Проверка IP-адреса и подключение по SSH**
1. Если вы задали статический IP, выполните команду `ping`, чтобы проверить соединение:
   ```bash
   ping 192.168.1.100
   ```
   Если пинг проходит, система настроена корректно.  
2. Для подключения к плате используйте команду SSH:
   ```bash
   ssh orangepi@192.168.1.100
   ```
   Введите пароль. По умолчанию пароль: `orangepi`.  

---

#### **Примечание**
После первого запуска файл `orangepi_first_run.txt` будет автоматически удалён или переименован в `orangepi_first_run.txt.old`, и изменения в нём больше не будут применяться. Если потребуется повторная настройка, нужно будет заново записать образ Linux на карту памяти.