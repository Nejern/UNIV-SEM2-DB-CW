------------
-- Отделы --
------------
INSERT INTO departments
(id, title) VALUES
(1, 'Разработка'),
(2, 'Маркейтинг'),
(3, 'Продажи');

-------------------
-- Виды расходов --
-------------------
INSERT INTO expense_types
(id, title, description) VALUES
(1, 'Реклама', 'Затраты на рекламные кампании'),
(2, 'Офисные расходы', 'Затраты на покупку офисных расходных материалов'),
(3, 'IT-расходы', 'Расходы на приобретение и обслуживание информационных технологий'),
(4, 'Мероприятия и конференции', 'Затраты на организацию и участие в мероприятиях и конференциях'),
(5, 'Обучение и развитие', 'Расходы на обучение сотрудников и развитие профессиональных навыков'),
(6, 'Транспортные расходы', 'Затраты перемещение сотрудников');

----------------
-- Сотрудники --
----------------
INSERT INTO staff
(department_id) VALUES
(1),
(1),
(1),
(1),
(1),
(2),
(2),
(2),
(2),
(2),
(2),
(2),
(3),
(3),
(3),
(3),
(3),
(3),
(3),
(3);

------------------------------
-- Виды расходов по отделам --
------------------------------
INSERT INTO budgets
(department_id, expense_type_id, datestamp, max_amount) VALUES
(1, 1, '01.5.2023', 41400),
(1, 2, '01.5.2023', 42400),
(1, 3, '01.5.2023', 23400),
(1, 4, '01.5.2023', 33400),
(1, 5, '01.5.2023', 23400),
(1, 6, '01.5.2023', 36400),
(2, 1, '01.5.2023', 29400),
(2, 2, '01.5.2023', 37400),
(2, 3, '01.5.2023', 28400),
(2, 4, '01.5.2023', 49400),
(2, 5, '01.5.2023', 48400),
(2, 6, '01.5.2023', 32400),
(3, 1, '01.5.2023', 51400),
(3, 2, '01.5.2023', 39400),
(3, 3, '01.5.2023', 26400),
(3, 4, '01.5.2023', 39400),
(3, 5, '01.5.2023', 38400),
(3, 6, '01.5.2023', 49400),
(1, 1, '01.6.2023', 40500),
(1, 2, '01.6.2023', 28500),
(1, 3, '01.6.2023', 40500),
(1, 4, '01.6.2023', 44500),
(1, 5, '01.6.2023', 45500),
(1, 6, '01.6.2023', 32500),
(2, 1, '01.6.2023', 32500),
(2, 2, '01.6.2023', 37500),
(2, 3, '01.6.2023', 37500),
(2, 4, '01.6.2023', 24500),
(2, 5, '01.6.2023', 30500),
(2, 6, '01.6.2023', 30500),
(3, 1, '01.6.2023', 37500),
(3, 2, '01.6.2023', 47500),
(3, 3, '01.6.2023', 31500),
(3, 4, '01.6.2023', 37500),
(3, 5, '01.6.2023', 37500),
(3, 6, '01.6.2023', 29500),
(1, 1, '01.7.2023', 25600),
(1, 2, '01.7.2023', 25600),
(1, 3, '01.7.2023', 43600),
(1, 4, '01.7.2023', 41600),
(1, 5, '01.7.2023', 31600),
(1, 6, '01.7.2023', 15600),
(2, 1, '01.7.2023', 20600),
(2, 2, '01.7.2023', 38600),
(2, 3, '01.7.2023', 22599),
(2, 4, '01.7.2023', 21600),
(2, 5, '01.7.2023', 38600),
(2, 6, '01.7.2023', 26600),
(3, 1, '01.7.2023', 46600),
(3, 2, '01.7.2023', 31600),
(3, 3, '01.7.2023', 46600),
(3, 4, '01.7.2023', 39600),
(3, 5, '01.7.2023', 31600),
(3, 6, '01.7.2023', 35600);

-------------
-- Расходы --
-------------
INSERT INTO expenses
(expense_type_id, staffer_id, amount, expense_date) VALUES
-- Отдел 1 / 5 мес
(1, 1, 41400, '01.5.2023'),
(2, 1, 42400, '11.5.2023'),
(3, 2, 23400, '21.5.2023'),
(4, 3, 33400, '24.5.2023'),
(5, 4, 23400, '25.5.2023'),
(6, 5, 36400, '26.5.2023'),

-- Отдел 2 / 5 мес
(1, 6, 29400, '01.5.2023'),
(2, 6, 37400, '02.5.2023'),
(3, 6, 28400, '03.5.2023'),
(4, 8, 49400, '04.5.2023'),
(5, 8, 48400, '05.5.2023'),
(6, 9, 32400, '06.5.2023'),

-- Отдел 3 / 5 мес
(1, 20, 51400, '21.5.2023'),
(2, 20, 39400, '22.5.2023'),
(3, 20, 26400, '23.5.2023'),
(4, 20, 39400, '24.5.2023'),
(5, 20, 38400, '25.5.2023'),
(6, 19, 49400, '26.5.2023');