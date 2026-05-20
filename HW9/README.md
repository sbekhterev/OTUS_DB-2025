# Внутренняя архитектура MySQL

## Создаем базу данных MySQL в докере

### Цель: Упаковать скрипы создания БД в контейнер.

#### Описание/Пошаговая инструкция выполнения домашнего задания:
- забрать стартовый репозиторий https://github.com/aeuge/otus-mysql-docker
- прописать sql скрипт для создания своей БД в init.sql
- проверить запуск и работу контейнера следуя описанию в репозитории

#### Задания повышенной сложности:
- прописать кастомный конфиг - настроить innodb_buffer_pool и другие параметры по желанию
- протестить сисбенчем - результат теста приложить в README

## Основные задания

### Забрать стартовый репозиторий

- Скачиваем архив и распаковываем его: ```wget https://github.com/aeuge/otus-mysql-docker/archive/refs/heads/master.zip && unzip ./master.zip```

### Прописать sql скрипт для создания своей БД в init.sql

- Написан скрипт [init.sql](otus-mysql-docker-master/init.sql), который создаёт пользователя, выдаёт ему права на 
таблицы, так же создаёт таблицы.

### Проверить запуск и работу контейнера следуя описанию в репозитории

- Из папки с [docker-compose.yaml](otus-mysql-docker-master/docker-compose.yml) выполняем команду: ```docker compose up```
- Подключаемся к серверу командой: ```docker-compose exec otusdb mysql -u root -p12345 otus```. Проверяем что таблицы 
созданы:
```amplicode sql
mysql> SHOW TABLES;
+-------------------------+
| Tables_in_otus          |
+-------------------------+
| Address                 |
| Cashier                 |
| Cheque                  |
| ChequePayment           |
| ChequePositions         |
| ChequeType              |
| CityType                |
| PaymentType             |
| PostalCode              |
| Price                   |
| PriceList               |
| ProductCategory         |
| ProductUnit             |
| Products                |
| ProductsProductCategory |
| Region                  |
| RegionType              |
| Role                    |
| SettelmentType          |
| Shift                   |
| Store                   |
| StreetType              |
| Terminal                |
+-------------------------+
23 rows in set (0.00 sec)
```

## Задания повышенной сложности

### Прописать кастомный конфиг - настроить innodb_buffer_pool и другие параметры по желанию

- innodb_buffer_pool_size = 3G
- innodb_buffer_pool_instances = 16
- innodb_log_buffer_size = 16M
- innodb_log_file_size = 512M

### Протестить сисбенчем - результат теста приложить в README

- Создаём БД для теста: ```docker-compose exec otusdb mysql -u root -p12345 -e "CREATE DATABASE sbtest;"```
- Выполняем первый скрипт (создание таблиц и заполнение):
```sysbench oltp_read_write   --mysql-host=192.168.31.190   --mysql-port=3309   --mysql-user=root   --mysql-password=12345   --mysql-db=sbtest   --tables=10   --table-size=100000   prepare```
- Запускаем нагрузку:
```sysbench oltp_read_write   --mysql-host=192.168.31.190   --mysql-port=3309   --mysql-user=root   --mysql-password=12345   --mysql-db=sbtest   --tables=10   --table-size=100000   --threads=8   --time=60   run```
- Результат:
```amplicode sql
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 8
Initializing random number generator from current time


Initializing worker threads...

Threads started!

SQL statistics:
    queries performed:
        read:                            446502
        write:                           127570
        other:                           63785
        total:                           637857
    transactions:                        31892  (531.41 per sec.)
    queries:                             637857 (10628.49 per sec.)
    ignored errors:                      1      (0.02 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          60.0127s
    total number of events:              31892

Latency (ms):
         min:                                    3.11
         avg:                                   15.05
         max:                                  416.29
         95th percentile:                       25.28
         sum:                               479988.94

Threads fairness:
    events (avg/stddev):           3986.5000/32.04
    execution time (avg/stddev):   59.9986/0.00
```
