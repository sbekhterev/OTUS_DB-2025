# DML: агрегация и сортировка, CTE, аналитические функции в PostgreSQL


## Создайте таблицу и наполните ее данными
```amplicode sql
CREATE TABLE statistic(
player_name VARCHAR(100) NOT NULL,
    player_id INT NOT NULL,
    year_game SMALLINT NOT NULL CHECK (year_game > 0),
    points DECIMAL(12,2) CHECK (points >= 0),
    PRIMARY KEY (player_name,year_game)
);
```
```amplicode sql
INSERT INTO
    statistic(player_name, player_id, year_game, points)
VALUES
    ('Mike',1,2018,18),
    ('Jack',2,2018,14),
    ('Jackie',3,2018,30),
    ('Jet',4,2018,30),
    ('Luke',1,2019,16),
    ('Mike',2,2019,14),
    ('Jack',3,2019,15),
    ('Jackie',4,2019,28),
    ('Jet',5,2019,25),
    ('Luke',1,2020,19),
    ('Mike',2,2020,17),
    ('Jack',3,2020,18),
    ('Jackie',4,2020,29),
    ('Jet',5,2020,27);
```


## Написать запрос суммы очков с группировкой и сортировкой по годам.
```amplicode sql
select s.year_game, 
       sum(s.points) as sum_points
  from statistic s
 group by s.year_game
 order by s.year_game;
```
```text
year_game|sum_points|
---------+----------+
     2018|     92.00|
     2019|     98.00|
     2020|    110.00|
```

## Написать cte показывающее тоже самое.
```amplicode sql
with sum_points as (
select s.year_game,
       sum(s.points) over (partition by s.year_game order by s.year_game) as sum_points
  from statistic s 
)
select distinct on (year_game) year_game, sum_points
  from sum_points 
 order by year_game;
```
```text
year_game|sum_points|
---------+----------+
     2018|     92.00|
     2019|     98.00|
     2020|    110.00|
```


## Используя функцию LAG вывести кол-во очков по всем игрокам за текущий год и за предыдущий.
```amplicode sql
  with year_points as (
select s.year_game,
       sum(s.points) as year_points
  from statistic s 
 group by s.year_game)
select yp.year_game,
       yp.year_points,
	   lag(yp.year_points, 1) over (order by yp.year_game) as previous_year_points
  from year_points yp
 order by yp.year_game;
```
```text
year_game|year_points|previous_year_points|
---------+-----------+--------------------+
     2018|      92.00|                    |
     2019|      98.00|               92.00|
     2020|     110.00|               98.00|
```

