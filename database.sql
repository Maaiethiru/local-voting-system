-- ✅ RESET DATABASE
DROP DATABASE IF EXISTS voting_system;
CREATE DATABASE voting_system;
USE voting_system;

-- ✅ VOTERS TABLE
CREATE TABLE voters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(191) NOT NULL,
    email VARCHAR(191) UNIQUE NOT NULL,
    password VARCHAR(191) NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    has_voted BOOLEAN DEFAULT FALSE,
    CHECK (CHAR_LENGTH(password) >= 6)
);

INSERT INTO voters (name, email, password, verified, has_voted) VALUES 
('Vikram Kumar', 'vk7915@srmist.edu.in', 'varshat123', TRUE, FALSE),
('Meera Balan', 'mb6534@srmist.edu.in', 'maaie123', TRUE, FALSE),
('Sanjay Kumar', 'sk0800@srmist.edu.in', 'sanjay123', TRUE, FALSE);

-- ✅ ADMINS TABLE
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(191) UNIQUE NOT NULL,
    password VARCHAR(191) NOT NULL
);

INSERT INTO admins (username, password) VALUES 
('election_head@srmist.edu.in', 'admin123');

-- ✅ ELECTIONS TABLE
CREATE TABLE elections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(191) NOT NULL,
    description TEXT,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    CHECK (start_date < end_date)
);

INSERT INTO elections (title, description, start_date, end_date)
VALUES ('School Council Election 2025', 'Electing council members for the school year', '2025-05-01 08:00:00', '2025-05-10 18:00:00');

-- ✅ CANDIDATES TABLE
CREATE TABLE candidates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(191) NOT NULL,
    party VARCHAR(191) NOT NULL,
    position VARCHAR(191) NOT NULL,
    election_id INT NOT NULL,
    votes INT DEFAULT 0,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE,
    UNIQUE(name)
);

INSERT INTO candidates (name, party, position, election_id) VALUES
('Sivamani', 'Party A', 'President', 1),
('Lakshya', 'Party B', 'President', 1),
('Aasvidha', 'Party C', 'President', 1),
('Rohan Mehta', 'Party A', 'Vice President', 1),
('Sneha Iyer', 'Party B', 'Vice President', 1),
('Rahul Verma', 'Party C', 'Vice President', 1),
('Meera S', 'Party A', 'Treasurer', 1),
('Vikram S', 'Party B', 'Treasurer', 1),
('Tanvi Rao', 'Party C', 'Treasurer', 1),
('Aryan R', 'Party A', 'Secretary', 1),
('Diya K', 'Party B', 'Secretary', 1),
('Kunal D', 'Party C', 'Secretary', 1);

-- ✅ VOTES TABLE
CREATE TABLE votes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    voter_id INT,
    candidate_id INT,
    election_id INT,
    vote_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (voter_id) REFERENCES voters(id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
);

-- ✅ LOGS TABLE
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action VARCHAR(255) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE CASCADE
);

-- ✅ VIEWS
CREATE VIEW pending_voters AS
SELECT id, name, email FROM voters WHERE has_voted = FALSE;

CREATE VIEW vote_summary AS
SELECT c.name AS candidate_name, c.party, c.position, e.title AS election_title, COUNT(v.id) AS total_votes
FROM candidates c
LEFT JOIN votes v ON c.id = v.candidate_id
JOIN elections e ON c.election_id = e.id
GROUP BY c.id;

-- ✅ TRIGGER: auto update has_voted
DELIMITER //
CREATE TRIGGER after_vote_insert
AFTER INSERT ON votes
FOR EACH ROW
BEGIN
    UPDATE voters SET has_voted = TRUE WHERE id = NEW.voter_id;
END;//
DELIMITER ;

-- ✅ CURSOR: count_votes()
DELIMITER //
CREATE PROCEDURE count_votes()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cname VARCHAR(191);
    DECLARE total INT;
    DECLARE cur CURSOR FOR
        SELECT c.name, COUNT(v.id)
        FROM candidates c
        LEFT JOIN votes v ON c.id = v.candidate_id
        GROUP BY c.id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cname, total;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Candidate: ', cname, ' | Votes: ', total) AS result;
    END LOOP;
    CLOSE cur;
END;//
DELIMITER ;

-- ✅ SUBQUERY: voters who voted for top candidate
SELECT name FROM voters
WHERE id IN (
    SELECT voter_id FROM votes
    WHERE candidate_id = (
        SELECT id FROM candidates
        ORDER BY votes DESC
        LIMIT 1
    )
);

CREATE TABLE voter_ranking_details (
    voter_id INT,
    candidate_id INT,
    election_id INT,
    rank INT,
    PRIMARY KEY (voter_id, candidate_id, election_id),
    FOREIGN KEY (voter_id) REFERENCES voters(id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    FOREIGN KEY (election_id) REFERENCES elections(id)
);
