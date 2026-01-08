-- 1. Normalization (DDL)
DROP TABLE IF EXISTS submission_locations;
DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS locations;

CREATE TABLE submissions (
    id INT PRIMARY KEY,
    submission_type VARCHAR(50),
    object_id INT
);

CREATE TABLE locations (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE submission_locations (
    submission_id INT,
    location_id INT,
    PRIMARY KEY (submission_id, location_id),
    CONSTRAINT fk_submission FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
);

-- Indexing
CREATE INDEX idx_submission_type ON submissions(submission_type);
CREATE INDEX idx_location_name ON locations(name);

-- 2. Seeding Dummy Data
INSERT INTO submissions VALUES (1, 'transaction', 1), (2, 'transaction', 2), (3, 'transaction', 3), (4, 'audit', 4), (5, 'transaction', 5);
INSERT INTO locations VALUES (15, 'Handil'), (25, 'Bintan'), (100, 'Jakarta'), (50, 'Makassar'), (70, 'Manado'), (30, 'Bandung');
INSERT INTO submission_locations VALUES (1, 15), (1, 25), (1, 100), (2, 50), (2, 70), (3, 15), (4, 25), (5, 25);

-- 3. Queries (Part A)
-- A.2.a: List locations (GROUP_CONCAT)
SELECT s.id, GROUP_CONCAT(l.name ORDER BY l.name SEPARATOR ', ') as locations
FROM submissions s
JOIN submission_locations sl ON s.id = sl.submission_id
JOIN locations l ON sl.location_id = l.id
GROUP BY s.id;

-- A.2.b: Filter by Location (CTE Required)
WITH BintanSubmissions AS (
    SELECT submission_id FROM submission_locations WHERE location_id = 25
)
SELECT s.* FROM submissions s
JOIN BintanSubmissions bs ON s.id = bs.submission_id;

-- 4. Anomalies (Part C)
-- C.1.a: More than 2 locations
SELECT submission_id FROM submission_locations GROUP BY submission_id HAVING COUNT(location_id) > 2;

-- C.1.b: Zero locations
SELECT s.id FROM submissions s LEFT JOIN submission_locations sl ON s.id = sl.submission_id WHERE sl.location_id IS NULL;