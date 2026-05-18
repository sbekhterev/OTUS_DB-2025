# Делаем физическую и логическую репликации.

## Физическая репликация:

- Весь стенд собирается в Docker образах или ВМ. Необходимо:
  - Настроить физическую репликации между двумя кластерами базы данных
  - Репликация должна работать использую "слот репликации"
  - Реплика должна отставать от мастера на 5 минут

### Подготовка стенда.

Вместо Docker или ВМ я решил использовать кластер k8s.

1. На основе файлов из 4-го задания готовим конфигурации для кластера. Так же для удобства конфигурирования файлы БД 
   будут смонтированы в ФС машины хоста.

   - [Мастер](./k8s/db-master.yaml)
   - [pvc для мастера](./k8s/db-master-pvc.yaml)
   - [pv для мастера](./k8s/db-master-pv.yaml)
   - [Реплика](./k8s/db-rep.yaml)
   - [pvc для реплики](./k8s/db-rep-pvc.yaml)
   - [pv для реплики](./k8s/db-rep-pv.yaml)

2. На основе подготовленных файлов создаём поды.
    ```
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-master-pv.yaml 
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-master-pvc.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-master.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-rep-pv.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-rep-pvc.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-rep.yaml
   ```
   Через DBeaver проверяем что сервисы доступны. 5433 порт для мастера, 5434 для реплики.

### Настройка мастера

1. Командой: ```microk8s kubectl get pods -o wide``` смотрим в какой подсети и с какими адресами находятся поды.
    ```
    NAME                         READY   STATUS    RESTARTS   AGE    IP            NODE         NOMINATED NODE   READINESS GATES
    db-7865945b57-6fzf2          1/1     Running   27         247d   10.1.79.219   local-vm-1   <none>           <none>
    db-master-666fc487f4-8np4f   1/1     Running   0          10m    10.1.79.200   local-vm-1   <none>           <none>
    db-rep-8684c4c878-57sqg      1/1     Running   0          10m    10.1.79.196   local-vm-1   <none>           <none>
   ```
2. В DBeaver на мастере создаём пользователя: ```CREATE ROLE replica WITH LOGIN REPLICATION PASSWORD '123456789';```
3. В DBeaver на мастере создаём слот репликации: ```SELECT pg_create_physical_replication_slot('replica');```
4. На хостовой машине командой ```sudo vim /data/db-master/pg_hba.conf``` добавляем строку ```host    replication     replica         10.1.79.0/24            scram-sha-256```
5. Применяем изменения и проверяем:
   
    - Подключаемся к поду: ```microk8s kubectl exec -it db-master-666fc487f4-8np4f -- bash```
    - Меняем пользователя на postgres: ```su postgres```
    - Применяем изменения: ```pg_ctl reload```
    - Проверяем: ```pg_isready -h 10.1.79.200 -U replica -d postgres```
      - Ответ: ```10.1.79.200:5432 - accepting connections```

### Настройка реплики

1. Командой ```SHOW data_directory;``` проверяем что путь соответствует тому, что указан в db-rep.yaml.
2. Подключаемся к поду: ```microk8s kubectl exec -it db-rep-8684c4c878-57sqg -- bash```
3. Меняем пользователя на postgres: ```su postgres```
4. Выполняем команду: ```pg_basebackup -h 10.1.79.200 -U replica -p 5432 -D /var/lib/postgresql/data/replica -Fp -Xs -P -R --slot replica```
5. Останавливаем под реплики командой: ```microk8s kubectl scale deployment db-rep --replicas=0```
6. Переходим на хостовой машине в папку ```/data/db-master/``` и удаляем все файлы и паки, кроме папки ```replica```
7. Из папки ```/data/db-master/replica``` копируем всё содержимое в папку ```/data/db-master```
8. Запускаем под ```microk8s kubectl scale deployment db-rep --replicas=1```
9. Для отставания в репликации выполняем команды: 
   ```amplicode sql
    ALTER SYSTEM SET recovery_min_apply_delay = '5min';
    SELECT pg_reload_conf();
    ```

### Проверка

#### На мастере:

    ```
    select * from pg_stat_replication;
    Name            |Value                        |
    ----------------+-----------------------------+
    pid             |108                          |
    usesysid        |16385                        |
    usename         |replica                      |
    application_name|walreceiver                  |
    client_addr     |10.1.79.217                  |
    client_hostname |                             |
    client_port     |43672                        |
    backend_start   |2026-05-18 01:02:55.916 +0300|
    backend_xmin    |                             |
    state           |streaming                    |
    sent_lsn        |0/5000130                    |
    write_lsn       |0/5000130                    |
    flush_lsn       |0/5000130                    |
    replay_lsn      |0/5000130                    |
    write_lag       |                             |
    flush_lag       |                             |
    replay_lag      |                             |
    sync_priority   |0                            |
    sync_state      |async                        |
    reply_time      |2026-05-18 01:32:19.867 +0300|
    ```

