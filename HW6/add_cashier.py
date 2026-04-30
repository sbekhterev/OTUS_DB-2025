import sqlalchemy as sa
from faker.proxy import Faker


engine = sa.create_engine('postgresql+psycopg2://admin:admin@192.168.31.190/store_chain')
cashier_role = [140, 141]


for i in range(90000):
    fake = Faker('ru_RU')
    fake_hiring_date = fake.date_between(start_date='-3y', end_date='today')
    fake_firing_date = fake.date_between(start_date=fake_hiring_date, end_date='today')
    sql_text = (f'INSERT INTO dic."Cashier" '
                f'("LastName", "FirstName", "PatronymicName", "RoleId", "Hiring") values '
                f'(\'{fake.last_name()}\', \'{fake.first_name()}\', \'{fake.middle_name()}\', '
                f'{fake.random_element(cashier_role)}, '
                f'\'{fake_hiring_date}\');')
    # print(sql_text)
    with engine.connect() as conn:
        conn.execute(sa.text(sql_text))
        conn.commit()
