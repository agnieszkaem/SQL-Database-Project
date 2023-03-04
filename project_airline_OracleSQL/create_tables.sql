CREATE TABLE airplanes (
    airplane_id        VARCHAR2(5) NOT NULL,
    manufacturer       VARCHAR2(20),
    model              VARCHAR2(10) NOT NULL,
    aircraft_fuselage  VARCHAR2(15)
);

ALTER TABLE airplanes ADD CONSTRAINT airplanes_pk PRIMARY KEY ( airplane_id );

CREATE TABLE airports (
    airport_id  VARCHAR2(4) NOT NULL,
    name        VARCHAR2(50) NOT NULL,
    location    VARCHAR2(30),
    country_id  VARCHAR2(4) NOT NULL
);

ALTER TABLE airports ADD CONSTRAINT airports_pk PRIMARY KEY ( airport_id );

CREATE TABLE charges (
    charge_id    NUMBER(1) NOT NULL,
    name         VARCHAR2(20) NOT NULL,
    price_eur    NUMBER NOT NULL,
    description  VARCHAR2(60)
);

ALTER TABLE charges ADD CONSTRAINT charges_pk PRIMARY KEY ( charge_id );

CREATE TABLE countries (
    country_id  VARCHAR2(4) NOT NULL,
    name        VARCHAR2(30) NOT NULL,
    capital     VARCHAR2(30) NOT NULL,
    currency    VARCHAR2(4)
);

ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY ( country_id );

CREATE TABLE departments (
    dep_id    NUMBER(1) NOT NULL,
    name      VARCHAR2(20) NOT NULL,
    director  VARCHAR2(30),
    contact   VARCHAR2(40) NOT NULL
);

ALTER TABLE departments ADD CONSTRAINT departments_pk PRIMARY KEY ( dep_id );

CREATE TABLE employees (
    emp_id     NUMBER(4) NOT NULL,
    name       VARCHAR2(20) NOT NULL,
    surname    VARCHAR2(30) NOT NULL,
    hire_date  DATE,
    salary     NUMBER(4),
    dep_id     NUMBER(1) NOT NULL
);

ALTER TABLE employees ADD CONSTRAINT employees_pk PRIMARY KEY ( emp_id );

CREATE TABLE flight_employee (
    flight_id  NUMBER(3) NOT NULL,
    emp_id     NUMBER(4) NOT NULL
);

ALTER TABLE flight_employee ADD CONSTRAINT flight_employee_pk PRIMARY KEY ( flight_id,
                                                                            emp_id );

CREATE TABLE flights (
    flight_id  NUMBER(3) NOT NULL,
    departure  DATE NOT NULL,
    arrival    DATE NOT NULL,
    route_id   VARCHAR2(5) NOT NULL
);

ALTER TABLE flights ADD CONSTRAINT flights_pk PRIMARY KEY ( flight_id );

CREATE TABLE passengers (
    p_id          NUMBER(4) NOT NULL,
    name          VARCHAR2(20) NOT NULL,
    surname       VARCHAR2(30) NOT NULL,
    contact_mail  VARCHAR2(50),
    country_id    VARCHAR2(4) NOT NULL
);

ALTER TABLE passengers ADD CONSTRAINT passengers_pk PRIMARY KEY ( p_id );

CREATE TABLE routes (
    route_id      VARCHAR2(5) NOT NULL,
    duration      NUMBER(3),
    departure_id  VARCHAR2(4) NOT NULL,
    arrival_id    VARCHAR2(4) NOT NULL,
    airplane_id   VARCHAR2(5) NOT NULL
);

ALTER TABLE routes ADD CONSTRAINT routes_pk PRIMARY KEY ( route_id );

CREATE TABLE ticket_charge (
    charge_id  NUMBER(1) NOT NULL,
    ticket_id  VARCHAR2(6) NOT NULL
);

ALTER TABLE ticket_charge ADD CONSTRAINT ticket_charge_pk PRIMARY KEY ( charge_id,
                                                                        ticket_id );

CREATE TABLE tickets (
    ticket_id     VARCHAR2(6) NOT NULL,
    booking_date  DATE,
    seat          VARCHAR2(3) NOT NULL,
    flight_id     NUMBER(3) NOT NULL,
    tc_id         VARCHAR2(3) NOT NULL,
    p_id          NUMBER(4) NOT NULL
);

ALTER TABLE tickets ADD CONSTRAINT tickets_pk PRIMARY KEY ( ticket_id );

CREATE TABLE travel_classes (
    tc_id       VARCHAR2(3) NOT NULL,
    name        VARCHAR2(20) NOT NULL,
    luggage_kg  NUMBER(2) NOT NULL,
    food_offer  CHAR(1),
    vip_lounge  CHAR(1)
);

ALTER TABLE travel_classes ADD CONSTRAINT travel_classes_pk PRIMARY KEY ( tc_id );

ALTER TABLE airports
    ADD CONSTRAINT airports_countries_fk FOREIGN KEY ( country_id )
        REFERENCES countries ( country_id );

ALTER TABLE employees
    ADD CONSTRAINT employees_departments_fk FOREIGN KEY ( dep_id )
        REFERENCES departments ( dep_id );

ALTER TABLE flight_employee
    ADD CONSTRAINT flight_employee_employees_fk FOREIGN KEY ( emp_id )
        REFERENCES employees ( emp_id );

ALTER TABLE flight_employee
    ADD CONSTRAINT flight_employee_flights_fk FOREIGN KEY ( flight_id )
        REFERENCES flights ( flight_id );

ALTER TABLE flights
    ADD CONSTRAINT flights_routes_fk FOREIGN KEY ( route_id )
        REFERENCES routes ( route_id );

ALTER TABLE passengers
    ADD CONSTRAINT passengers_countries_fk FOREIGN KEY ( country_id )
        REFERENCES countries ( country_id );

ALTER TABLE routes
    ADD CONSTRAINT routes_airplanes_fk FOREIGN KEY ( airplane_id )
        REFERENCES airplanes ( airplane_id );

ALTER TABLE routes
    ADD CONSTRAINT routes_airports_fk FOREIGN KEY ( arrival_id )
        REFERENCES airports ( airport_id );

ALTER TABLE routes
    ADD CONSTRAINT routes_airports_fkv2 FOREIGN KEY ( departure_id )
        REFERENCES airports ( airport_id );

ALTER TABLE ticket_charge
    ADD CONSTRAINT ticket_charge_charges_fk FOREIGN KEY ( charge_id )
        REFERENCES charges ( charge_id );

ALTER TABLE ticket_charge
    ADD CONSTRAINT ticket_charge_tickets_fk FOREIGN KEY ( ticket_id )
        REFERENCES tickets ( ticket_id );

ALTER TABLE tickets
    ADD CONSTRAINT tickets_flights_fk FOREIGN KEY ( flight_id )
        REFERENCES flights ( flight_id );

ALTER TABLE tickets
    ADD CONSTRAINT tickets_passengers_fk FOREIGN KEY ( p_id )
        REFERENCES passengers ( p_id )
            ON DELETE CASCADE;

ALTER TABLE tickets
    ADD CONSTRAINT tickets_travel_classes_fk FOREIGN KEY ( tc_id )
        REFERENCES travel_classes ( tc_id );



