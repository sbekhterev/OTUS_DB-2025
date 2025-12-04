--Заполняем справочник тип поселений
INSERT INTO dic."SettelmentType" ("SettelmentType", "SettelmentTypeFull" )
VALUES
('С', 'Село'),
('П', 'Посёлок'),
('Ст', 'Станция'),
('Р', 'Разъезд'),
('Х', 'Хутор'),
('Д', 'Деревня')
ON CONFLICT DO  NOTHING;
--Заполняем справочник тип регионов
INSERT INTO dic."RegionType" ("RegionType", "RegionTypeFull")
VALUES
('Респ', 'республика'),
('обл', 'область'),
('край', 'край'),
('г', 'город')
ON CONFLICT DO  NOTHING;
--Заполняем справочник регионы
INSERT INTO dic."Region" ("RegionName", "RegionTypeId", "FederalDistrict", "TimeZone")
VALUES
('Саратовская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Приволжский', 'Europe/Saratov'),
('Воронежская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Центральный', 'Europe/Moscow'),
('Татарстан', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'республика'), 'Приволжский', 'Europe/Moscow'),
('Пермский', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'край'), 'Приволжский', 'Asia/Yekaterinburg'),
('Волгоградская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Южный', 'Europe/Volgograd'),
('Удмуртская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'республика'), 'Приволжский', 'Asia/Yekaterinburg'),
('Ростовская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Южный', 'Europe/Moscow'),
('Саратовская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Приволжский', 'Europe/Saratov'),
('Воронежская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Центральный', 'Europe/Moscow'),
('Башкортостан', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'республика'), 'Приволжский', 'Asia/Yekaterinburg'),
('Краснодарский', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'край'), 'Южный', 'Europe/Moscow'),
('Волгоградская', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'область'), 'Южный', 'Europe/Volgograd'),
('Санкт-Петербург', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'город'), 'Северо-Западный', 'Europe/Moscow'),
('Татарстан', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'республика'), 'Приволжский', 'Europe/Moscow'),
('Пермский', (SELECT r."ID" FROM "RegionType" r WHERE r."RegionTypeFull" = 'край'), 'Приволжский', 'Asia/Yekaterinburg')
ON CONFLICT DO NOTHING;
--Заполняем справочник типов улиц и городов
INSERT INTO dic."CityType" ("CityType" , "CityTypeFull" ) VALUES ('г', 'город');
INSERT INTO dic."StreetType"  ("StreetType", "StreetTypeFull" ) VALUES ('ул', 'улица');
--Заполняем справочник Адресов
INSERT INTO dic."Address" ("RegionId", "PostalCode", "City", "CityTypeId", "Street", "StreetTypeId", "House")
VALUES
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Удмуртская'), '426019', 'Ижевск', 32, 'Западная', 33, '24'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Саратовская'), '410076', 'Саратов', 32, 'Верхняя', 33, '15'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Волгоградская'), '400012', 'Волгоград', 32, 'Дорожная', 33, '33'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Санкт-Петербург'), '197046', null, 32, 'Куйбышева', 33, '30'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Краснодарский'), '350910', 'Краснодар', 32, 'им. Пушкина', 33, '30'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Пермский'), '614058', 'Пермь', 32, 'Озерная', 33, '11'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Волгоградская'), '400066', 'Волгоград', 32, 'Труда', 33, '42'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Татарстан'), '420012', 'Казань', 32, 'Овражная', 33, '27'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Саратовская'), '410050', 'Саратов', 32, 'Красноармейская', 33, '29'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Ростовская'), '344011', 'Ростов-на-Дону', 32, 'Красноармейская', 33, '17'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Башкортостан'), '450052', 'Уфа', 32, 'Дзержинского', 33, '50'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Татарстан'), '420099', 'Казань', 32, 'Почтовая', 33, '42'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Воронежская'), '394011', 'Воронеж', 32, 'Речная', 33, '16'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Воронежская'), '394030', 'Воронеж', 32, 'Средне-Московская', 33, '7'),
((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Пермский'), '614000', 'Пермь', 32, 'Механизаторов', 33, '44')
ON CONFLICT DO NOTHING;
--Заполняем справочник Магазинов
INSERT INTO dic."Store" ("StoreName", "AddressId", "INN", "Organization", "StartTime", "EndTime")
SELECT concat('Магазин-', COALESCE(a."Settelment", a."City", (SELECT r."RegionName"  FROM dic."Region" r WHERE r."ID" = a."RegionId")), '-', a."Street" ) AS store_name,
		a."ID", '7725858900' AS inn, 'ООО "Ромашка"' AS org, '09:00' AS StartTime, '23:00' AS EndTime
FROM dic."Address" a
ON CONFLICT DO NOTHING;
--Заполняем справочник терминалов
INSERT INTO dic."Terminal" ("TerminalName", "StoreId", "ZNKKT", "FNKKT" )
SELECT 'Алкоголь', s."ID", uuid_generate_v4(), floor(random() * 1000000000000)  FROM dic."Store" s;
--Заполняем справочник Кассиров
INSERT INTO dic."Cashier" ("LastName", "FirstName", "PatronymicName", "RoleId", "Hiring" )
values
('Иванова', 'Cофия', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Федоров', 'Мирон', 'Тимофеевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Самсонов', 'Тимур', 'Михайлович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Николаева', 'Агния', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Филиппова', 'Софья', 'Михайловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Волков', 'Кирилл', 'Маркович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Анисимова', 'Екатерина', 'Дмитриевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Архипова', 'Виктория', 'Матвеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Булатов', 'Григорий', 'Станиславович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Синицын', 'Александр', 'Семёнович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Тихонова', 'Лейла', 'Сергеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Спиридонов', 'Максим', 'Андреевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Елизаров', 'Матвей', 'Матвеевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Киреева', 'Ульяна', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Власов', 'Даниил', 'Дмитриевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Ильина', 'Елизавета', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Кочетова', 'Амина', 'Станиславовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Маслова', 'Елизавета', 'Тимофеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Кондратьева', 'Малика', 'Константиновна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Бессонова', 'Мария', 'Ярославовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Золотарева', 'София', 'Данииловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Фролов', 'Егор', 'Фёдорович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Демидова', 'Арина', 'Львовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Николаева', 'Ксения', 'Михайловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Попова', 'Дарья', 'Тимофеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Иванова', 'Василиса', 'Егоровна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Михайлов', 'Артём', 'Артемьевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Пахомов', 'Александр', 'Михайлович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Фролова', 'Мария', 'Ярославовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Семенова', 'Вероника', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Михайлова', 'Екатерина', 'Михайловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Воронин', 'Даниил', 'Романович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Васильев', 'Дмитрий', 'Миронович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Васильев', 'Александр', 'Александрович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Терентьева', 'Мирослава', 'Тимофеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Зиновьев', 'Александр', 'Антонович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Иванов', 'Али', 'Игоревич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Анисимова', 'Виктория', 'Николаевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Борисов', 'Роман', 'Никитич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Волкова', 'Мелания', 'Лукинична', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Короткова', 'Татьяна', 'Львовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Сергеева', 'Арина', 'Тимофеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Бородин', 'Максим', 'Михайлович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Тимофеев', 'Олег', 'Александрович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Шаповалова', 'Камила', 'Дмитриевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Алексеев', 'Михаил', 'Фёдорович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Воронкова', 'Вера', 'Георгиевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Комиссарова', 'Мария', 'Сергеевна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Максимов', 'Юрий', 'Фёдорович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Леонтьев', 'Всеволод', 'Владимирович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Панин', 'Артём', 'Артёмович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Петрова', 'Амина', 'Романовна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Терехова', 'Альбина', 'Мироновна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Сидорова', 'Таисия', 'Кирилловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Лебедев', 'Тимофей', 'Матвеевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Гришина', 'София', 'Ивановна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Чумакова', 'Злата', 'Семёновна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Григорьев', 'Илья', 'Арсентьевич', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Кузнецова', 'Мия', 'Михайловна', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date)),
('Борисов', 'Максим', 'Ярославович', (SELECT floor(random() * (141 - 140 + 1) + 140)), (SELECT (random() * ('2025-09-23'::timestamp - '2023-09-23'::timestamp) + '2023-09-23'::timestamp)::date));
--Заполняем справочник единиц измерения товара
INSERT INTO dic."ProductUnit" ("UnitName", "UnitType" ) VALUES ('шт', 'штучный товар'), ('кг', 'весовой товар');
--Заполняем справочник категории товаров
INSERT INTO dic."ProductCategory" ("CategoryName", "ParentCategory" ) VALUES
('Штучный товар', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары')),
('Весовой товар', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'));
INSERT INTO dic."ProductCategory" ("CategoryName", "ParentCategory" ) VALUES
('Штучный товар', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Непродовольственные товары')),
('Весовой товар', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Непродовольственные товары'));
INSERT INTO dic."ProductCategory" ("CategoryName", "ParentCategory" ) VALUES
('Напитки', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Хлеб', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Колбаса', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Сыр', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Яйцо', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Молоко', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Штучный товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары')));
INSERT INTO dic."ProductCategory" ("CategoryName", "ParentCategory" ) VALUES
('Овощи', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Фрукты', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Пельмени', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Салаты', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Яйцо', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары'))),
('Молоко', (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Весовой товар' AND pc."ParentCategory" = (SELECT "ID" FROM dic."ProductCategory" pc WHERE pc."CategoryName" = 'Продовольственные товары')));
