# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.

Основные приемущества применения на практике паттернов IaaC: повторяемость описанных как код сред для разработки, тестирования и продашен; ускорение вывода продукта на рынок, путем автоматизации 
подготовки инфраструктуры; ускорение процесса разработки, как следствие автоматизации создания сред для разработки и тестирования, что позволяет реализовать принципы CI\CD/

- Какой из принципов IaaC является основополагающим?

Принцип идемпотентности - возможности получения одинакового результата при одинаковых исходных данных, в частности при использовании принципа IaaC это означает, что инфраструктура, единожды описанная в виде кода, будет всегда одинаково воспроизводимой. 

## Задача 2

- Чем Ansible выгодно отличается от других систем управления конфигурациями?

Ansible выгодно отличается от других систем управления конфигурациями возможностью использования текущей SSH-инфраструктуры (не требует развертывания какой-то специальной PKI),
возможность подключения модулей и использование декларативного метода описания конфигураций.

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

На мой взгляд более надежный метод push, тк не требует установки дополнительных агентов на настраиваемых системах и работает через надежный протокол SSH.

## Задача 3

Установить на личный компьютер:

- VirtualBox
```commandline
vitalykay@sams:~/vagrantiaac$ sudo apt install virtualbox
Чтение списков пакетов… Готово
Построение дерева зависимостей       
Чтение информации о состоянии… Готово
Уже установлен пакет virtualbox самой новой версии (6.1.26-dfsg-3~ubuntu1.20.04.2).
Обновлено 0 пакетов, установлено 0 новых пакетов, для удаления отмечено 0 пакетов, и 65 пакетов не обновлено.
```
- Vagrant
```commandline
vitalykay@sams:~/vagrantiaac$ sudo apt install vagrant
Чтение списков пакетов… Готово
Построение дерева зависимостей       
Чтение информации о состоянии… Готово
Уже установлен пакет vagrant самой новой версии (2.2.6+dfsg-2ubuntu3).
Обновлено 0 пакетов, установлено 0 новых пакетов, для удаления отмечено 0 пакетов, и 65 пакетов не обновлено.
```
- Ansible
```commandline
vitalykay@sams:~/vagrantiaac$ sudo apt install ansible
Чтение списков пакетов… Готово
Построение дерева зависимостей       
Чтение информации о состоянии… Готово
Будут установлены следующие дополнительные пакеты:
  ieee-data python3-argcomplete python3-crypto python3-dnspython
  python3-jinja2 python3-jmespath python3-kerberos python3-libcloud
  python3-netaddr python3-ntlm-auth python3-requests-kerberos
  python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict
Предлагаемые пакеты:
  cowsay sshpass python-jinja2-doc ipython3 python-netaddr-docs
Следующие НОВЫЕ пакеты будут установлены:
  ansible ieee-data python3-argcomplete python3-crypto python3-dnspython
  python3-jinja2 python3-jmespath python3-kerberos python3-libcloud
  python3-netaddr python3-ntlm-auth python3-requests-kerberos
  python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict
Обновлено 0 пакетов, установлено 16 новых пакетов, для удаления отмечено 0 пакетов, и 65 пакетов не обновлено.
Необходимо скачать 9 725 kB архивов.
После данной операции объём занятого дискового пространства возрастёт на 90,6 MB.
Хотите продолжить? [Д/н] y
Пол:1 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 python3-jinja2 all 2.10.1-2 [95,5 kB]
Пол:2 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 python3-crypto amd64 2.6.1-13ubuntu2 [237 kB]
Пол:3 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 python3-dnspython all 1.16.0-1build1 [89,1 kB]
Пол:4 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 ieee-data all 20180805.1 [1 589 kB]
Пол:5 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 python3-netaddr all 0.7.19-3ubuntu1 [236 kB]
Пол:6 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 ansible all 2.9.6+dfsg-1 [5 794 kB]
Пол:7 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-argcomplete all 1.8.1-1.3ubuntu1 [27,2 kB]
Пол:8 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 python3-jmespath all 0.9.4-2ubuntu1 [21,5 kB]
Пол:9 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-kerberos amd64 1.1.14-3.1build1 [22,6 kB]
Пол:10 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-libcloud all 2.8.0-1 [1 403 kB]
Пол:11 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-ntlm-auth all 1.1.0-1 [19,6 kB]
Пол:12 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-requests-kerberos all 0.12.0-2 [11,9 kB]
Пол:13 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-requests-ntlm all 1.1.0-1 [6 004 B]
Пол:14 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-selinux amd64 3.0-1build2 [139 kB]
Пол:15 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-xmltodict all 0.12.0-1 [12,6 kB]
Пол:16 http://ru.archive.ubuntu.com/ubuntu focal/universe amd64 python3-winrm all 0.3.0-2 [21,7 kB]
Получено 9 725 kB за 11с (907 kB/s)                                            
Выбор ранее не выбранного пакета python3-jinja2.
(Чтение базы данных … на данный момент установлено 241039 файлов и каталогов.)
Подготовка к распаковке …/00-python3-jinja2_2.10.1-2_all.deb …
Распаковывается python3-jinja2 (2.10.1-2) …
Выбор ранее не выбранного пакета python3-crypto.
Подготовка к распаковке …/01-python3-crypto_2.6.1-13ubuntu2_amd64.deb …
Распаковывается python3-crypto (2.6.1-13ubuntu2) …
Выбор ранее не выбранного пакета python3-dnspython.
Подготовка к распаковке …/02-python3-dnspython_1.16.0-1build1_all.deb …
Распаковывается python3-dnspython (1.16.0-1build1) …
Выбор ранее не выбранного пакета ieee-data.
Подготовка к распаковке …/03-ieee-data_20180805.1_all.deb …
Распаковывается ieee-data (20180805.1) …
Выбор ранее не выбранного пакета python3-netaddr.
Подготовка к распаковке …/04-python3-netaddr_0.7.19-3ubuntu1_all.deb …
Распаковывается python3-netaddr (0.7.19-3ubuntu1) …
Выбор ранее не выбранного пакета ansible.
Подготовка к распаковке …/05-ansible_2.9.6+dfsg-1_all.deb …
Распаковывается ansible (2.9.6+dfsg-1) …
Выбор ранее не выбранного пакета python3-argcomplete.
Подготовка к распаковке …/06-python3-argcomplete_1.8.1-1.3ubuntu1_all.deb …
Распаковывается python3-argcomplete (1.8.1-1.3ubuntu1) …
Выбор ранее не выбранного пакета python3-jmespath.
Подготовка к распаковке …/07-python3-jmespath_0.9.4-2ubuntu1_all.deb …
Распаковывается python3-jmespath (0.9.4-2ubuntu1) …
Выбор ранее не выбранного пакета python3-kerberos.
Подготовка к распаковке …/08-python3-kerberos_1.1.14-3.1build1_amd64.deb …
Распаковывается python3-kerberos (1.1.14-3.1build1) …
Выбор ранее не выбранного пакета python3-libcloud.
Подготовка к распаковке …/09-python3-libcloud_2.8.0-1_all.deb …
Распаковывается python3-libcloud (2.8.0-1) …
Выбор ранее не выбранного пакета python3-ntlm-auth.
Подготовка к распаковке …/10-python3-ntlm-auth_1.1.0-1_all.deb …
Распаковывается python3-ntlm-auth (1.1.0-1) …
Выбор ранее не выбранного пакета python3-requests-kerberos.
Подготовка к распаковке …/11-python3-requests-kerberos_0.12.0-2_all.deb …
Распаковывается python3-requests-kerberos (0.12.0-2) …
Выбор ранее не выбранного пакета python3-requests-ntlm.
Подготовка к распаковке …/12-python3-requests-ntlm_1.1.0-1_all.deb …
Распаковывается python3-requests-ntlm (1.1.0-1) …
Выбор ранее не выбранного пакета python3-selinux.
Подготовка к распаковке …/13-python3-selinux_3.0-1build2_amd64.deb …
Распаковывается python3-selinux (3.0-1build2) …
Выбор ранее не выбранного пакета python3-xmltodict.
Подготовка к распаковке …/14-python3-xmltodict_0.12.0-1_all.deb …
Распаковывается python3-xmltodict (0.12.0-1) …
Выбор ранее не выбранного пакета python3-winrm.
Подготовка к распаковке …/15-python3-winrm_0.3.0-2_all.deb …
Распаковывается python3-winrm (0.3.0-2) …
Настраивается пакет python3-ntlm-auth (1.1.0-1) …
Настраивается пакет python3-kerberos (1.1.14-3.1build1) …
Настраивается пакет python3-xmltodict (0.12.0-1) …
Настраивается пакет python3-jinja2 (2.10.1-2) …
Настраивается пакет python3-jmespath (0.9.4-2ubuntu1) …
Настраивается пакет python3-requests-kerberos (0.12.0-2) …
Настраивается пакет ieee-data (20180805.1) …
Настраивается пакет python3-dnspython (1.16.0-1build1) …
Настраивается пакет python3-selinux (3.0-1build2) …
Настраивается пакет python3-crypto (2.6.1-13ubuntu2) …
Настраивается пакет python3-argcomplete (1.8.1-1.3ubuntu1) …
Настраивается пакет python3-requests-ntlm (1.1.0-1) …
Настраивается пакет python3-libcloud (2.8.0-1) …
Настраивается пакет python3-netaddr (0.7.19-3ubuntu1) …
Настраивается пакет python3-winrm (0.3.0-2) …
Настраивается пакет ansible (2.9.6+dfsg-1) …
Обрабатываются триггеры для man-db (2.9.1-1) …

```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
vitalykay@sams:~/virt-homeworks/05-virt-02-iaac/src/vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/vitalykay/virt-homeworks/05-virt-02-iaac/src/vagrant
==> server1.netology: Running provisioner: ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.9.6).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: If you are using a module and expect the file to exist on the remote, see the remote_src option
fatal: [server1.netology]: FAILED! => {"changed": false, "msg": "Could not find or access '~/.ssh/id_rsa.pub' on the Ansible Controller.\nIf you are using a module and expect the file to exist on the remote, see the remote_src option"}
...ignoring

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   

vitalykay@sams:~/virt-homeworks/05-virt-02-iaac/src/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 21 Jan 2022 01:50:29 PM UTC

  System load:  0.76               Users logged in:          0
  Usage of /:   13.2% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.192.11
  Processes:    114


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Jan 21 13:50:11 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```