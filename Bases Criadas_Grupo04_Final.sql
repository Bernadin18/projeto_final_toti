

USE ProjetoFinal_Grupo04

GO 

-------Criação de Tabelas:
DROP TABLE IF EXISTS Physician;
CREATE TABLE Physician (
  EmployeeID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  SSN INTEGER NOT NULL,
  CONSTRAINT pk_physician PRIMARY KEY(EmployeeID)
); 

DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
  DepartmentID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Head INTEGER NOT NULL,
  CONSTRAINT pk_Department PRIMARY KEY(DepartmentID),
  CONSTRAINT fk_Department_Physician_EmployeeID FOREIGN KEY(Head) REFERENCES Physician(EmployeeID)
);


DROP TABLE IF EXISTS Affiliated_With;
CREATE TABLE Affiliated_With (
  Physician INTEGER NOT NULL,
  Department INTEGER NOT NULL,
  PrimaryAffiliation BIT NOT NULL,
  CONSTRAINT fk_Affiliated_With_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Affiliated_With_Department_DepartmentID FOREIGN KEY(Department) REFERENCES Department(DepartmentID),
  PRIMARY KEY(Physician, Department)
);

DROP TABLE IF EXISTS Procedures;
CREATE TABLE Procedures (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Cost REAL NOT NULL
);

