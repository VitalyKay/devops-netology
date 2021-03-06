# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде

Для хранения электронных чеков в json виде хорошо подойдет документо-ориентированная СУБД, тк json по сути является документом 
на языке разметки.

- Склады и автомобильные дороги для логистической компании

Для данной задачи лучше подойдет графовая СУБД, где склады могут быть представлены узлами графа, а дороги - ребрами, и нести информацию о протяженности, загруженности и стоимости проезда.
Таким образом можно будет вычислить оптимальный маршрут доставки путем обхода графа.

- Генеалогические деревья

Для описания генеалогического дерева хорошо подойдет иерархическая СУБД, тк дерево по сути иерархия от предков к потомкам (при условии отсутствия межродственных связей ;)

- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

Для данной задачи хорошо подходит СУБД типа ключ-значения с хранением в памяти для ускорения доступа и ограничением времени жизни записей.

- Отношения клиент-покупка для интернет-магазина

Для данной задачи хорошо подходит реляционная СУБД, в которой будут присутствовать 2 сущности: клиент и товар, а отношения клиент-покупка реализуются через связь многие ко многим.


Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

> AP по САР - в данном случае идет отказ от строгой целостности данных, но подразумевается целостность в конечном итоге. 
> PA/EL по PACELC - тк в случае разделения система доступна, но не консистентна, а при нормальном функционировании
> низкие задержки благодаря каким-то фоновым процессам асинхронной записи (возможно при низкой загрузке) и итоговая консистентность

- При сетевых сбоях, система может разделиться на 2 раздельных кластера

> В таком виде система при разделении остается доступна и конечно же не консистентна (AP по CAP), но  
> в данном случае происходит split brain, в таком случае обеспечить итоговую консистентность после устранения разделения даже в итоге довольно тяжело.  
> Необходимо выбрать какую либо стратегию при разделении: либо какой-то кластер не набравший большинства нод перестает 
> принимать запросы на запись и потом сможет синхронизироваться (AP по CAP, PA/(EC или EL) по PACELС (зависит от приоритетов)),
> либо обе части перестают вообще обрабатывать запросы, чтобы сохранить консистентность (CP по CAP, PC/(EC или EL) по PACELС (зависит от приоритетов))

- Система может не прислать корректный ответ или сбросить соединение

> Скорее всего произошло разделение и система пытается обеспечить консистентность жертвуя доступностью - CP по CAP.
> PC/EC по PACELC, тк при разделении система недоступна, но консистентна, а при нормальной работе скорее всего так же обеспечивается
> консистентность в жертву задержкам.

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

Да могут. Большинство NoSQL систем обеспечивают принцип ACID на уровне записи, но BASE на уровне распределенной системы.

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

Условиям данной задачи соответствует система Redis. Но у данной реализации есть ряд недостатков:
- если издатель по каким-либо причинам выходит из строя, то он теряет всех своих подписчиков;
- издателю необходимо знать точный адрес всех его подписчиков;
- издатель может перегрузить работой своих подписчиков, если данные публикуются быстрее, чем обрабатываются;
- сообщение удаляется из буфера издателя сразу после публикации, не зависимо от того, какому числу подписчиков оно доставлено и как быстро те сумели обработать это сообщение;
- все подписчики получат сообщение одновременно. Подписчики сами должны как-то между собой согласовывать порядок обработки одного и того же сообщения;
- нет встроенного механизма подтверждения успешной обработки сообщения подписчиком. Если подписчик получил сообщение и свалился во время обработки, то издатель об этом не узнает.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
