CREATE SCHEMA IF NOT EXISTS bakery_dv;
SET search_path TO bakery_dv;


CREATE TABLE hub_customer (
    customer_hk   CHAR(32) PRIMARY KEY,           
    customer_bk   VARCHAR(12) NOT NULL UNIQUE,    
    load_dts      TIMESTAMP NOT NULL DEFAULT now(),
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_employee (
    employee_hk   CHAR(32) PRIMARY KEY,            
    employee_bk   VARCHAR(20) NOT NULL UNIQUE,    
    load_dts      TIMESTAMP NOT NULL DEFAULT now(),
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_product (
    product_hk    CHAR(32) PRIMARY KEY,           
    product_bk    VARCHAR(20) NOT NULL UNIQUE,    
    load_dts      TIMESTAMP NOT NULL DEFAULT now(),
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_request (
    request_hk    CHAR(32) PRIMARY KEY,           
    request_bk    VARCHAR(20) NOT NULL UNIQUE,    
    load_dts      TIMESTAMP NOT NULL DEFAULT now(),
    record_source VARCHAR(50) NOT NULL
);


CREATE TABLE lnk_request_party (
    request_party_hk CHAR(32) PRIMARY KEY,      
    request_hk       CHAR(32) NOT NULL REFERENCES hub_request(request_hk),
    customer_hk      CHAR(32) NOT NULL REFERENCES hub_customer(customer_hk),
    employee_hk      CHAR(32) NOT NULL REFERENCES hub_employee(employee_hk),
    load_dts         TIMESTAMP NOT NULL DEFAULT now(),
    record_source    VARCHAR(50) NOT NULL,
    UNIQUE (request_hk, customer_hk, employee_hk)
);

CREATE TABLE lnk_request_product (
    request_product_hk CHAR(32) PRIMARY KEY,    
    request_hk         CHAR(32) NOT NULL REFERENCES hub_request(request_hk),
    product_hk         CHAR(32) NOT NULL REFERENCES hub_product(product_hk),
    load_dts           TIMESTAMP NOT NULL DEFAULT now(),
    record_source      VARCHAR(50) NOT NULL,
    UNIQUE (request_hk, product_hk)
);


CREATE TABLE sat_customer (
    customer_hk    CHAR(32) NOT NULL REFERENCES hub_customer(customer_hk),
    load_dts       TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts   TIMESTAMP,
    record_source  VARCHAR(50) NOT NULL,
    hash_diff      CHAR(32) NOT NULL,
    org_name       VARCHAR(150),
    contact_person VARCHAR(100),
    phone          VARCHAR(20),
    email          VARCHAR(100),
    address        VARCHAR(200),
    PRIMARY KEY (customer_hk, load_dts)
);

CREATE TABLE sat_employee (
    employee_hk   CHAR(32) NOT NULL REFERENCES hub_employee(employee_hk),
    load_dts      TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts  TIMESTAMP,
    record_source VARCHAR(50) NOT NULL,
    hash_diff     CHAR(32) NOT NULL,
    last_name     VARCHAR(50),
    first_name    VARCHAR(50),
    middle_name   VARCHAR(50),
    position_name VARCHAR(100),
    phone         VARCHAR(20),
    email         VARCHAR(100),
    PRIMARY KEY (employee_hk, load_dts)
);

CREATE TABLE sat_product (
    product_hk       CHAR(32) NOT NULL REFERENCES hub_product(product_hk),
    load_dts         TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts     TIMESTAMP,
    record_source    VARCHAR(50) NOT NULL,
    hash_diff        CHAR(32) NOT NULL,
    product_name     VARCHAR(100),
    category_name    VARCHAR(100),
    unit_name        VARCHAR(20),
    weight_g         INT,
    shelf_life_hours INT,
    price            NUMERIC(10, 2),
    PRIMARY KEY (product_hk, load_dts)
);

CREATE TABLE sat_request (
    request_hk            CHAR(32) NOT NULL REFERENCES hub_request(request_hk),
    load_dts              TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts          TIMESTAMP,
    record_source         VARCHAR(50) NOT NULL,
    hash_diff             CHAR(32) NOT NULL,
    request_date          DATE,
    desired_delivery_date DATE,
    delivery_address      VARCHAR(200),
    comment               TEXT,
    PRIMARY KEY (request_hk, load_dts)
);

CREATE TABLE sat_request_status (
    request_hk     CHAR(32) NOT NULL REFERENCES hub_request(request_hk),
    load_dts       TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts   TIMESTAMP,
    record_source  VARCHAR(50) NOT NULL,
    hash_diff      CHAR(32) NOT NULL,
    status_name    VARCHAR(50),
    status_comment TEXT,
    changed_by_bk  VARCHAR(20),            
    PRIMARY KEY (request_hk, load_dts)
);

CREATE TABLE sat_request_product (
    request_product_hk CHAR(32) NOT NULL REFERENCES lnk_request_product(request_product_hk),
    load_dts           TIMESTAMP NOT NULL DEFAULT now(),
    load_end_dts       TIMESTAMP,
    record_source      VARCHAR(50) NOT NULL,
    hash_diff          CHAR(32) NOT NULL,
    quantity           INT,
    unit_price         NUMERIC(10, 2),
    PRIMARY KEY (request_product_hk, load_dts)
);

INSERT INTO hub_customer (customer_hk, customer_bk, record_source)
VALUES (md5('7701234567'), '7701234567', 'request_system');
