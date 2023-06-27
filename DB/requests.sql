-- 1 --
-- Запрос на выборку всех отделов
SELECT * FROM departments;

-- 2 --
-- Выборка сотрудников определенного отдела
SELECT * FROM staff WHERE department_id = 1;

-- 3 --
-- Сортировка отделов по названию
SELECT * FROM departments ORDER BY title;

-- 4 --
-- Общая сумма расходов
SELECT SUM(amount) FROM expenses;

-- 5 --
-- Общая сумма расходов по каждому отделу
SELECT department_id, SUM(amount) 
FROM expenses 
JOIN staff ON expenses.staffer_id = staff.id 
GROUP BY department_id;

-- 6 --
-- Самый большой бюджет по отделам
SELECT department_id, MAX(max_amount)
FROM budgets
GROUP BY department_id;

-- 7 --
-- Отделы, которые превысили бюджет
SELECT department_id 
FROM (
    SELECT department_id, AVG(amount) as avg_expenses 
    FROM expenses 
    JOIN staff ON expenses.staffer_id = staff.id 
    GROUP BY department_id
) AS dept_expenses 
WHERE avg_expenses > 35000;

-- 8 --
-- Использование CASE для категоризации расходов
SELECT id, amount,
CASE 
    WHEN amount <= 20000 THEN 'low'
    WHEN amount <= 40000 THEN 'medium'
    ELSE 'high'
END as expense_category
FROM expenses;


-- 9 --
-- Отделы, в которых работает более 6 сотрудников
SELECT department_id
FROM staff
GROUP BY department_id
HAVING COUNT(DISTINCT id) > 6;

-- 10 --
-- Оконная функция для ранжирования расходов внутри каждого отдела
SELECT
	department_id
	,staffer_id
	,amount
	,RANK() OVER(
		PARTITION BY department_id
		ORDER BY amount DESC
	) as rank
FROM expenses 
JOIN staff ON expenses.staffer_id = staff.id;

-- 11 --
-- Общая сумма расходов по каждому виду расходов
SELECT expense_type_id, SUM(amount)
FROM expenses
GROUP BY expense_type_id;

-- 12 --
-- Средний бюджет по отделам
SELECT department_id, AVG(max_amount)
FROM budgets
GROUP BY department_id;

-- 13 --
-- Отделы, в которых есть сотрудники, чьи общие расходы превышают 100000:
SELECT DISTINCT department_id
FROM (
    SELECT s.department_id, SUM(e.amount) as total_expenses
    FROM staff s
    JOIN expenses e ON s.id = e.staffer_id
    GROUP BY s.id, s.department_id
) AS staff_expenses
WHERE total_expenses > 100000;

-- 14 --
-- Вид расходов с наибольшей общей суммой
SELECT title, SUM(amount) as total_expense 
FROM expenses, expense_types
WHERE expense_type_id = expense_types.id
GROUP BY title
ORDER BY total_expense DESC LIMIT 1;

-- 15 --
-- Общая сумма расходов по месяцам
SELECT
	DATE_TRUNC('month', expense_date) as month
	,SUM(amount)
FROM expenses
GROUP BY month;

-- 16 --
-- Процентный расход каждого сотрудника внутри его отдела
SELECT e.staffer_id, SUM(e.amount) / SUM(SUM(e.amount)) OVER (PARTITION BY s.department_id) * 100 as percent
FROM expenses e
JOIN staff s ON e.staffer_id = s.id
GROUP BY e.staffer_id, s.department_id;

-- 17 --
-- Количество сотрудников в каждом отделе
SELECT title, COUNT(*)
FROM staff, departments
WHERE department_id = departments.id
GROUP BY title;

-- 18 --
-- Бюджет по видам расходов, превышающий определенную сумму
SELECT DISTINCT title
FROM budgets, expense_types
WHERE
	expense_type_id = expense_types.id
	AND max_amount > 49000;

-- 19 --
-- Количество расходов каждого сотрудника
SELECT staffer_id, COUNT(*)
FROM expenses
GROUP BY staffer_id
ORDER BY staffer_id;

-- 20 --
-- Сотрудники, чьи расходы превысили 1000 за последний месяц
SELECT staffer_id 
FROM expenses 
WHERE expense_date > (CURRENT_DATE - INTERVAL '1 month') 
GROUP BY staffer_id 
HAVING SUM(amount) > 1000;
