# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:13
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/var/lib/postgresql/backup
    environment:
      POSTGRES_DB: "default_db"
      POSTGRES_USER: "pgadmin"
      POSTGRES_PASSWORD: "pgpassword"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    ports:
      - "5432:5432"

volumes:
  data:
  backup:

```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
```
test_db=# \l
                                List of databases
    Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges  
------------+---------+----------+------------+------------+---------------------
 default_db | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres   | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0  | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/pgadmin         +
            |         |          |            |            | pgadmin=CTc/pgadmin
 template1  | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/pgadmin         +
            |         |          |            |            | pgadmin=CTc/pgadmin
 test_db    | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | 
(5 rows)

```
- описание таблиц (describe)
```
test_db=# \dt
         List of relations
 Schema |  Name   | Type  |  Owner  
--------+---------+-------+---------
 public | clients | table | pgadmin
 public | orders  | table | pgadmin
(2 rows)

```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
test_db=# SELECT * FROM information_schema.table_privileges WHERE table_schema='public';
```

- список пользователей с правами над таблицами test_db
```
grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 pgadmin | pgadmin          | test_db       | public       | orders     | INSERT         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | orders     | SELECT         | YES          | YES
 pgadmin | pgadmin          | test_db       | public       | orders     | UPDATE         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | orders     | DELETE         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | orders     | REFERENCES     | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | orders     | TRIGGER        | YES          | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 pgadmin | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 pgadmin | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | INSERT         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | SELECT         | YES          | YES
 pgadmin | pgadmin          | test_db       | public       | clients    | UPDATE         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | DELETE         | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | REFERENCES     | YES          | NO
 pgadmin | pgadmin          | test_db       | public       | clients    | TRIGGER        | YES          | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 pgadmin | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 pgadmin | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 pgadmin | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 pgadmin | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
test_db=# SELECT COUNT(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM orders;
 count 
-------
     5
(1 row)

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Книга') WHERE surname='Иванов Иван Иванович';
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Монитор') WHERE surname='Петров Петр Петрович';
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Гитара') WHERE surname='Иоган Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```
test_db=# SELECT surname, name FROM clients INNER JOIN orders ON clients.order_id=orders.id;
       surname        |  name   
----------------------+---------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоган Себастьян Бах  | Гитара
(3 rows)

```
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT surname, name FROM clients INNER JOIN orders ON clients.order_id=orders.id;
                              QUERY PLAN                               
-----------------------------------------------------------------------
 Hash Join  (cost=11.57..24.20 rows=70 width=1032)
   Hash Cond: (orders.id = clients.order_id)
   ->  Seq Scan on orders  (cost=0.00..11.40 rows=140 width=520)
   ->  Hash  (cost=10.70..10.70 rows=70 width=520)
         ->  Seq Scan on clients  (cost=0.00..10.70 rows=70 width=520)
(5 rows)

```

Так как в запросе используется JOIN, планировщик выбирает объединение по хешу. В скобках стоимость выполнения до выдачи результата и общая стоимость (за единицу стоимости принимается время чтения одной страницы с диска).
Далее планируемое количество строк к чтению и размер строки в байтах. Далее планировщик раскладывает иерархию выполнения с указанием стоимостей и размеров для каждой операции.
То есть условие для объединения, хеш id в заказах и хеш order_id в клиентах. 

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---