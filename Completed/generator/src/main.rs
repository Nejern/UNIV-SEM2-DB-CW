use rand::{rngs::ThreadRng, Rng};

const DEPARTMENTS: [&str; 3] = ["Разработка", "Маркейтинг", "Продажи"];
const EXPENSE_TYPES: [[&str; 2]; 6] = [
    ["Реклама", "Затраты на рекламные кампании"],
    [
        "Офисные расходы",
        "Затраты на покупку офисных расходных материалов",
    ],
    [
        "IT-расходы",
        "Расходы на приобретение и обслуживание информационных технологий",
    ],
    [
        "Мероприятия и конференции",
        "Затраты на организацию и участие в мероприятиях и конференциях",
    ],
    [
        "Обучение и развитие",
        "Расходы на обучение сотрудников и развитие профессиональных навыков",
    ],
    ["Транспортные расходы", "Затраты перемещение сотрудников"],
];

fn main() {
    // departments
    gen_departments();
    // expense_types
    gen_expense_types();
    // departments_expense_types
    gen_departments_expense_types();
    // staff
    gen_staff();
    // expenses
    // todo!();
}

fn gen_departments() {
    let title = "departments";
    let types = ["id", "title"];
    println!("INSERT INTO {title}");
    print!("(");
    for i in 0..types.len() {
        print!("'{}'", types[i]);
        if i == types.len() - 1 {
            println!(") VALUES")
        } else {
            print!(", ")
        }
    }
    for i in 0..DEPARTMENTS.len() {
        print!("(");
        for j in 0..types.len() {
            if types[j] != "id" {
                print!("'{}'", DEPARTMENTS[i]);
            } else {
                print!("{}", i + 1);
            }
            if j != types.len() - 1 {
                print!(", ")
            }
        }
        if i == DEPARTMENTS.len() - 1 {
            println!("),")
        } else {
            println!(");")
        }
    }
}

fn gen_expense_types() {
    let title = "expense_types";
    let types = ["id", "title", "description"];
    println!("INSERT INTO {title}");
    print!("(");
    for i in 0..types.len() {
        print!("'{}'", types[i]);
        if i == types.len() - 1 {
            println!(") VALUES")
        } else {
            print!(", ")
        }
    }
    for i in 0..EXPENSE_TYPES.len() {
        print!("(");
        for j in 0..types.len() {
            if types[j] != "id" {
                print!("'{}'", EXPENSE_TYPES[i][j - 1]);
            } else {
                print!("{}", i + 1);
            }
            if j != types.len() - 1 {
                print!(", ")
            }
        }
        if i != EXPENSE_TYPES.len() - 1 {
            println!("),")
        } else {
            println!(");")
        }
    }
}

fn gen_departments_expense_types() {
    let title = "departments_expense_types";
    let types = [
        "department_id",
        "expense_type_id",
        "datestamp",
        "max_amount",
    ];
    println!("INSERT INTO {title}");
    print!("(");
    for i in 0..types.len() {
        print!("'{}'", types[i]);
        if i == types.len() - 1 {
            println!(") VALUES")
        } else {
            print!(", ")
        }
    }
    let mut rng = rand::thread_rng();
    let year_from_to = (2023, 2023);
    for year in year_from_to.0..=year_from_to.1 {
        for month in 1..=12 {
            for depart_id in 1..=DEPARTMENTS.len() {
                for expense_type_id in 1..=EXPENSE_TYPES.len() {
                    let rand_num = rng.gen_range(0..=30);
                    print!(
                        "({depart_id}, {expense_type_id}, '01.{month}.{year}', {max_amount})",
                        max_amount = (10000.
                            * (1.
                                + ((year - year_from_to.0) as f64 * 0.1
                                    + (month - 1) as f64 * 0.01
                                    + depart_id as f64 * 0.5
                                    + rand_num as f64 * 0.1)))
                            as i64
                    );
                    if year == year_from_to.1
                        && month == 12
                        && depart_id == DEPARTMENTS.len()
                        && expense_type_id == EXPENSE_TYPES.len()
                    {
                        println!(";");
                    } else {
                        println!(",");
                    }
                }
            }
        }
    }
}

fn gen_staff() {
    let title = "staff";
    let types = ["department_id"];
    println!("INSERT INTO {title}");
    print!("(");
    for i in 0..types.len() {
        print!("'{}'", types[i]);
        if i == types.len() - 1 {
            println!(") VALUES")
        } else {
            print!(", ")
        }
    }
    let staff_count = [5, 7, 8];
    for depart_id in 1..=DEPARTMENTS.len() {
        for j in 1..=staff_count[depart_id - 1] {
            print!("({depart_id})");
            if j == staff_count[DEPARTMENTS.len() - 1] && depart_id == DEPARTMENTS.len() {
                println!(";");
            } else {
                println!(",");
            }
        }
    }
}