DROP TABLE IF EXISTS Trained_In;
CREATE TABLE Trained_In (
  Physician INTEGER NOT NULL,
  Treatment INTEGER NOT NULL,
  CertificationDate DATETIME NOT NULL,
  CertificationExpires DATETIME NOT NULL,
  CONSTRAINT fk_Trained_In_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Trained_In_Procedures_Code FOREIGN KEY(Treatment) REFERENCES Procedures(Code),
  PRIMARY KEY(Physician, Treatment)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient (
  SSN INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Address VARCHAR(30) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  InsuranceID INTEGER NOT NULL,
  PCP INTEGER NOT NULL,
  CONSTRAINT fk_Patient_Physician_EmployeeID FOREIGN KEY(PCP) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Nurse;
CREATE TABLE Nurse (
  EmployeeID INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  Registered BIT NOT NULL,
  SSN INTEGER NOT NULL
);

DROP TABLE IF EXISTS Appointment;
CREATE TABLE Appointment (
  AppointmentID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,    
  PrepNurse INTEGER,
  Physician INTEGER NOT NULL,
  Starto DATETIME NOT NULL,
  Endo DATETIME NOT NULL,
  ExaminationRoom TEXT NOT NULL,
  CONSTRAINT fk_Appointment_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Appointment_Nurse_EmployeeID FOREIGN KEY(PrepNurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_Appointment_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Medication;
CREATE TABLE Medication (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Brand VARCHAR(30) NOT NULL,
  Description VARCHAR(30) NOT NULL
);


DROP TABLE IF EXISTS Prescribes;
CREATE TABLE Prescribes (
  Physician INTEGER NOT NULL,
  Patient INTEGER NOT NULL, 
  Medication INTEGER NOT NULL, 
  Date DATETIME NOT NULL,
  Appointment INTEGER,  
  Dose VARCHAR(30) NOT NULL,
  PRIMARY KEY(Physician, Patient, Medication, Date),
  CONSTRAINT fk_Prescribes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Prescribes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Prescribes_Medication_Code FOREIGN KEY(Medication) REFERENCES Medication(Code),
  CONSTRAINT fk_Prescribes_Appointment_AppointmentID FOREIGN KEY(Appointment) REFERENCES Appointment(AppointmentID)
);

DROP TABLE IF EXISTS Block;
CREATE TABLE Block (
  BlockFloor INTEGER NOT NULL,
  BlockCode INTEGER NOT NULL,
  PRIMARY KEY(BlockFloor, BlockCode)
); 

DROP TABLE IF EXISTS Room;
CREATE TABLE Room (
  RoomNumber INTEGER PRIMARY KEY NOT NULL,
  RoomType VARCHAR(30) NOT NULL,
  BlockFloor INTEGER NOT NULL,  
  BlockCode INTEGER NOT NULL,  
  Unavailable BIT NOT NULL,
  CONSTRAINT fk_Room_Block_PK FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode)
);

DROP TABLE IF EXISTS On_Call;
CREATE TABLE On_Call (
  Nurse INTEGER NOT NULL,
  BlockFloor INTEGER NOT NULL, 
  BlockCode INTEGER NOT NULL,
  OnCallStart DATETIME NOT NULL,
  OnCallEnd DATETIME NOT NULL,
  PRIMARY KEY(Nurse, BlockFloor, BlockCode, OnCallStart, OnCallEnd),
  CONSTRAINT fk_OnCall_Nurse_EmployeeID FOREIGN KEY(Nurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_OnCall_Block_Floor FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode) 
);

DROP TABLE IF EXISTS Stay;
CREATE TABLE Stay (
  StayID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,
  Room INTEGER NOT NULL,
  StayStart DATETIME NOT NULL,
  StayEnd DATETIME NOT NULL,
  CONSTRAINT fk_Stay_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Stay_Room_Number FOREIGN KEY(Room) REFERENCES Room(RoomNumber)
);

DROP TABLE IF EXISTS Undergoes;
CREATE TABLE Undergoes (
  Patient INTEGER NOT NULL,
  Procedures INTEGER NOT NULL,
  Stay INTEGER NOT NULL,
  DateUndergoes DATETIME NOT NULL,
  Physician INTEGER NOT NULL,
  AssistingNurse INTEGER,
  PRIMARY KEY(Patient, Procedures, Stay, DateUndergoes),
  CONSTRAINT fk_Undergoes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Undergoes_Procedures_Code FOREIGN KEY(Procedures) REFERENCES Procedures(Code),
  CONSTRAINT fk_Undergoes_Stay_StayID FOREIGN KEY(Stay) REFERENCES Stay(StayID),
  CONSTRAINT fk_Undergoes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Undergoes_Nurse_EmployeeID FOREIGN KEY(AssistingNurse) REFERENCES Nurse(EmployeeID)
);


--Inserção de Dados nas Tabelas:

INSERT INTO Physician VALUES(1,'John Dorian','Staff Internist',111111111);
INSERT INTO Physician VALUES(2,'Elliot Reid','Attending Physician',222222222);
INSERT INTO Physician VALUES(3,'Christopher Turk','Surgical Attending Physician',333333333);
INSERT INTO Physician VALUES(4,'Percival Cox','Senior Attending Physician',444444444);
INSERT INTO Physician VALUES(5,'Bob Kelso','Head Chief of Medicine',555555555);
INSERT INTO Physician VALUES(6,'Todd Quinlan','Surgical Attending Physician',666666666);
INSERT INTO Physician VALUES(7,'John Wen','Surgical Attending Physician',777777777);
INSERT INTO Physician VALUES(8,'Keith Dudemeister','MD Resident',888888888);
INSERT INTO Physician VALUES(9,'Molly Clock','Attending Psychiatrist',999999999);

INSERT INTO Department VALUES(1,'General Medicine',4);
INSERT INTO Department VALUES(2,'Surgery',7);
INSERT INTO Department VALUES(3,'Psychiatry',9);

INSERT INTO Affiliated_With VALUES(1,1,1);
INSERT INTO Affiliated_With VALUES(2,1,1);
INSERT INTO Affiliated_With VALUES(3,1,0);
INSERT INTO Affiliated_With VALUES(3,2,1);
INSERT INTO Affiliated_With VALUES(4,1,1);
INSERT INTO Affiliated_With VALUES(5,1,1);
INSERT INTO Affiliated_With VALUES(6,2,1);
INSERT INTO Affiliated_With VALUES(7,1,0);
INSERT INTO Affiliated_With VALUES(7,2,1);
INSERT INTO Affiliated_With VALUES(8,1,1);
INSERT INTO Affiliated_With VALUES(9,3,1);

INSERT INTO Procedures VALUES(1,'Reverse Rhinopodoplasty',1500.0);
INSERT INTO Procedures VALUES(2,'Obtuse Pyloric Recombobulation',3750.0);
INSERT INTO Procedures VALUES(3,'Folded Demiophtalmectomy',4500.0);
INSERT INTO Procedures VALUES(4,'Complete Walletectomy',10000.0);
INSERT INTO Procedures VALUES(5,'Obfuscated Dermogastrotomy',4899.0);
INSERT INTO Procedures VALUES(6,'Reversible Pancreomyoplasty',5600.0);
INSERT INTO Procedures VALUES(7,'Follicular Demiectomy',25.0);


INSERT INTO Patient VALUES(100000011,'John Smith','Vila Mariana','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000022,'Grace Ritchie','Tatuapé','555-0512',36546321,2);
INSERT INTO Patient VALUES(100000033,'Random J. Patient','Jardim Europa','555-1204',65465421,2);
INSERT INTO Patient VALUES(100000244,'Dennis Doe','Barra Funda','555-2048',68421879,3);
INSERT INTO Patient VALUES(100000055,'Marcos Simão','Ibirapuera','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000066,'Bernadin pinquiere','Tatuapé','555-0256',68476213,2);
INSERT INTO Patient VALUES(100000077,'Maoly Lara','Jardim Europa','555-0256',68476214,3);
INSERT INTO Patient VALUES(100000078,'Fatinha Mendoça','Vila Mariana','555-0256',68476215,1);
INSERT INTO Patient VALUES(100000099,'Antonio Simao','Vila Sonia','555-0256',68476216,3);
INSERT INTO Patient VALUES(1000000110,'Joao Alberto','Morumbi','555-0256',68476217,1);
INSERT INTO Patient VALUES(1000000211,'Ivana Garcia','Morumbi','555-0256',68476218,2);
INSERT INTO Patient VALUES(1000000312,'Gilberto Gil','Vila Sonia','555-0256',68476219,3);
INSERT INTO Patient VALUES(1000000413,'Lucia Regina','Tatuapé','555-0256',684762110,1);
INSERT INTO Patient VALUES(1000000514,'Fonseca Kauê','Vila Mariana','555-0256',684762111,2);
INSERT INTO Patient VALUES(1000000615,'Makuntima Mzabi','Capão Redondo','555-0256',684762112,1);
INSERT INTO Patient VALUES(1000000716,'Pedro Perez','Capão Redondo','555-0256',684762113,3);
INSERT INTO Patient VALUES(1000000817,'Abraham Wilson','Ibirapuera','555-0256',684762114,2);
INSERT INTO Patient VALUES(1000000918,'Sambontche Badjeta','Tatuapé','555-0256',684762115,1);
INSERT INTO Patient VALUES(1000000119,'Nedège Pinquière','Jardim Europa','555-0256',684762116,2);
INSERT INTO Patient VALUES(1000000220,'Ronaldo Nazario','Vila Mariana','555-0256',684762117,1);
INSERT INTO Patient VALUES(1000000321,'Cristiano Ronaldo','Vila Sonia','555-0256',684762118,2);
INSERT INTO Patient VALUES(1000000422,'Barack Obama','Morumbi','555-0256',684762119,1);
INSERT INTO Patient VALUES(1000000523,'Lula Alberto','Lapa','555-0256',684762120,3);
INSERT INTO Patient VALUES(1000000624,'Romario Farias','Vila Mariana','555-0256',684762121,2);
INSERT INTO Patient VALUES(1000000725,'Vanessa Naário','Lapa','555-0256',684762122,1);
INSERT INTO Patient VALUES(1000000826,'Jaqueline Cruz','Grajaú','555-0256',684762123,2);
INSERT INTO Patient VALUES(1000000927,'Pedro Santos','Grajaú','555-0256',684762124,3);
INSERT INTO Patient VALUES(1000000128,'Frederico Cassule','Grajaú','555-0256',684762125,1);
INSERT INTO Patient VALUES(1000000229,'Jay Jay','Capão Redondo','555-0256',684762126,2);
INSERT INTO Patient VALUES(1000000330,'Albert Branema','Capão Redondo','555-0256',684762127,3);
INSERT INTO Patient VALUES(1000000431,'Nzuci Beti','Cotia','555-0256',684762128,2);
INSERT INTO Patient VALUES(1000000532,'Vuila Antonio','Cotia','555-0256',684762129,1);
INSERT INTO Patient VALUES(1000000633,'Melqui Vuila','Vila Mariana','555-0256',684762130,2);
INSERT INTO Patient VALUES(1000000734,'Yandra Cipriano','Bela Vista','555-0256',684762131,1);
INSERT INTO Patient VALUES(1000000835,'Pamela Rangel','Bela Vista','555-0256',684762132,3);
INSERT INTO Patient VALUES(1000000936,'Rubens Sanches','Cotia','555-0256',684762133,1);
INSERT INTO Patient VALUES(1000000137,'Sandra Souza','Cotia','555-0256',684762134,1);
INSERT INTO Patient VALUES(1000000238,'Leonardo Garcia','Vila Mariana','555-0256',684762135,2);
INSERT INTO Patient VALUES(1000000239,'Fernando Simão','República','555-0256',684762136,2);
INSERT INTO Patient VALUES(1000000340,'Alberto Viana','República','555-0256',684762137,3);
INSERT INTO Patient VALUES(1000000441,'Alexandre Castro','Vila Mariana','555-0256',68476238,2);
INSERT INTO Patient VALUES(1000000542,'Fragoso Veloz','República','555-0256',68476239,3);
INSERT INTO Patient VALUES(1000000643,'Maria Hilda','Ibirapuera','555-0256',68476240,1);
INSERT INTO Patient VALUES(1000000744,'Marcia Sampaio','Morumbi','555-0256',6847621341,1);
INSERT INTO Patient VALUES(1000000845,'Reginaldo Manoel','Lapa','555-0256',684762142,3);
INSERT INTO Patient VALUES(1000000946,'Francisco Félix','Lapa','555-0256',684762143,2);
INSERT INTO Patient VALUES(1000000147,'Rubens Sanches','Vila Sonia','555-0256',684762144,1);
INSERT INTO Patient VALUES(1000000248,'Ndobe Cassule','Tatuapé','555-0256',68476215,3);
INSERT INTO Patient VALUES(1000000249,'Paulo Tomas','Vila Mariana','555-0256',684762146,1);
INSERT INTO Patient VALUES(1000000350,'Mike Souza','Grajaú','555-0256',684762147,2);


INSERT INTO Nurse VALUES(101,'Carla Espinosa','Head Nurse',1,111111110);
INSERT INTO Nurse VALUES(102,'Laverne Roberts','Nurse',1,222222220);
INSERT INTO Nurse VALUES(103,'Paul Flowers','Nurse',0,333333330);


SET DATEFORMAT ymd;
INSERT INTO Appointment VALUES(13216558,100000001,101,1,'2008-04-24 10:00','2008-04-24 11:00','A');
INSERT INTO Appointment VALUES(26548959,100000002,101,2,'2008-04-24 10:00','2008-04-24 11:00','B');
INSERT INTO Appointment VALUES(36549861,100000001,102,1,'2008-04-25 10:00','2008-04-25 11:00','A');
INSERT INTO Appointment VALUES(46846560,100000004,103,4,'2008-04-25 10:00','2008-04-25 11:00','B');
INSERT INTO Appointment VALUES(59871371,100000004,NULL,4,'2008-04-26 10:00','2008-04-26 11:00','C');
INSERT INTO Appointment VALUES(69879272,100000003,103,2,'2008-04-26 11:00','2008-04-26 12:00','C');
INSERT INTO Appointment VALUES(76983273,100000001,NULL,3,'2008-04-26 12:00','2008-04-26 13:00','C');
INSERT INTO Appointment VALUES(69879274,100000004,102,9,'2008-04-27 10:00','2008-04-21 11:00','A');
INSERT INTO Appointment VALUES(36539875,100000002,101,2,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(46846476,100000005,102,4,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(91216577,100000003,101,4,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(16549878,100000004,102,4,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(51216579,100000005,101,4,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(06549880,100000002,103,5,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210581,100000003,101,9,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93316582,100000003,102,1,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(63206583,100000001,101,9,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93212584,100000002,102,1,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(83226385,100000003,101,9,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93216586,100000005,103,2,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(23216387,100000004,101,2,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(92216588,100000003,102,2,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93216589,100000004,101,4,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93016590,100000006,103,1,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(83216091,100000002,102,4,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210592,100000001,102,9,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210599,100000066,102,9,'2008-04-27 10:00','2008-04-27 11:00','C');

INSERT INTO Appointment VALUES(93210520,100000066,102,1,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210521,100000077,102,4,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210522,100000078,102,2,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210523,100000055,102,3,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210524,1000000110,102,1,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210525,1000000211,102,9,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210526,1000000413,102,4,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210527,1000000514,102,5,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210528,1000000716,102,5,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210529,1000000624,102,1,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210530,1000000826,102,2,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210531,1000000128,102,1,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210532,1000000936,102,9,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210533,1000000239,102,3,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210534,1000000340,102,3,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210535,1000000441,102,1,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210536,1000000542,102,2,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210537,1000000744,102,3,'2008-04-27 10:00','2008-04-27 11:00','A');
INSERT INTO Appointment VALUES(93210538,1000000946,102,5,'2008-04-27 10:00','2008-04-27 11:00','B');
INSERT INTO Appointment VALUES(93210539,1000000248,102,5,'2008-04-27 10:00','2008-04-27 11:00','C');
INSERT INTO Appointment VALUES(93210540,1000000350,102,9,'2008-04-27 10:00','2008-04-27 11:00','A');


INSERT INTO Medication VALUES(1,'Procrastin-X','X','N/A');
INSERT INTO Medication VALUES(2,'Thesisin','Foo Labs','N/A');
INSERT INTO Medication VALUES(3,'Awakin','Bar Laboratories','N/A');
INSERT INTO Medication VALUES(4,'Crescavitin','Baz Industries','N/A');
INSERT INTO Medication VALUES(5,'Melioraurin','Snafu Pharmaceuticals','N/A');


INSERT INTO Prescribes VALUES(1,100000001,1,'2008-04-24 10:47',13216584,'5');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-27 10:53',86213939,'10');
INSERT INTO Prescribes VALUES(3,100000003,2,'2008-04-30 16:53',NULL,'5');
INSERT INTO Prescribes VALUES(4,100000005,5,'2008-04-27 10:53',93216586,'5');
INSERT INTO Prescribes VALUES(2,100000001,1,'2008-04-27 10:53',93210592,'5');
INSERT INTO Prescribes VALUES(2,100000066,1,'2008-04-27 10:53',93210599,'5');
INSERT INTO Prescribes VALUES(9,100000077,5,'2008-04-27 10:53',93210521,'10');
INSERT INTO Prescribes VALUES(2,100000078,1,'2008-04-27 10:53',93210522,'5');
INSERT INTO Prescribes VALUES(9,100000055,2,'2008-04-27 10:53',93210523,'10');
INSERT INTO Prescribes VALUES(1,1000000110,3,'2008-04-27 10:53',93210524,'5');
INSERT INTO Prescribes VALUES(3,1000000211,4,'2008-04-27 10:53',93210525,'10');
INSERT INTO Prescribes VALUES(1,1000000413,5,'2008-04-27 10:53',93210526,'5');
INSERT INTO Prescribes VALUES(4,1000000514,2,'2008-04-27 10:53',93210527,'10');
INSERT INTO Prescribes VALUES(5,1000000716,3,'2008-04-27 10:53',93210528,'5');
INSERT INTO Prescribes VALUES(6,1000000716,4,'2008-04-27 10:53',93210528,'10');
INSERT INTO Prescribes VALUES(8,1000000624,5,'2008-04-27 10:53',93210529,'5');
INSERT INTO Prescribes VALUES(9,1000000826,2,'2008-04-27 10:53',93210530,'10');
INSERT INTO Prescribes VALUES(2,1000000128,3,'2008-04-27 10:53',93210531,'5');
INSERT INTO Prescribes VALUES(1,1000000936,4,'2008-04-27 10:53',93210532,'10');
INSERT INTO Prescribes VALUES(7,1000000238,5,'2008-04-27 10:53',93210533,'5');
INSERT INTO Prescribes VALUES(5,1000000239,2,'2008-04-27 10:53',93210534,'10');
INSERT INTO Prescribes VALUES(1,1000000340,3,'2008-04-27 10:53',93210535,'5');
INSERT INTO Prescribes VALUES(4,1000000441,1,'2008-04-27 10:53',93210535,'10');
INSERT INTO Prescribes VALUES(6,1000000542,2,'2008-04-27 10:53',93210536,'5');
INSERT INTO Prescribes VALUES(1,1000000744,5,'2008-04-27 10:53',93210537,'10');
INSERT INTO Prescribes VALUES(3,1000000744,4,'2008-04-27 10:53',93210537,'5');
INSERT INTO Prescribes VALUES(3,1000000946,3,'2008-04-27 10:53',93210538,'10');


INSERT INTO Block VALUES(1,1);
INSERT INTO Block VALUES(1,2);
INSERT INTO Block VALUES(1,3);
INSERT INTO Block VALUES(2,1);
INSERT INTO Block VALUES(2,2);
INSERT INTO Block VALUES(2,3);
INSERT INTO Block VALUES(3,1);
INSERT INTO Block VALUES(3,2);
INSERT INTO Block VALUES(3,3);
INSERT INTO Block VALUES(4,1);
INSERT INTO Block VALUES(4,2);
INSERT INTO Block VALUES(4,3);

INSERT INTO Room VALUES(101,'Single',1,1,0);
INSERT INTO Room VALUES(102,'Single',1,1,0);
INSERT INTO Room VALUES(103,'Single',1,1,0);
INSERT INTO Room VALUES(111,'Single',1,2,0);
INSERT INTO Room VALUES(112,'Single',1,2,1);
INSERT INTO Room VALUES(113,'Single',1,2,0);
INSERT INTO Room VALUES(121,'Single',1,3,0);
INSERT INTO Room VALUES(122,'Single',1,3,0);
INSERT INTO Room VALUES(123,'Single',1,3,0);
INSERT INTO Room VALUES(201,'Single',2,1,1);
INSERT INTO Room VALUES(202,'Single',2,1,0);
INSERT INTO Room VALUES(203,'Single',2,1,0);
INSERT INTO Room VALUES(211,'Single',2,2,0);
INSERT INTO Room VALUES(212,'Single',2,2,0);
INSERT INTO Room VALUES(213,'Single',2,2,1);
INSERT INTO Room VALUES(221,'Single',2,3,0);
INSERT INTO Room VALUES(222,'Single',2,3,0);
INSERT INTO Room VALUES(223,'Single',2,3,0);
INSERT INTO Room VALUES(301,'Single',3,1,0);
INSERT INTO Room VALUES(302,'Single',3,1,1);
INSERT INTO Room VALUES(303,'Single',3,1,0);
INSERT INTO Room VALUES(311,'Single',3,2,0);
INSERT INTO Room VALUES(312,'Single',3,2,0);
INSERT INTO Room VALUES(313,'Single',3,2,0);
INSERT INTO Room VALUES(321,'Single',3,3,1);
INSERT INTO Room VALUES(322,'Single',3,3,0);
INSERT INTO Room VALUES(323,'Single',3,3,0);
INSERT INTO Room VALUES(401,'Single',4,1,0);
INSERT INTO Room VALUES(402,'Single',4,1,1);
INSERT INTO Room VALUES(403,'Single',4,1,0);
INSERT INTO Room VALUES(411,'Single',4,2,0);
INSERT INTO Room VALUES(412,'Single',4,2,0);
INSERT INTO Room VALUES(413,'Single',4,2,0);
INSERT INTO Room VALUES(421,'Single',4,3,1);
INSERT INTO Room VALUES(422,'Single',4,3,0);
INSERT INTO Room VALUES(423,'Single',4,3,0);


INSERT INTO On_Call VALUES(101,1,1,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(101,1,2,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(102,1,3,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(103,1,1,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,2,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,3,'2008-11-04 19:00','2008-11-05 03:00');


INSERT INTO Stay VALUES(3250,100000003,101,'2008-05-03','2008-05-14');
INSERT INTO Stay VALUES(3251,100000066,121,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3252,100000077,411,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3253,100000078,413,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3254,100000055,421,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3255,1000000110,202,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3256,1000000211,111,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3257,1000000413,202,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3258,1000000514,101,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3259,1000000615,121,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3260,1000000716,411,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3261,1000000624,111,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3262,1000000826,421,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3263,1000000128,101,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3264,1000000936,121,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3269,1000000238,413,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3265,1000000239,413,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3266,1000000340,413,'2008-05-02','2008-05-03');
INSERT INTO Stay VALUES(3267,1000000441,413,'2008-05-02','2008-05-03');


INSERT INTO Undergoes VALUES(1000000248,6,3215,'2008-05-02',3,101);
INSERT INTO Undergoes VALUES(100000001,2,3215,'2008-05-03',7,101);
INSERT INTO Undergoes VALUES(1000000350,1,3217,'2008-05-07',3,102);
INSERT INTO Undergoes VALUES(1000000643,5,3217,'2008-05-09',6,NULL);
INSERT INTO Undergoes VALUES(1000000946,7,3217,'2008-05-10',7,101);
INSERT INTO Undergoes VALUES(100000004,2,3217,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(100000077,3,3252,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(100000078,5,3253,'2008-05-13',3,102);
INSERT INTO Undergoes VALUES(100000055,6,3254,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(1000000110,7,3255,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(1000000211,1,3257,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(1000000413,1,3258,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(1000000615,9,3259,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(1000000716,8,3260,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(1000000624,2,3261,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(1000000826,3,3262,'2008-05-13',3,103);
INSERT INTO Undergoes VALUES(1000000936,1,3264,'2008-05-13',3,102);
INSERT INTO Undergoes VALUES(1000000238,2,3233,'2008-05-13',3,102);
INSERT INTO Undergoes VALUES(1000000239,9,3234,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(1000000340,9,3235,'2008-05-13',3,101);
INSERT INTO Undergoes VALUES(1000000441,9,3236,'2008-05-13',3,101);


SET DATEFORMAT ymd;
INSERT INTO Trained_In VALUES(3,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,7,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,5,'2007-01-01','2007-12-31');
INSERT INTO Trained_In VALUES(6,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,3,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,4,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,7,'2008-01-01','2008-12-31');

--(1)Consulta para conferência de dados:

SELECT * FROM Physician; 
SELECT * FROM Department;
SELECT * FROM Affiliated_With;
SELECT * FROM Procedures;
SELECT * FROM Trained_In;
SELECT * FROM Patient;
SELECT * FROM Nurse;
SELECT * FROM Appointment;
SELECT * FROM Medication;
SELECT * FROM Prescribes;
SELECT * FROM Block;
SELECT * FROM Room;
SELECT * FROM On_Call;
SELECT * FROM Stay;
SELECT * FROM Undergoes;

--(2)Encontrando os médicos que dirigem um departamento e retorna o departamento respectivo.

SELECT d.name AS "Department",
       p.name AS "Physician"
FROM department d,
     physician p
WHERE d.head=p.employeeid;

--(3)Encontra a quantidade de patiente que macaram um horario com o ultimo medico.

SELECT count(DISTINCT patient) AS "Não tem patientes marcado no ultimo horário"
FROM appointment;

--(4)Encontre os medicos e os departamntos onde eles estão afilhados.

SELECT p.name AS "Physician",
       d.name AS "Department"
FROM physician p,
     department d,
     affiliated_with a
WHERE p.employeeid=a.physician
  AND a.department=d.departmentid;

--(5)Encontre os medicos com que tiveram uma formaçâo especialisada e a especializão

  select ph.name as physician, pr.name as Treatmant from physician ph 
  join procedures pr on ph.employeeid=pr.code

---(6)Encontre os médicos que já são afilhados a um departamento.

  SELECT p.name AS "Physician",
       p.position,
       d.name AS "Department"
FROM physician p
JOIN affiliated_with a ON a.physician=p.employeeid
JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='false';

---(7)Encontre os médicos qua não são especializados.

SELECT p.name AS "Physician",
       p.position "Designation"
FROM physician p
LEFT JOIN trained_in t ON p.employeeid=t.physician
WHERE t.treatment IS NULL
ORDER BY employeeid;

---(8)encontre os patientes e os medicos pelos quais eles receberam os primeiro tratamento.

SELECT t.name AS "Patient",
       t.address AS "Address",
       p.name AS "Physician"
FROM patient t
JOIN physician p ON t.pcp=p.employeeid;

---(9)Na tabela a seguir, escreva uma consulta SQL para contar o número de pacientes únicos que marcaram 
---uma consulta para a sala de exame 'C'(Codigo rever)

SELECT p.name "Patient",
       count(t.patient) "Appointment for No. of Physicians"
FROM Appointment t
JOIN patient p ON t.patient=p.ssn
GROUP BY p.name
HAVING count(t.patient)>0;

---(10)Nas tabelas a seguir, escreva uma consulta SQL para encontrar os pacientes e seus médicos que não 
---precisam de assistência de uma enfermeira.
SELECT t.name AS "Name of the patient",
       p.name AS "Name of the physician",
       a.examinationroom AS "Room No."
FROM patient t
JOIN appointment a ON a.patient=t.ssn
JOIN physician p ON a.physician=p.employeeid
WHERE a.prepnurse IS NULL;

---(11)Nas tabelas a seguir, escreva uma consulta SQL para localizar os pacientes e seus médicos e medicamentos.
SELECT t.name AS "Patient",
       p.name AS "Physician",
       m.name AS "Medication"
FROM patient t
JOIN prescribes s ON s.patient=t.ssn
JOIN physician p ON s.physician=p.employeeid
JOIN medication m ON s.medication=m.code;

---(12)Nas tabelas a seguir, escreva uma consulta SQL para localizar os pacientes que não marcaram nenhuma consulta.

SELECT t.name AS "Patient",
       p.name AS "Physician",
       m.name AS "Medication"
FROM patient t
JOIN prescribes s ON s.patient=t.ssn
JOIN physician p ON s.physician=p.employeeid
JOIN medication m ON s.medication=m.code
WHERE s.appointment IS NULL;

---(13)Nas tabelas a seguir, escreva uma consulta SQL para encontrar o nome dos pacientes, 
---seu bloco, andar e número do quarto onde eles internaram.

SELECT p.name AS "Patient",
       s.room AS "Room",
       r.blockfloor AS "Floor",
       r.blockcode AS "Block"
FROM stay s
JOIN patient p ON s.patient=p.ssn
JOIN room r ON s.room=r.roomnumber;

--(14)Consulta SQL para obter:
--a) nome do paciente,
--b) nome do médico que o está tratando,
--d) qual tratamento está acontecendo com o paciente,
--e) a data de lançamento,
--f) em qual quarto o paciente está internado e em qual andar e bloco o quarto pertence, respectivamente.

SELECT p.name AS "Patient",
       y.name AS "Physician",
       s.StayEnd AS "Date of release",
       pr.name as "Treatement going on",
       r.roomnumber AS "Room",
       r.blockfloor AS "Floor",
       r.blockcode AS "Block"

FROM undergoes u
JOIN patient p ON u.patient=p.ssn
JOIN physician y ON u.physician=y.employeeid
JOIN stay s ON u.patient=s.patient
JOIN room r ON s.room=r.roomnumber
JOIN procedures pr on u.procedures=pr.code;

---(15)localizar os pacientes que foram submetidos a um procedimento que custa mais de US$ 5.000 e o 
---nome do médico que realizou atendimento primário.

SELECT pt.name AS " Patient ",
p.name AS "Primary Physician",
pd.cost AS " Procedure Cost"
FROM patient pt
JOIN undergoes u ON u.patient=pt.ssn
JOIN physician p ON pt.pcp=p.employeeid
JOIN Procedures pd ON u.Procedures=pd.code
WHERE pd.cost>5000;