#### На реплике:

    ```
    select * from pg_stat_wal_receiver;
    Name                 |Value                                                                                                                                                                                                                                                                                                                                                                  |
    ---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    pid                  |30                                                                                                                                                                                                                                                                                                                                                                     |
    status               |streaming                                                                                                                                                                                                                                                                                                                                                              |
    receive_start_lsn    |0/3000000                                                                                                                                                                                                                                                                                                                                                              |
    receive_start_tli    |1                                                                                                                                                                                                                                                                                                                                                                      |
    written_lsn          |0/5000130                                                                                                                                                                                                                                                                                                                                                              |
    flushed_lsn          |0/5000130                                                                                                                                                                                                                                                                                                                                                              |
    received_tli         |1                                                                                                                                                                                                                                                                                                                                                                      |
    last_msg_send_time   |2026-05-18 01:37:19.964 +0300                                                                                                                                                                                                                                                                                                                                          |
    last_msg_receipt_time|2026-05-18 01:37:19.964 +0300                                                                                                                                                                                                                                                                                                                                          |
    latest_end_lsn       |0/5000130                                                                                                                                                                                                                                                                                                                                                              |
    latest_end_time      |2026-05-18 01:13:19.520 +0300                                                                                                                                                                                                                                                                                                                                          |
    slot_name            |replica                                                                                                                                                                                                                                                                                                                                                                |
    sender_host          |10.1.79.206                                                                                                                                                                                                                                                                                                                                                            |
    sender_port          |5432                                                                                                                                                                                                                                                                                                                                                                   |
    conninfo             |user=replica password=******** channel_binding=prefer dbname=replication host=10.1.79.200 port=5432 fallback_application_name=walreceiver sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable|
    ```

#### Итого:

1. На мастере создаём таблицу и добавляем в неё данные:
    ```
    create table test(id int);
    insert into test values (1),(2),(20);
    ```

2. Через 5 минут проверяем на реплике:
    ```
    select * from test;
    id|
    --+
    1|
    2|
    20|
    ```
      
## Логическая репликация:

- В стенд добавить еще один кластер Postgresql. Необходимо:
  - Создать на первом кластере базу данных, таблицу и наполнить ее данными (на ваше усмотрение)
  - На нем же создать публикацию этой таблицы
  - На новом кластере подписаться на эту публикацию
  - Убедиться что она среплицировалась. Добавить записи в эту таблицу на основном сервере и убедиться, что они видны на 
  логической реплике

### Подготовка стенда.

1. Добавляем файлы конфигурации пода:
    - [Логика](./k8s/db-logic.yaml)
    - [pvc для логика](./k8s/db-logic-pvc.yaml)
    - [pv для логика](./k8s/db-logic-pv.yaml)
2. На основе подготовленных файлов создаём поды.
    ```
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-logic-pv.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-logic-pvc.yaml
    bekh@local-vm-1:~$ microk8s kubectl apply -f db-logic.yaml
   ```
   Через DBeaver проверяем что сервис доступен, используем порт 5435.
3. Переключаем мастер на работу в режиме ```wal_level = logical```:
    ```amplicode sql
    ALTER SYSTEM SET wal_level = logical;
    SELECT pg_reload_conf();
   ```
4. Перезапускаем под ```microk8s kubectl rollout restart deployment db-master``` и проверяем:
    ```
    show wal_level;
    Name     |Value  |
    ---------+-------+
    wal_level|logical|
    ```

### Настройка мастера

1. Создаём новую БД и переключаюсь на неё:
    ```
    create database logic;
   ```
2. Создаю таблицу для репликации:
   ```
    create table logic_delivery (id int, logic text);
    ```
2. Создаём публикацию и выдаём права пользователю на неё:
    ```
    create publication logic_pub for table logic_delivery;
    grant select on logic_delivery TO replica;
    ```

### Настройка получателя

1. Создаём новую БД и переключаюсь на неё:
    ```
    create database logic;
   ```
2. Создаю таблицу для репликации:
   ```
    create table logic_delivery (id int, logic text);
    ```
3. Создаём подписку: 
    ```
    create subscription logic_sub connection 'host=10.1.79.209 port=5432 user=replica password=123456789 dbname=logic' PUBLICATION logic_pub;
    ```

### Проверка

#### На мастере

1. Добавляем данные в таблицу:
    ```
    insert into logic_delivery values (1, 'Первый'), (2, 'Второй'), (3, 'Третьий');
    ```
2. Проверяем:
    ```
    select * from logic_delivery ld ;
    id|logic  |
    --+-------+
    1|Первый |
    2|Второй |
    3|Третьий|
    ```
   
#### На получателе

    ```
    select * from logic_delivery ld ;
    id|logic  |
    --+-------+
    1|Первый |
    2|Второй |
    3|Третьий|
    ```


