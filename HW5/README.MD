# DML: вставка, обновление, удаление, выборка данных в PostgreSQL.

## Заполнение схемы словарей тестовыми данными

[SQL скрипт с тестовыми данными](sql/dic_test_data.sql)

## Задания:

1. Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.
    Найти кассиров с латинскими буквами в Ф.И.О.
    ```
   SELECT c."ID", c."FirstName", c."LastName", c."PatronymicName"
     FROM dic."Cashier" c
    WHERE concat(c."FirstName", c."LastName", c."PatronymicName") ~ '[A-Z, a-z]+';
   ```
2. 


