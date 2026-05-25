import json
import faker.providers.address.ko_KR
import sqlalchemy as sa
from faker.proxy import Faker
from pymysql import connect, NULL
from sqlalchemy import true, Connection

db_url = "mysql+pymysql://root:12345@192.168.31.190:3309/otus"
engine = sa.create_engine(db_url, echo=False)
cashier_role = []


def get_dadata(source):
    from dadata import Dadata
    with open('./token.txt', 'r', encoding='utf-8') as file:
        token_txt = json.load(file)
    token = token_txt['token']
    secret = token_txt['secret']
    dadata = Dadata(token, secret)
    return dadata.clean("address", source)


def chek_index(index):
    index_id = ''
    sql_text = f'select id from PostalCode where PostalCode = \'{index}\';'
    sql_text_add = f'insert into PostalCode (PostalCode) values (\'{index}\');'
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            index_id = i_id.fetchall()[0][0]
        else:
            index_id = sql_select_fetch[0][0]
        c_sql.commit()
    return index_id

def chek_region_type(region_type, region_desc):
    region_type_id = ''
    sql_text = f'SELECT id from  RegionType where RegionType = \'{region_type}\' and Description = \'{region_desc}\';'
    sql_text_add = f'insert into RegionType (RegionType, Description) values (\'{region_type}\', \'{region_desc}\');'
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            region_type_id = i_id.fetchall()[0][0]
        else:
            region_type_id = sql_select_fetch[0][0]
        c_sql.commit()
    return region_type_id


def chek_region(RegionName, RegionType, RegionType_desc, FederalDistrict, TimeZone):
    region_id = ''
    sql_text = (f'select id from Region where RegionName = \'{RegionName}\';')
    RegionTypeId = chek_region_type(RegionType, RegionType_desc)
    sql_text_add = (f'insert into Region (RegionName, RegionTypeId, FederalDistrict, TimeZone) '
                    f'values (\'{RegionName}\', \'{RegionTypeId}\', \'{FederalDistrict}\', \'{TimeZone}\');')
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            region_id = i_id.fetchall()[0][0]
        else:
            region_id = sql_select_fetch[0][0]
        c_sql.commit()
    return region_id


def chek_city_type(city_type, city_desc):
    city_type_id = ''
    sql_text = f'SELECT id from  CityType where CityType = \'{city_type}\' and Description = \'{city_desc}\';'
    sql_text_add = f'insert into CityType (CityType, Description) values (\'{city_type}\', \'{city_desc}\');'
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            city_type_id = i_id.fetchall()[0][0]
        else:
            city_type_id = sql_select_fetch[0][0]
        c_sql.commit()
    return city_type_id


def chek_settlement_type(settlement_type, settlement_desc):
    settlement_type_id = ''
    sql_text = (f'SELECT id from  SettelmentType where SettelmentType = \'{settlement_type}\' '
                f'and Description = \'{settlement_desc}\';')
    sql_text_add = (f'insert into SettelmentType (SettelmentType, Description) '
                    f'values (\'{settlement_type}\', \'{settlement_desc}\');')
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            settlement_type_id = i_id.fetchall()[0][0]
        else:
            settlement_type_id = sql_select_fetch[0][0]
        c_sql.commit()
    return settlement_type_id


def chek_street_type(street_type, street_desc):
    street_type_id = ''
    sql_text = (f'SELECT id from  StreetType where StreetType = \'{street_type}\' '
                f'and Description = \'{street_desc}\';')
    sql_text_add = (f'insert into StreetType (StreetType, Description) '
                    f'values (\'{street_type}\', \'{street_desc}\');')
    with engine.connect() as c_sql:
        sql_select = c_sql.execute(sa.text(sql_text))
        sql_select_fetch = sql_select.fetchall()
        len_id = len(sql_select_fetch)
        if len_id == 0:
            c_sql.execute(sa.text(sql_text_add))
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            street_type_id = i_id.fetchall()[0][0]
        else:
            street_type_id = sql_select_fetch[0][0]
        c_sql.commit()
    return street_type_id


