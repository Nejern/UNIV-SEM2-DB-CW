-- Проверка на правильность даты при каждой покупке
CREATE OR REPLACE FUNCTION check_expense_date_trigger()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.expense_date > NOW() THEN
		RAISE EXCEPTION 'Expense cannot be committed in the future';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_expense_date_trigger
BEFORE INSERT OR UPDATE ON expenses
FOR EACH ROW
EXECUTE FUNCTION check_expense_date_trigger();

-- Проверка на покупательную способность при каждой покупке
CREATE OR REPLACE FUNCTION check_pay_trigger()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.expense_date <= NOW() THEN
		IF NEW.amount > COALESCE(department_remaining_amount(
			(
				SELECT department_id
				FROM staff
				WHERE id = NEW.staffer_id
			), NEW.expense_type_id
		), 0) THEN
			RAISE EXCEPTION 'Not enough money to make an expense';
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_pay_trigger
BEFORE INSERT OR UPDATE ON expenses
FOR EACH ROW
EXECUTE FUNCTION check_pay_trigger();

-- Изменение бюджетов
CREATE OR REPLACE FUNCTION check_budgets_trigger()
RETURNS TRIGGER AS $$
BEGIN
	IF
		EXTRACT(YEAR FROM NEW.datestamp) <= EXTRACT(YEAR FROM NOW())
		AND EXTRACT(MONTH FROM NEW.datestamp) <= EXTRACT(MONTH FROM NOW())
	THEN
		RAISE EXCEPTION 'You cant change budgets in the previous or current month';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_budgets_trigger
BEFORE INSERT OR UPDATE ON budgets
FOR EACH ROW
EXECUTE FUNCTION check_budgets_trigger();

-- Изменение даты
CREATE OR REPLACE FUNCTION check_budgets_date_trigger()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.datestamp <> OLD.datestamp THEN
		RAISE EXCEPTION 'You cant update the datestamp column';
	END IF;
	NEW.datestamp = DATE(
		'01.'
		|| EXTRACT(MONTH FROM NEW.datestamp)
		|| '.'
		|| EXTRACT(YEAR FROM NEW.datestamp)
	);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_budgets_date_trigger
BEFORE INSERT OR UPDATE ON budgets
FOR EACH ROW
EXECUTE FUNCTION check_budgets_date_trigger();
