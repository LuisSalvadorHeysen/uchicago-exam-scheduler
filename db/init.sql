CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    title VARCHAR(100)
);

CREATE TABLE exams (
    id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    exam_year INT NOT NULL
) PARTITION BY RANGE (exam_year);

CREATE TABLE exams_2025 PARTITION OF exams FOR VALUES FROM (2025) TO (2026);