def add_address(RegionId, PostalCodeId, City, CityTypeId, Settelment, SettelmentTypeId, Street, StreetTypeId, House):
    with engine.connect() as c_sql:
            c_sql.execute(sa.text("Insert into Address (RegionId, PostalCodeId, "
                                  "City, CityTypeId, Settelment, SettelmentTypeId, "
                                  "Street, StreetTypeId, House) values (:RegionId, :PostalCodeId, :City, :CityTypeId, "
                                  ":Settelment, :SettelmentTypeId, :Street, :StreetTypeId, :House)"),
                          {'RegionId': RegionId,
                           'PostalCodeId': PostalCodeId,
                           'City': City,
                           'CityTypeId': CityTypeId,
                           'Settelment': Settelment,
                           'SettelmentTypeId': SettelmentTypeId,
                           'Street': Street,
                           'StreetTypeId': StreetTypeId,
                           'House': House
                           }
                          )
            i_id = c_sql.execute(sa.text('SELECT LAST_INSERT_ID();'))
            address_id = i_id.fetchall()[0][0]
            c_sql.commit()
    return address_id


# with engine.connect() as conn: #заполняем справочник ролей кассиров
#     cr = conn.execute(sa.text('SELECT `ID` from `Role` r;'))
#     for i in cr:
#         cashier_role.append(i[0])
#     conn.commit()
#
#
# for i in range(9998):
#     fake = Faker('ru_RU')
#     fake_hiring_date = fake.date_between(start_date='-3y', end_date='today')
#     fake_firing_date = fake.date_between(start_date=fake_hiring_date, end_date='today')
#     # sql_text = (f'INSERT INTO Cashier (FirstName, LastName, PatronymicName, Hiring, Firing, RoleId)'
#     #             f'VALUES (\'{fake.first_name()}\', \'{fake.last_name()}\', \'{fake.middle_name_male()}\','
#     #             f' \'{fake_hiring_date}\', \'{fake_firing_date}\','
#     #             f' \'{fake.random_element(cashier_role)}\');')
#     sql_text = (f'INSERT INTO Cashier (FirstName, LastName, PatronymicName, Hiring, RoleId)'
#                 f'VALUES (\'{fake.first_name()}\', \'{fake.last_name()}\', \'{fake.middle_name_male()}\','
#                 f' \'{fake_hiring_date}\','
#                 f' \'{fake.random_element(cashier_role)}\');')
#     print(sql_text)
#     with engine.connect() as conn:
#         conn.execute(sa.text(sql_text))
#         conn.commit()


# Создаём магазины



for i in range(1):
    fake = Faker('ru_RU')
    fake_address = fake.address()
    fad = get_dadata(fake_address)
    faj = {'postal_code':fad['postal_code'],
                         'country_iso_code':fad['country_iso_code'],
                         'federal_district':fad['federal_district'],
                         'region_type':fad['region_type'],
                         'region_type_full':fad['region_type_full'],
                         'region':fad['region'],
                         'city_type':fad['city_type'],
                         'city_type_full':fad['city_type_full'],
                         'city':fad['city'],
                         'settlement_type':fad['settlement_type'],
                         'settlement_type_full':fad['settlement_type_full'],
                         'settlement':fad['settlement'],
                         'street_type':fad['street_type'],
                         'street_type_full':fad['street_type_full'],
                         'street':fad['street'],
                         'house':fad['house'],
                         'timezone':fad['timezone']}
    RegionId = chek_region(faj['region'], faj['region_type'],
                           faj['region_type_full'], faj['federal_district'], faj['timezone'])
    PostalCodeId = chek_index(faj['postal_code'])
    # if faj['city_type'] <> None:
    #     CityTypeId = chek_city_type(faj['city_type'], faj['city_type_full'])
    print(faj)
    CityTypeId = None if faj['city_type'] == None else chek_city_type(faj['city_type'], faj['city_type_full'])
    SettelmentTypeId = None if faj['settlement_type'] == None else chek_settlement_type(faj['settlement_type'], faj['settlement_type_full'])
    StreetTypeId = None if faj['street_type'] == None else chek_street_type(faj['street_type'], faj['street_type_full'])
    if faj['country_iso_code'] == 'RU':
        address_id = add_address(RegionId, PostalCodeId, faj['city'], CityTypeId, faj['settlement'], SettelmentTypeId, faj['street'], StreetTypeId, faj['house'])
        print(address_id)
        with engine.connect() as conn:
            conn.execute(sa.text('insert into Store (StoreName, Organization, INN, '
                                 'AddressId, StartTime, EndTime) values (:StoreName, :Organization, :INN, '
                                 ':AddressId, :StartTime, :EndTime);'), {
                'StoreName': f'{address_id} {(fake.words(nb=1))[0]}',
                'Organization': 'ООО Пучок',
                'INN': '2243148700',
                'AddressId': address_id,
                'StartTime': '07:00',
                'EndTime': '23:00'
            })
            conn.commit()
    else:
        print(faj['country_iso_code'])




    # print(json.dumps(fad, indent=4, ensure_ascii=False))
