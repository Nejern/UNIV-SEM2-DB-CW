-- Таблица всех расходов конкретного отдела по годам, месяцам и типам расходов
CREATE OR REPLACE FUNCTION department_expenses(depart_id INT)
RETURNS TABLE (year DECIMAL, month DECIMAL, expense_type_id INT, expenses DECIMAL)
AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM departments WHERE id = depart_id) THEN
		RAISE EXCEPTION 'Department does not exist';
	END IF;
	RETURN QUERY
	SELECT
		EXTRACT(YEAR FROM expenses.expense_date) AS year
		,EXTRACT(MONTH FROM expenses.expense_date) AS month
		,expenses.expense_type_id
		,COALESCE(SUM(expenses.amount), 0) AS expenses
	FROM expenses, staff
	WHERE
		expenses.staffer_id = staff.id
		AND staff.department_id = depart_id
	GROUP BY year, month, expenses.expense_type_id
	ORDER BY year, month, expenses.expense_type_id;

	RETURN;
END;
$$ LANGUAGE plpgsql;

-- Сумма всех расходов конкретного отдела от даты до даты
CREATE OR REPLACE FUNCTION department_expenses_from_to(depart_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL
AS $$
DECLARE
	total_expenses DECIMAL;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM departments WHERE id = depart_id) THEN
		RAISE EXCEPTION 'Department does not exist';
	END IF;
	SELECT COALESCE(SUM(expenses.amount), 0) INTO total_expenses
	FROM expenses, staff
	WHERE
		staff.department_id = depart_id
		AND expenses.staffer_id = staff.id
		AND expenses.expense_date >= start_date
		AND expenses.expense_date <= end_date;

	RETURN total_expenses;
END;
$$ LANGUAGE plpgsql;

-- Таблица всех расходов сотрудников
DROP FUNCTION IF EXISTS staff_expenses();
CREATE OR REPLACE FUNCTION staff_expenses()
RETURNS TABLE
(
	staffer_id INT
	,expense_date DATE
	,amount DECIMAL
)
AS $$
BEGIN
	RETURN QUERY
	SELECT
		staff.id
		,expenses.expense_date
		,expenses.amount
	FROM expenses, staff
	WHERE expenses.staffer_id = staff.id;
END;
$$ LANGUAGE plpgsql;

-- Оставшаяся не потраченная сумма отдела в конкретной категории
CREATE OR REPLACE FUNCTION department_remaining_amount(depart_id INT, type_id INT)
RETURNS DECIMAL
AS $$
DECLARE
	remaining_amount DECIMAL;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM departments WHERE id = depart_id) THEN
		RAISE EXCEPTION 'Department does not exist';
	END IF;
	IF NOT EXISTS (SELECT 1 FROM expense_types WHERE id = type_id) THEN
		RAISE EXCEPTION 'Expense type does not exist';
	END IF;
	SELECT
		COALESCE((
			SELECT SUM(max_amount)
			FROM budgets
			WHERE
				department_id = depart_id
				AND expense_type_id = type_id
				AND datestamp <= NOW()
		), 0) -
		COALESCE((
			SELECT SUM(amount)
			FROM expenses, staff
			WHERE
				staff.department_id = depart_id
				AND expenses.staffer_id = staff.id
				AND expense_type_id = type_id
				AND expense_date <= NOW()
		), 0) INTO remaining_amount;

	RETURN remaining_amount;
END;
$$ LANGUAGE plpgsql;

-- Совершить расход
CREATE OR REPLACE PROCEDURE pay(staffer_id INT, expense_type VARCHAR(32), amount DECIMAL)
AS $$
DECLARE
	expense_type_id INT;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM staff WHERE id = staffer_id) THEN
		RAISE EXCEPTION 'Staffer does not exist';
	END IF;
	IF NOT EXISTS (SELECT 1 FROM expense_types WHERE title = expense_type) THEN
		RAISE EXCEPTION 'Expense type does not exist';
	END IF;
	
	SELECT id INTO expense_type_id
	FROM expense_types
	WHERE title = expense_type;
	
	INSERT INTO expenses
	(expense_type_id, staffer_id, amount, expense_date) VALUES
	(expense_type_id, staffer_id, amount, NOW());
END;
$$ LANGUAGE plpgsql;
