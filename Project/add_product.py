import json
import sqlalchemy as sa
from faker.proxy import Faker
import re

from sqlalchemy import false, true

# from faker.providers.barcode import Provider as BarcodeProvider



ProductUnit = []
ProductCategory = []
Product = []
Products = {"Products": []}

engine = sa.create_engine('postgresql+psycopg2://admin:admin@192.168.31.190/store_chain')


with engine.connect() as conn:
    resultunit = conn.execute(sa.text('select "UnitName" from "dic"."ProductUnit" pu;'))
    for row in resultunit:
        ProductUnit.append(row[0])
    recultcat = conn.execute(sa.text('WITH RECURSIVE CategoryTree AS ('
                                     'select "ID", "CategoryName", "ParentCategory", 0 as level '
                                     'from dic."ProductCategory" '
                                     'where "ParentCategory" isnull '
                                     'union all '
                                     'select c."ID", c."CategoryName", c."ParentCategory", ct.level + 1 '
                                     'from dic."ProductCategory" c '
                                     'inner join CategoryTree ct on c."ParentCategory" = ct."ID") '
                                     'select "CategoryName" from CategoryTree where level > 1;'))
    for row in recultcat:
        ProductCategory.append(row[0])



for i in range(100000):
    # f = Faker(['ru_RU'])
    fake = Faker('ru_RU')
    fake.add_provider('faker.providers.barcode')
    fake.add_provider('faker.provider.lorem.ru_RU')
    fake.add_provider('faker.provider.finance')
    fakeEAN = fake.ean()
    fakeGOODS = fake.words(nb=2)
    fakePRICE = fake.pricetag()
    fakePRICE = (int(re.sub(r'[^0-9]', '', fakePRICE))/100)
    fakeUNIT = fake.random_element(elements=ProductUnit)
    fakeCATEGORY = []
    fakeCATEGORY.append(fake.random_element(elements=ProductCategory))
    prod = {"Name": ' '.join(fakeGOODS), "Unit": fakeUNIT, "Category": fakeCATEGORY,
            "Price": fakePRICE, "EAN": fakeEAN, "PriceList": 607}
    Products["Products"].append(prod)



with engine.connect() as conn:
    conn.execute(sa.text(f"call dic.products_add('{json.dumps(Products, ensure_ascii=False)}')"))
    # res = sa.func.products_add(Products)
    # print(res)
    conn.commit()