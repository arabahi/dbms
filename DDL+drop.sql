-- Drop tables if they exist
BEGIN
   FOR table_name IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || table_name.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

-- Creating Classroom table
CREATE TABLE classroom (
    building     VARCHAR2(15),
    room_number  VARCHAR2(7),
    capacity     NUMBER(4,0),
    PRIMARY KEY (building, room_number)
);

-- Creating Department table
CREATE TABLE department (
    dept_name    VARCHAR2(20), 
    building     VARCHAR2(15), 
    budget       NUMBER(12,2) CHECK (budget > 0),
    PRIMARY KEY (dept_name)
);

-- Creating Course table
CREATE TABLE course (
    course_id    VARCHAR2(8), 
    title        VARCHAR2(50), 
    dept_name    VARCHAR2(20),
    credits      NUMBER(2,0) CHECK (credits > 0),
    PRIMARY KEY (course_id),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- Creating Instructor table
CREATE TABLE instructor (
    ID           VARCHAR2(5), 
    name         VARCHAR2(20) NOT NULL, 
    dept_name    VARCHAR2(20), 
    salary       NUMBER(8,2) CHECK (salary > 29000),
    PRIMARY KEY (ID),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- Creating Section table
CREATE TABLE section (
    course_id    VARCHAR2(8), 
    sec_id       VARCHAR2(8),
    semester     VARCHAR2(6) CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')), 
    year         NUMBER(4,0) CHECK (year > 1701 AND year < 2100), 
    building     VARCHAR2(15),
    room_number  VARCHAR2(7),
    time_slot_id VARCHAR2(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON DELETE CASCADE,
    FOREIGN KEY (building, room_number) REFERENCES classroom (building, room_number)
        ON DELETE SET NULL
);

-- Creating Teaches table
CREATE TABLE teaches (
    ID           VARCHAR2(5), 
    course_id    VARCHAR2(8),
    sec_id       VARCHAR2(8), 
    semester     VARCHAR2(6),
    year         NUMBER(4,0),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE,
    FOREIGN KEY (ID) REFERENCES instructor (ID)
        ON DELETE CASCADE
);

-- Creating Student table
CREATE TABLE student (
    ID           VARCHAR2(5), 
    name         VARCHAR2(20) NOT NULL, 
    dept_name    VARCHAR2(20), 
    tot_cred     NUMBER(3,0) CHECK (tot_cred >= 0),
    PRIMARY KEY (ID),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- Creating Takes table
CREATE TABLE takes (
    ID           VARCHAR2(5), 
    course_id    VARCHAR2(8),
    sec_id       VARCHAR2(8), 
    semester     VARCHAR2(6),
    year         NUMBER(4,0),
    grade        VARCHAR2(2),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE,
    FOREIGN KEY (ID) REFERENCES student (ID)
        ON DELETE CASCADE
);

-- Creating Advisor table
CREATE TABLE advisor (
    s_ID         VARCHAR2(5),
    i_ID         VARCHAR2(5),
    PRIMARY KEY (s_ID),
    FOREIGN KEY (i_ID) REFERENCES instructor (ID)
        ON DELETE SET NULL,
    FOREIGN KEY (s_ID) REFERENCES student (ID)
        ON DELETE CASCADE
);

-- Creating Time Slot table
CREATE TABLE time_slot (
    time_slot_id VARCHAR2(4),
    day          VARCHAR2(1),
    start_hr     NUMBER(2) CHECK (start_hr >= 0 AND start_hr < 24),
    start_min    NUMBER(2) CHECK (start_min >= 0 AND start_min < 60),
    end_hr       NUMBER(2) CHECK (end_hr >= 0 AND end_hr < 24),
    end_min      NUMBER(2) CHECK (end_min >= 0 AND end_min < 60),
    PRIMARY KEY (time_slot_id, day, start_hr, start_min)
);

-- Creating Prereq table
CREATE TABLE prereq (
    course_id    VARCHAR2(8), 
    prereq_id    VARCHAR2(8),
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES course (course_id)
);
