# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```commandline
default_db=# \l
                                List of databases
    Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges  
------------+---------+----------+------------+------------+---------------------
 default_db | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres   | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0  | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/pgadmin         +
            |         |          |            |            | pgadmin=CTc/pgadmin
 template1  | pgadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/pgadmin         +
            |         |          |            |            | pgadmin=CTc/pgadmin
```
- подключения к БД
```commandline
postgres=# \c default_db
You are now connected to database "default_db" as user "pgadmin".
```
- вывода списка таблиц
```commandline
test_database=# \dt
          List of relations
 Schema |   Name   | Type  |  Owner  
--------+----------+-------+---------
 public | orders   | table | pgadmin
 public | orders_1 | table | pgadmin
 public | orders_2 | table | pgadmin
(3 rows)

```
- вывода описания содержимого таблиц
```commandline
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner  
--------+---------------+----------+---------
 public | orders        | table    | pgadmin
 public | orders_1      | table    | pgadmin
 public | orders_2      | table    | pgadmin
 public | orders_id_seq | sequence | pgadmin
(4 rows)

test_database=# \d+ orders
                                                       Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
 title  | character varying(80) |           | not null |                                    | extended |              | 
 price  | integer               |           |          | 0                                  | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Child tables: orders_1,
              orders_2
Access method: heap
```

- выхода из psql
```commandline
default_db=# \q
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```commandline
root@111d7bd0dfb6:/# psql --username=pgadmin --dbname=test_database<test_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```commandline
test_database=# analyze verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
```commandline
test_database=# select attname, avg_width from pg_stats where tablename='orders' and avg_width=(select max(avg_width) from pg_stats where tablename='orders');
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)
```

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

**Я перепутал больше-меньше, но сути это не меняет**

```commandline
BEGIN;

-- Создаем первую партицию для price<499

CREATE TABLE orders_1(
  CHECK(price<499)
) INHERITS (orders);

-- Создаем вторую партицию для price>=499

CREATE TABLE orders_2(
  CHECK(price<=499)
) INHERITS (orders);

-- Переносим данные в партиции, удаляя из основной и вставляя в унаследованные таблицы по условию

WITH old_data AS (
  DELETE FROM ONLY orders
    WHERE price<499 RETURNING *)
INSERT INTO orders_1
  SELECT * FROM old_data;
 
WITH old_data AS (
  DELETE FROM ONLY orders
    WHERE price>=499 RETURNING *)
INSERT INTO orders_2
  SELECT * FROM old_data;

COMMIT;
```
Результат
```commandline
test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  2 | My little database   |   500
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from only orders;
 id | title | price 
----+-------+-------
(0 rows)

test_database=# select * from only orders_1;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)

test_database=# select * from only orders_2;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)

```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да можно, но нудно было изначально настроить правила для вставки 
- через определение функции и триггеров
```commandline
CREATE OR REPLACE FUNCTION orders_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.price < 499 ) THEN
        INSERT INTO orders_1 VALUES (NEW.*);
    ELSIF ( NEW.price >= 499 ) THEN
        INSERT INTO orders_2 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_orders_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION orders_insert_trigger();
```
- через определение правил
```commandline
CREATE RULE orders_insert_1 AS
ON INSERT TO orders WHERE
    ( price < 499 )
DO INSTEAD
    INSERT INTO orders_1 VALUES (NEW.*);

CREATE RULE orders_insert_2 AS
ON INSERT TO orders WHERE
    ( price >= 499 )
DO INSTEAD
    INSERT INTO orders_2 VALUES (NEW.*);
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```commandline
root@111d7bd0dfb6:/# pg_dump --username=pgadmin --dbname=test_database > db.sql
root@111d7bd0dfb6:/# cat db.sql
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6 (Debian 13.6-1.pgdg110+1)
-- Dumped by pg_dump version 13.6 (Debian 13.6-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: pgadmin
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE public.orders OWNER TO pgadmin;

--
-- Name: orders_1; Type: TABLE; Schema: public; Owner: pgadmin
--

CREATE TABLE public.orders_1 (
    CONSTRAINT orders_1_price_check CHECK ((price < 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_1 OWNER TO pgadmin;

--
-- Name: orders_2; Type: TABLE; Schema: public; Owner: pgadmin
--

CREATE TABLE public.orders_2 (
    CONSTRAINT orders_2_price_check CHECK ((price >= 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_2 OWNER TO pgadmin;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: pgadmin
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO pgadmin;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgadmin
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_1 id; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_1 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_1 price; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_1 ALTER COLUMN price SET DEFAULT 0;


--
-- Name: orders_2 id; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_2 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_2 price; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_2 ALTER COLUMN price SET DEFAULT 0;


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: pgadmin
--

COPY public.orders (id, title, price) FROM stdin;
\.


--
-- Data for Name: orders_1; Type: TABLE DATA; Schema: public; Owner: pgadmin
--

COPY public.orders_1 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
\.


--
-- Data for Name: orders_2; Type: TABLE DATA; Schema: public; Owner: pgadmin
--

COPY public.orders_2 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
7	Me and my bash-pet	499
8	Dbiezdmin	501
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgadmin
--

SELECT pg_catalog.setval('public.orders_id_seq', 8, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```commandline
ALTER TABLE public.orders ADD CONSTRAINT unique_order_title UNIQUE(title);
ALTER TABLE public.orders_1 ADD CONSTRAINT unique_order_1_title UNIQUE(title);
ALTER TABLE public.orders_2 ADD CONSTRAINT unique_order_2_title UNIQUE(title);
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---