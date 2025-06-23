USE task_1;

DROP TABLE IF EXISTS medicalRecord;
DROP TABLE IF EXISTS adoption;
DROP TABLE IF EXISTS adoptionrequest;
DROP TABLE IF EXISTS pet;
DROP TABLE IF EXISTS adopter;
DROP TABLE IF EXISTS shelter;

CREATE TABLE shelter (
  shelter_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  location VARCHAR(255),
  capacity INT
);

CREATE TABLE pet (
  pet_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  species VARCHAR(50),
  breed VARCHAR(50),
  age INT,
  health_status VARCHAR(50),
  shelter_id INT,
  FOREIGN KEY (shelter_id) REFERENCES shelter(shelter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE adopter (
  adopter_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  contact VARCHAR(100),
  address VARCHAR(255)
);

CREATE TABLE adoptionrequest (
  request_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  adopter_id INT,
  request_date DATE,
  status ENUM('Pending','Approved','Rejected'),
  remarks TEXT,
  FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE adoption (
  adoption_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  adopter_id INT,
  adoption_date DATE,
  documents TEXT,
  FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE medicalrecord (
  record_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  veterinarian VARCHAR(100),
  diagnosis TEXT,
  treatment_date DATE,
  FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO shelter (name, location, capacity) VALUES
  ('Happy Paws Shelter', 'City Center', 50),
  ('Furry Friends Haven', 'Suburbia', 30);

INSERT INTO pet (name, species, breed, age, health_status, shelter_id) VALUES
  ('Bingo', 'Dog', 'Beagle', 3, 'Vaccinated', 1),
  ('Whiskers', 'Cat', 'Siamese', 2, 'Healthy', 2);

INSERT INTO adopter (name, contact, address) VALUES
  ('John Doe', 'john@example.com', '101 Main St'),
  ('Jane Smith', 'jane@example.com', '202 Oak Rd');

INSERT INTO adoptionrequest (pet_id, adopter_id, request_date, status, remarks) VALUES
  (1, 2, '2025-06-20', 'Pending', 'Loves medium dogs'),
  (2, 1, '2025-06-21', 'Approved', 'Has cat experience');

INSERT INTO adoption (pet_id, adopter_id, adoption_date, documents) VALUES
  (2, 1, '2025-06-23', 'Contract A123');

INSERT INTO medicalrecord (pet_id, veterinarian, diagnosis, treatment_date) VALUES
  (1, 'Dr. Smith', 'Routine check-up', '2025-06-22');

SELECT p.name AS pet, p.species, s.name AS shelter
FROM pet p
JOIN shelter s ON p.shelter_id = s.shelter_id;

SELECT ar.request_id, a.name AS adopter, p.name AS pet, ar.status
FROM adoptionrequest ar
JOIN adopter a ON ar.adopter_id = a.adopter_id
JOIN pet p ON ar.pet_id = p.pet_id
WHERE ar.status = 'Pending';

SELECT ad.adoption_id, p.name AS pet, a.name AS adopter, ad.documents
FROM adoption ad
JOIN pet p ON ad.pet_id = p.pet_id
JOIN adopter a ON ad.adopter_id = a.adopter_id;

SELECT m.record_id, p.name AS pet, m.veterinarian, m.diagnosis, m.treatment_date
FROM medicalrecord m
JOIN pet p ON m.pet_id = p.pet_id;
