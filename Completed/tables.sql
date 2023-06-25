------------
-- Отделы --
------------
DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE IF NOT EXISTS departments
(
	id SERIAL PRIMARY KEY
	,title VARCHAR(32) NOT NULL
);

----------------
-- Сотрудники --
----------------
DROP TABLE IF EXISTS staff CASCADE;
CREATE TABLE IF NOT EXISTS staff
(
	id SERIAL PRIMARY KEY
	,department_id INT REFERENCES departments (id) NOT NULL
);

-------------------
-- Виды расходов --
-------------------
DROP TABLE IF EXISTS expense_types CASCADE;
CREATE TABLE IF NOT EXISTS expense_types
(
	id SERIAL PRIMARY KEY
	,title VARCHAR(32) NOT NULL
	,description TEXT
);

------------------------------
-- Виды расходов по отделам --
------------------------------
DROP TABLE IF EXISTS departments_expense_types CASCADE;
CREATE TABLE IF NOT EXISTS departments_expense_types
(
	id SERIAL PRIMARY KEY
	,department_id INT REFERENCES departments (id) NOT NULL
	,expense_type_id INT REFERENCES expense_types (id) NOT NULL
	,datestamp DATE NOT NULL
	,max_amount DECIMAL NOT NULL
);

-------------
-- Расходы --
-------------
DROP TABLE IF EXISTS expenses CASCADE;
CREATE TABLE IF NOT EXISTS expenses
(
	id SERIAL PRIMARY KEY
	,expense_type_id INT REFERENCES expense_types (id) NOT NULL
	,staffer_id INT REFERENCES staff (id) NOT NULL
	,amount DECIMAL NOT NULL
	,expense_date DATE NOT NULL
);

