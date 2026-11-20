/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: ______________________________
   Date: ______________________________

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */

CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;


/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE:

/*The table doesnt follow First Normal Form (1NF).
pet1_name, pet2_name, and pet3_name are repeating.
Each pet should have its own row */

   Step 2  DESIGN:


--Table: owner
--PK: owner_id

--Table: pet
--PK: pet_id
--FK: owner_id references owner(owner_id)
*/

/* Step 3  CREATE */
--creating the owner table
CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    owner_name VARCHAR(50) NOT NULL,
    owner_city VARCHAR(50) NOT NULL
);

--creating the pet table
CREATE TABLE pet (
    pet_id INT PRIMARY KEY,
    owner_id INT NOT NULL,
    pet_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

/* Step 4  INSERT */

--inserting cvalues into owner table
INSERT INTO owner (owner_id, owner_name, owner_city) VALUES
(1, 'Maria Lopez', 'Turlock'),
(2, 'James Chen', 'Modesto'),
(3, 'Priya Singh', 'Ceres');

--inerting values into pet table
INSERT INTO pet (pet_id, owner_id, pet_name) VALUES
(1, 1, 'Bella'),
(2, 1, 'Max'),
(3, 2, 'Luna'),
(4, 3, 'Rocky'),
(5, 3, 'Daisy'),
(6, 3, 'Coco');

/* Step 5  JOIN */

--joining both pet and owner tables
SELECT
    owner.owner_id, owner.owner_name, owner.owner_city, pet.pet_name
FROM owner
JOIN pet
    ON owner.owner_id = pet.owner_id;


/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE:

/* The table violates Second Normal Form (2NF).
   The primary key is the composite key but
   building_name and building_address depend only on
   building_id instead of the entire composite key.
*/

   Step 2  DESIGN:

--Table: building
--PK: building_id

--Table: apartment_unit
--PK: (building_id, unit_number)
--FK: building_id references building(building_id)

*/

/* Step 3  CREATE */

-- Create the building table 
CREATE TABLE building (
    building_id VARCHAR(5) PRIMARY KEY,
    building_name VARCHAR(50) NOT NULL,
    building_address VARCHAR(100) NOT NULL
);

-- Create the apartment_unit table with a composite primary key.
CREATE TABLE apartment_unit (
    building_id VARCHAR(5),
    unit_number INT,
    bedrooms INT NOT NULL,
    monthly_rent DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (building_id, unit_number),
    FOREIGN KEY (building_id) REFERENCES building(building_id)
);

/* Step 4  INSERT */

-- Insert the sample buildings into the building table.
INSERT INTO building (building_id, building_name, building_address) VALUES
('B1', 'Oak Terrace', '100 Oak St'),
('B2', 'Canal Court', '45 Canal Dr');

-- Insert the sample apartment units.
INSERT INTO apartment_unit
(building_id, unit_number, bedrooms, monthly_rent) VALUES
('B1', 101, 1, 1250.00),
('B1', 102, 2, 1600.00),
('B2', 101, 2, 1550.00),
('B2', 201, 3, 1900.00);

/* Step 5  JOIN */

-- Join buildings and apartment units to display the original information.
SELECT
    building.building_id,
    apartment_unit.unit_number,
    building.building_name,
    building.building_address,
    apartment_unit.bedrooms,
    apartment_unit.monthly_rent
FROM building
JOIN apartment_unit
    ON building.building_id = apartment_unit.building_id;



/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE:
/*
   The table violates Third Normal Form (3NF).
   The columns dept_name and dept_phone depend on dept_id instead
   of the primary key emp_id.


*/

   Step 2  DESIGN:

--Table: department
--PK: dept_id

--Table: employee
--PK: emp_id
--FK: dept_id references department(dept_id)


*/

/* Step 3  CREATE */

--create the table department
CREATE TABLE department (
    dept_id VARCHAR(5) PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    dept_phone VARCHAR(20) NOT NULL
);

-- Create the table employee to store employee information.
CREATE TABLE employee (
    emp_id VARCHAR(5) PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    hire_year INT NOT NULL,
    dept_id VARCHAR(5) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

/* Step 4  INSERT */

-- Insert into the department table.
INSERT INTO department (dept_id, dept_name, dept_phone) VALUES
('D10', 'Accounting', '209.555.0300'),
('D20', 'Marketing', '209.555.0400');

-- Insert into the employee table.
INSERT INTO employee (emp_id, emp_name, hire_year, dept_id) VALUES
('E01', 'Linda Park', 2019, 'D10'),
('E02', 'Raj Mehta', 2021, 'D20'),
('E03', 'Carlos Vega', 2022, 'D10'),
('E04', 'Emma Wilson', 2024, 'D20');



/* Step 5  JOIN */

-- Join employees and departments
SELECT
    employee.emp_id,
    employee.emp_name,
    employee.hire_year,
    department.dept_id,
    department.dept_name,
    department.dept_phone
FROM employee
JOIN department
    ON employee.dept_id = department.dept_id;


/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE:

-- The table violates Second Normal Form (2NF).
-- The primary key is the composite key (student_id, course_id).

-- student_name and student_major depend on student_id.
-- course_name, course_description, and units depend  mon course_id.



-- The grade column depends on both student_id and course_id

   Step 2  DESIGN:

-- Table: student
-- PK: student_id

-- Table: course
-- PK: course_id

-- Table: enrollment
-- PK: (student_id, course_id)
-- FK: student_id references student(student_id)
-- FK: course_id references course(course_id)

*/

/* Step 3  CREATE */

-- Create the student table 
CREATE TABLE student (
    student_id VARCHAR(5) PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    student_major VARCHAR(50) NOT NULL
);

-- Create the course table 
CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    course_description VARCHAR(100) NOT NULL,
    units INT NOT NULL
);

-- Create the enrollment bridge table to connect students and courses.
CREATE TABLE enrollment (
    student_id VARCHAR(5),
    course_id VARCHAR(10),
    grade CHAR(2) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */

-- Insert students into the student table.
INSERT INTO student (student_id, student_name, student_major) VALUES
('S100', 'Ana Torres', 'CIS'),
('S200', 'Ben Shah', 'Business'),
('S300', 'Chloe Nguyen', 'CIS');

-- Insert courses into the course table.
INSERT INTO course
(course_id, course_name, course_description, units) VALUES
('CIS4720', 'Database Mgmt', 'Relational design and SQL', 3),
('CIS2000', 'Intro to Python', 'Programming fundamentals in Python', 3);

-- Insert student enrollments and their grades into the bridge table.
INSERT INTO enrollment (student_id, course_id, grade) VALUES
('S100', 'CIS4720', 'A'),
('S100', 'CIS2000', 'B'),
('S200', 'CIS4720', 'B'),
('S300', 'CIS2000', 'A');

/* Step 5  JOIN  (three tables: student, enrollment, course) */

-- Join all three tables 
SELECT
    student.student_id,
    student.student_name,
    student.student_major,
    course.course_id,
    course.course_name,
    course.course_description,
    course.units,
    enrollment.grade
FROM student
JOIN enrollment
    ON student.student_id = enrollment.student_id
JOIN course
    ON enrollment.course_id = course.course_id;