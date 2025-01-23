### Инструкция по установке Docker и Portainer

#### Шаг 1. Установка Docker
1. **Обновите список пакетов и установите зависимости**:
   ```bash
   sudo apt update
   sudo apt upgrade -y
   sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https
   ```

2. **Добавьте ключ GPG для репозитория Docker**:
   Убедитесь, что ключ добавлен правильно:
   ```bash
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

3. **Добавьте репозиторий Docker**:
   ```bash
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

4. **Очистите кеш APT и обновите список пакетов**:
   ```bash
   sudo apt clean
   sudo rm -rf /var/lib/apt/lists/*
   sudo apt update
   ```

5. **Установите Docker**:
   ```bash
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

6. **Проверьте версию Docker**:
   ```bash
   docker --version
   ```

7. **Добавьте текущего пользователя в группу `docker` (чтобы запускать команды без `sudo`)**:
   ```bash
   sudo usermod -aG docker $USER
   ```
   Затем выйдите из сеанса и снова войдите.

8. **Запустите и включите Docker**:
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

---

#### Шаг 2. Установка Portainer
1. **Создайте том для данных Portainer**:
   ```bash
   docker volume create portainer_data
   ```

2. **Запустите контейнер Portainer**:
   ```bash
   docker run -d -p 8000:8000 -p 9443:9443 --name=portainer \
   --restart=always \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -v portainer_data:/data \
   portainer/portainer-ce:latest
   ```

3. **Проверьте, работает ли контейнер**:
   ```bash
   docker ps
   ```

4. **Откройте веб-интерфейс Portainer**:
   - Перейдите в браузере по адресу: `https://<IP-адрес вашего устройства>:9443`.
   - Настройте пароль администратора и выполните первую настройку.

---

### Примечания
- **Для ARM-устройств** (например, Orange Pi) образ `portainer/portainer-ce` также подходит. Docker автоматически подберет совместимую версию.
- Если в процессе установки появляются новые ошибки, всегда можно выполнить команды `sudo apt clean` и повторить шаги по добавлению репозитория.

Теперь Docker и Portainer установлены и готовы к работе! 🚀
