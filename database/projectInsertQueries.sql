USE bloodbankvarshneyabindrap;

INSERT INTO administrator(user_name, user_password) VALUES ('admin1', 'root');
INSERT INTO administrator(user_name, user_password) VALUES ('admin2', 'pass');

INSERT INTO blood_group VALUES('A+', 'type A positive');
INSERT INTO blood_group VALUES('O+', 'type O positive');
INSERT INTO blood_group VALUES('B+', 'type B positive');
INSERT INTO blood_group VALUES('AB+', 'type AB positive');
INSERT INTO blood_group VALUES('A-', 'type A negative');
INSERT INTO blood_group VALUES('O-', 'type O negative');
INSERT INTO blood_group VALUES('B-', 'type B negative');
INSERT INTO blood_group VALUES('AB-', 'type AB negative');

INSERT INTO blood_group_receiver VALUES
('A+', 'A+'),
('A+', 'AB+'),
('O+', 'O+'),
('O+', 'A+'),
('O+', 'B+'),
('O+', 'AB+'),
('B+', 'B+'),
('B+', 'AB+'),
('AB+', 'AB+'),
('A-', 'A+'),
('A-', 'A-'),
('A-', 'AB+'),
('A-', 'AB-'),
('B-', 'B+'),
('B-', 'B-'),
('B-', 'AB+'),
('B-', 'AB-'),
('AB-', 'AB+'),
('AB-', 'AB-'),
('O-', 'A+'),
('O-', 'O+'),
('O-', 'B+'),
('O-', 'AB+'),
('O-', 'A-'),
('O-', 'B-'),
('O-', 'AB-'),
('O-', 'O-');

-- severity 10 means low risk, while 1 is high severity and needs blood from any of the inventories.
INSERT INTO admission VALUES
('General Checkup', 10),
('Anemia', 4),
('Anemia', 7),
('Surgery', 2),
('Accident', 1),
('Accident', 8),
('Bleeding disorders', 1);

INSERT INTO inventory(street, state, zip_code) VALUES
('1', 'test_inventory', 02115);
