-- Сумма всех расходов конкретного отдела
CREATE OR REPLACE FUNCTION department_expenses_alltime(depart_id INT)
RETURNS DECIMAL
AS $$
DECLARE
	total_expenses DECIMAL;
BEGIN
	SELECT COALESCE(SUM(expenses.amount), 0) INTO total_expenses
	FROM expenses, staff
	WHERE
		expenses.staffer_id = staff.id
		AND staff.department_id = depart_id;

	RETURN total_expenses;
END;
$$ LANGUAGE plpgsql;

-- Сумма всех расходов конкретного отдела от даты до даты
CREATE OR REPLACE FUNCTION department_expenses_from_to(depart_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL
AS $$
DECLARE
	total_expenses DECIMAL;
BEGIN
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

-- Таблица всех расходов конкретного отдела по годам и месяцам
CREATE OR REPLACE FUNCTION department_expenses(depart_id INT)
RETURNS TABLE (year DECIMAL, month DECIMAL, expenses DECIMAL)
AS $$
BEGIN
	RETURN QUERY
	SELECT
		EXTRACT(YEAR FROM expenses.expense_date) AS year,
		EXTRACT(MONTH FROM expenses.expense_date) AS month,
		COALESCE(SUM(expenses.amount), 0) AS expenses
	FROM expenses, staff
	WHERE
		expenses.staffer_id = staff.id
		AND staff.department_id = depart_id
	GROUP BY year, month
	ORDER BY year, month;

	RETURN;
END;
$$ LANGUAGE plpgsql;

