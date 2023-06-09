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

-------------
-- Бюджеты --
-------------
DROP TABLE IF EXISTS budgets CASCADE;
CREATE TABLE IF NOT EXISTS budgets
(
	department_id INT REFERENCES departments (id) NOT NULL
	,expense_type_id INT REFERENCES expense_types (id) NOT NULL
	,datestamp DATE NOT NULL
	,max_amount DECIMAL NOT NULL CHECK (max_amount >= 0)
  ,PRIMARY KEY (department_id, expense_type_id, datestamp)
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
	,amount DECIMAL NOT NULL CHECK (amount >= 0)
	,expense_date DATE NOT NULL
);

