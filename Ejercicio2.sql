CREATE TABLE Alumnos (
    DNI CHAR(9) PRIMARY KEY NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Telefono VARCHAR(15),
    Flag_Trabaja BOOLEAN NOT NULL
);

INSERT INTO Alumnos (DNI, Nombre, Apellido, Fecha_Nacimiento, Telefono, Flag_Trabaja) 
VALUES 
('12345678A', 'Juan', 'Pérez', '1990-05-15', '600123456', TRUE),
('87654321B', 'María', 'González', '1985-03-10', '600987654', FALSE),
('12349876C', 'Pedro', 'Martínez', '1992-07-25', '600654321', TRUE),
('98761234D', 'Ana', 'López', '1991-08-20', '600321654', FALSE),
('23456789E', 'Lucía', 'Rodríguez', '1993-09-15', '600789123', TRUE);

CREATE TABLE Bootcamps (
    ID_bootcamp SERIAL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Fec_Creacion DATE NOT NULL
);

INSERT INTO Bootcamps (Nombre, Fec_Creacion) 
VALUES 
('Data Science Bootcamp', '2022-01-10'),
('Full Stack Web Bootcamp', '2021-09-05'),
('Machine Learning Bootcamp', '2022-05-20'),
('Cybersecurity Bootcamp', '2021-11-25'),
('UX/UI Bootcamp', '2022-03-15');

CREATE TABLE Profesores (
    ID_profesor SERIAL PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Telefono VARCHAR(15)
);


INSERT INTO Profesores (Nombre, Apellido, Fecha_Nacimiento, Telefono) 
VALUES 
('Laura', 'García', '1980-02-15', '600234567'),
('Carlos', 'Fernández', '1975-12-30', '600765432'),
('Elena', 'Sánchez', '1982-04-25', '600876543'),
('José', 'Ruiz', '1978-08-14', '600345678'),
('Marta', 'Hernández', '1990-06-19', '600456789');


CREATE TABLE Contenidos (
    ID_contenido SERIAL PRIMARY KEY,
    Titulo VARCHAR(100) NOT NULL,
    URL VARCHAR(255) NOT NULL
);


INSERT INTO Contenidos (Titulo, URL) 
VALUES 
('Introducción a Python', 'https://example.com/python-intro'),
('Bases de Datos SQL', 'https://example.com/sql-basics'),
('Machine Learning con Python', 'https://example.com/ml-python'),
('Seguridad en Redes', 'https://example.com/network-security'),
('Diseño de Interfaces UX/UI', 'https://example.com/ux-ui-design');


CREATE TABLE Modulos (
    ID_modulo INT PRIMARY KEY,
    ID_profesor INT NOT NULL,
    FOREIGN KEY (ID_profesor) REFERENCES Profesores(ID_profesor)
);

INSERT INTO Modulos (ID_modulo, ID_profesor) 
VALUES 
(1, 1),  -- Introducción a Python por Laura García
(2, 2),  -- Bases de Datos SQL por Carlos Fernández
(3, 3),  -- Machine Learning por Elena Sánchez
(4, 4),  -- Seguridad en Redes por José Ruiz
(5, 5);  -- Diseño de Interfaces por Marta Hernández


CREATE TABLE Matricula (
    num_matricula SERIAL PRIMARY KEY,
    DNI CHAR(9) NOT NULL,
    ID_bootcamp INT NOT NULL,
    Flag_Pago BOOLEAN NOT NULL,
    FOREIGN KEY (DNI) REFERENCES Alumnos(DNI),
    FOREIGN KEY (ID_bootcamp) REFERENCES Bootcamps(ID_bootcamp)
);

INSERT INTO Matricula (DNI, ID_bootcamp, Flag_Pago) 
VALUES 
('12345678A', 1, TRUE),
('87654321B', 2, TRUE),
('12349876C', 3, FALSE),
('98761234D', 4, TRUE),
('23456789E', 5, TRUE);


CREATE TABLE rel_Boot_Modul (
    ID_rel_boot_modul SERIAL PRIMARY KEY,
    ID_bootcamp INT NOT NULL,
    ID_modulo INT NOT NULL,
    FOREIGN KEY (ID_bootcamp) REFERENCES Bootcamps(ID_bootcamp) ON DELETE CASCADE,
    FOREIGN KEY (ID_modulo) REFERENCES Modulos(ID_modulo) ON DELETE CASCADE
);

INSERT INTO rel_Boot_Modul (ID_bootcamp, ID_modulo)
VALUES 
(1, 1),  -- El bootcamp "Data Science" tiene el módulo "Introducción a Python"
(2, 2),  -- El bootcamp "Full Stack Web" tiene el módulo "Bases de Datos SQL"
(3, 3),  -- El bootcamp "Machine Learning" tiene el módulo "Machine Learning con Python"
(4, 4),  -- El bootcamp "Cybersecurity" tiene el módulo "Seguridad en Redes"
(5, 5);  -- El bootcamp "UX/UI" tiene el módulo "Diseño de Interfaces"

CREATE TABLE rel_Modul_Cont (
    ID_rel_modul_cont SERIAL PRIMARY KEY,
    ID_modulo INT NOT NULL,
    ID_contenido INT NOT NULL,
    FOREIGN KEY (ID_modulo) REFERENCES Modulos(ID_modulo) ON DELETE CASCADE,
    FOREIGN KEY (ID_contenido) REFERENCES Contenidos(ID_contenido) ON DELETE CASCADE
);

INSERT INTO rel_Modul_Cont (ID_modulo, ID_contenido)
VALUES 
(1, 1),  -- El módulo "Introducción a Python" tiene el contenido "Introducción a Python"
(2, 2),  -- El módulo "Bases de Datos SQL" tiene el contenido "Bases de Datos SQL"
(3, 3),  -- El módulo "Machine Learning con Python" tiene el contenido "Machine Learning con Python"
(4, 4),  -- El módulo "Seguridad en Redes" tiene el contenido "Seguridad en Redes"
(5, 5);  -- El módulo "Diseño de Interfaces" tiene el contenido "Diseño de Interfaces"
