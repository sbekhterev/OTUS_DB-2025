# Реализовать спроектированную схему в postgres.

## Базу данных.

1. Для создания отдельного табличного пространства для индексов создаем дополнительные PersistentVolume и PersistentVolumeClaim:
    - [dbi-pv.yaml](k8s/dbi-pv.yaml)
    - [dbi-pvc.yaml](k8s/dbi-pvc.yaml)
2. Так же добавляем их в манифест пода и при старте выдаём разрешение:
    - [db.yaml](k8s/db.yaml)
3. Применям изменения:
    - Создаём PersistentVolume: ```microk8s kubectl apply -f dbi-pv.yaml```
    - Создаём PersistentVolumeClaim: ```microk8s kubectl apply -f dbi-pvc.yaml```
    - Пересоздаём под: ```microk8s kubectl apply -f db.yaml```

База данных и её владелец у нас создаётся при инициализации пода.

![](pic/pic_1.PNG)


## Табличные пространства и роли.

1. Создание табличного пространства для индексов: ```create tablespace db_indexes location '/mnt/idx';```
2. Создание ролей:
    - Группа с правами только для чтения: ```create role db_reader;```
    - Группа с правами на изменения данных в таблицах (оператор): ```create role db_operator;```
    - Группа с правами на изменения структуры БД (разработчик): ```create role db_developer;```
3. Создадим тестовых пользователей:
    - Пользователь группы только для чтения: ```create user r_user WITH ENCRYPTED PASSWORD '123'; grant db_reader to r_user;```
    - Пользователь группы "оператор": ```create user o_user WITH ENCRYPTED PASSWORD '123'; grant db_operator to o_user;```
    - Пользователь группы "разработчик": ```create user d_user WITH ENCRYPTED PASSWORD '123'; grant db_developer to d_user;```


## Схему данных.

1. Создание схем:
    - Схема для словарей: ```create schema if not exists dic;```
    - Схема для данных: ```create schema if not exists "data";```

## Таблицы своего проекта, распределив их по схемам и табличным пространствам.

	- [SQL-скрипт создания таблиц, индексов.](sql/store_chain.sql)
	
	