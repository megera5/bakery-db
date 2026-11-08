CREATE DATABASE bakery;

CREATE SCHEMA IF NOT EXISTS bakery_3nf;
SET search_path TO bakery_3nf;

CREATE TABLE positions (
    position_id   SERIAL PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    position_id INT NOT NULL REFERENCES positions(position_id),
    last_name   VARCHAR(50) NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    phone       VARCHAR(20),
    email       VARCHAR(100)
);

CREATE TABLE customers (
    customer_id    SERIAL PRIMARY KEY,
    org_name       VARCHAR(150) NOT NULL,
    inn            VARCHAR(12)  NOT NULL UNIQUE,
    contact_person VARCHAR(100),
    phone          VARCHAR(20),
    email          VARCHAR(100),
    address        VARCHAR(200)
);

CREATE TABLE product_categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE units (
    unit_id   SERIAL PRIMARY KEY,
    unit_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id       SERIAL PRIMARY KEY,
    article          VARCHAR(20)  NOT NULL UNIQUE,
    category_id      INT NOT NULL REFERENCES product_categories(category_id),
    unit_id          INT NOT NULL REFERENCES units(unit_id),
    product_name     VARCHAR(100) NOT NULL,
    weight_g         INT CHECK (weight_g > 0),
    shelf_life_hours INT CHECK (shelf_life_hours > 0),
    price            NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE request_statuses (
    status_id   SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE requests (
    request_id            SERIAL PRIMARY KEY,
    customer_id           INT NOT NULL REFERENCES customers(customer_id),
    employee_id           INT NOT NULL REFERENCES employees(employee_id),
    status_id             INT NOT NULL REFERENCES request_statuses(status_id),
    request_date          DATE NOT NULL DEFAULT CURRENT_DATE,
    desired_delivery_date DATE NOT NULL,
    delivery_address      VARCHAR(200) NOT NULL,
    comment               TEXT,
    CHECK (desired_delivery_date >= request_date)
);

CREATE TABLE request_items (
    request_item_id SERIAL PRIMARY KEY,
    request_id      INT NOT NULL REFERENCES requests(request_id) ON DELETE CASCADE,
    product_id      INT NOT NULL REFERENCES products(product_id),
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (request_id, product_id)
);

CREATE TABLE request_status_history (
    history_id  SERIAL PRIMARY KEY,
    request_id  INT NOT NULL REFERENCES requests(request_id) ON DELETE CASCADE,
    status_id   INT NOT NULL REFERENCES request_statuses(status_id),
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    changed_at  TIMESTAMP NOT NULL DEFAULT now(),
    comment     TEXT
);

INSERT INTO request_statuses (status_name) VALUES
    ('Новая'),
    ('Принята'),
    ('Подтверждена'),
    ('Передана в производство'),
    ('Отклонена');
