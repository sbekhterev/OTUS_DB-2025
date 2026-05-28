import json
import sqlalchemy as sa
from faker.proxy import Faker
import re


prod_cat = ["Напитки", "Хлеб", "Колбаса", "Сыр", "Яйцо", "Молоко", "Овощи", "Фрукты", "Пельмени", "Салаты", "Лопаты", "Плиты", "Горшки", "Молотки", "Ключи гаечные", "Тиски", "Гвозди", "Гайки", "Винты", "Саморезы", "Шайбы", "Воздух"]
price_list = [1, 2, 3, 4, 5]
prod_unit = ["шт", "кг"]
db_url = "mysql+pymysql://root:12345@192.168.31.190:3309/otus"
engine = sa.create_engine(db_url, echo=False)
Products = {"Products": []}


for i in range(20000):
    # f = Faker(['ru_RU'])
    fake = Faker('ru_RU')
    fake.add_provider('faker.providers.barcode')
    fake.add_provider('faker.provider.lorem.ru_RU')
    fake.add_provider('faker.provider.finance')
    fakeEAN = fake.ean()
    fakeGOODS = fake.words(nb=5)
    fakePRICE = fake.pricetag()
    fakePRICE = (int(re.sub(r'[^0-9]', '', fakePRICE))/100)
    fakeUNIT = fake.random_element(elements=prod_unit)
    fakePRICELIST = fake.random_element(elements=price_list)
    fakeCATEGORY = []
    fakeCATEGORY.append(fake.random_element(elements=prod_cat))
    prod = {"Name": ' '.join(fakeGOODS), "Unit": fakeUNIT, "Category": fakeCATEGORY,
            "Price": fakePRICE, "EAN": fakeEAN, "PriceList": fakePRICELIST}
    Products["Products"].append(prod)

# print(json.dumps(Products, indent=4, ensure_ascii=False))

with engine.connect() as conn:
    conn.execute(sa.text(f"call products_add('{json.dumps(Products, ensure_ascii=False)}');"))
    # conn.commit()