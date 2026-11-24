-- 0. Создание типов ENUM для PostgreSQL
CREATE TYPE master_spec AS ENUM ('Механик', 'Электрик', 'Кузовщик', 'Диагност');
CREATE TYPE order_status AS ENUM ('Новый', 'В работе', 'Ожидает запчасти', 'Выполнен', 'Отменен');

CREATE TABLE brand (
    id_brand INT PRIMARY KEY,
    name_brand VARCHAR(100) NOT NULL
);
CREATE TABLE car_model (
    id_model INT PRIMARY KEY,
    id_brand INT NOT NULL,
    name_model VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_brand) REFERENCES brand(id_brand)
);

CREATE TABLE client (
    id_client INT PRIMARY KEY,
    fio VARCHAR(255) NOT NULL,
    telephone VARCHAR(11) NOT NULL,
    email VARCHAR(50) NULL
);

CREATE TABLE car (
    vin_code VARCHAR(17) PRIMARY KEY,
    id_client INT NOT NULL,
    id_model INT NOT NULL,
    year_of_manufacture INT NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_model) REFERENCES car_model(id_model)
);

CREATE TABLE master (
    id_master INT PRIMARY KEY,
    fio_master VARCHAR(255) NOT NULL,
    telephone VARCHAR(11) NOT NULL,
    specialization master_spec NOT NULL
);

CREATE TABLE service (
    id_service INT PRIMARY KEY,
    name_service VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    id_order INT PRIMARY KEY,
    id_client INT NOT NULL,
    vin_code VARCHAR(17) NOT NULL,
    date_received DATE NOT NULL,
    date_completed DATE NULL,
    status order_status NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (vin_code) REFERENCES car(vin_code)
);

CREATE TABLE order_detail (
    id_order INT NOT NULL,
    id_service INT NOT NULL,
    id_master INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_order, id_service),
    FOREIGN KEY (id_order) REFERENCES orders(id_order),
    FOREIGN KEY (id_service) REFERENCES service(id_service),
    FOREIGN KEY (id_master) REFERENCES master(id_master)
);

INSERT INTO brand (id_brand, name_brand) VALUES
(1, 'Toyota'),
(2, 'Kia'),
(3, 'Hyundai'),
(4, 'Lada'),
(5, 'BMW'),
(6, 'Volkswagen'),
(7, 'Skoda');

INSERT INTO car_model (id_model, id_brand, name_model) VALUES
(1, 1, 'Camry'),
(2, 1, 'RAV4'),
(3, 2, 'Rio'),
(4, 2, 'Sportage'),
(5, 3, 'Solaris'),
(6, 4, 'Vesta'),
(7, 5, 'X5'),
(8, 6, 'Polo'),
(9, 7, 'Octavia');

INSERT INTO client (id_client, fio, telephone, email) VALUES
(1, 'Иванов Алексей Сергеевич', '89041234567', 'ivanov@mail.ru'),
(2, 'Смирнова Елена Викторовна', '89129876543', 'smirnova@gmail.com'),
(3, 'Кузнецов Дмитрий Андреевич', '89225554433', NULL),
(4, 'Попова Анна Николаевна', '89087778899', 'popova@yandex.ru'),
(5, 'Соколов Максим Игоревич', '89501112233', 'sokolov@mail.ru'),
(6, 'Морозова Ольга Павловна', '89824445566', NULL);

INSERT INTO car (vin_code, id_client, id_model, year_of_manufacture) VALUES
('JTNBF46K103012345', 1, 1, 2019), -- Toyota Camry (Иванов)
('Z94CB41BAGR123456', 1, 5, 2021), -- Hyundai Solaris (Иванов)
('XWEHC512AB0065432', 2, 3, 2018), -- Kia Rio (Смирнова)
('XTA219010J0543210', 3, 6, 2022), -- Lada Vesta (Кузнецов)
('WBAKS410900H98765', 4, 7, 2020), -- BMW X5 (Попова)
('XW8ZZZ61ZJG011223', 5, 8, 2017), -- Volkswagen Polo (Соколов)
('TMBJG7NE5K0099887', 6, 9, 2023); -- Skoda Octavia (Морозова)


INSERT INTO master (id_master, fio_master, telephone, specialization) VALUES
(1, 'Петров Сергей Иванович', '89040001122', 'Механик'),
(2, 'Волков Андрей Петрович', '89120003344', 'Электрик'),
(3, 'Зайцев Игорь Владимирович', '89220005566', 'Диагност'),
(4, 'Новиков Павел Олегович', '89080007788', 'Кузовщик');


INSERT INTO service (id_service, name_service) VALUES
(1, 'Замена масла и фильтров'),
(2, 'Компьютерная диагностика'),
(3, 'Замена тормозных колодок'),
(4, 'Ремонт электропроводки'),
(5, 'Покраска бампера'),
(6, 'Развал-схождение'),
(7, 'Заправка кондиционера');


INSERT INTO orders (id_order, id_client, vin_code, date_received, date_completed, status) VALUES
(1, 1, 'JTNBF46K103012345', '2026-11-10', '2026-11-11', 'Выполнен'),
(2, 2, 'XWEHC512AB0065432', '2026-11-18', NULL, 'В работе'),           -- Смирнова сейчас в ремонте
(3, 3, 'XTA219010J0543210', '2026-11-19', NULL, 'Ожидает запчасти'),   -- Кузнецов сейчас в ремонте
(4, 4, 'WBAKS410900H98765', '2026-11-15', '2026-11-17', 'Выполнен'),
(5, 5, 'XW8ZZZ61ZJG011223', '2026-11-22', NULL, 'Новый'),              -- Соколов только сдал авто
(6, 1, 'Z94CB41BAGR123456', '2026-11-23', NULL, 'В работе');           -- Иванов (вторая машина) сейчас в ремонте


INSERT INTO order_detail (id_order, id_service, id_master, price) VALUES
(1, 1, 1, 3500.00),
(1, 6, 1, 2000.00),
(2, 2, 3, 1800.00),
(2, 4, 2, 4500.00),
(3, 5, 4, 12000.00),
(4, 1, 1, 5000.00),
(4, 3, 1, 6500.00),
(4, 2, 3, 2500.00),
(5, 2, 3, 1500.00),
(6, 3, 1, 3200.00);