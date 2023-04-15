--- NOMBRES JOHN RENE ALVAREZ , Steve Jamesley Marcelin , luis jose
--- MATRICULA 2020-0088,20200575,20200573
--john24BD.mssql.somee.com
--Login name:	John0124_SQLLogin_1
--Login password:	p6sqhpebfq


use  john24BD

CREATE TABLE cliente (
id_cliente int identity primary key,
nombre nvarchar (16),
apellido nvarchar (25),
direccion nvarchar (60),
tel_celular nvarchar (15),
tel_casa nvarchar (15),
tel_oficina nvarchar (15),
provincia nvarchar(100),
limite_credito int)

insert into cliente values ('Sterling', 'Diaz', 'C/Mantesa A. #2','829-592-0579','809-537-3930','N/A','santiago',50000)
insert into cliente values ('javier', 'gomes', 'C/jose 3. #3','809-678-0979','849-507-7830','N/A','san-juan',40000)
insert into cliente values ('Steven', 'goku', 'C/Martin. #1','809-096-0979','809-475-8560','N/A','santo-domingo',60000)
insert into cliente values ('john', 'alvares', 'C/garcia d. #4','809-692-0979','829-456-7894','N/A','san-pedro',80000)
insert into cliente values ('pepe', 'lebu', 'C/Mirabel. #1','809-692-0459','829-678-0987','N/A','puerto-plata',90000)
insert into cliente values ('juan', 'pacheco', 'C/B. #1','849-602-1969','829-697-4530','N/A','punta-cana',50000)
insert into cliente values ('pedro', 'lorenzo', 'C/1. #1','809-932-2049','849-897-2417',' N/A ','santiago',50000)
insert into cliente values ('guillermo','basca', 'C/jardin. #1','849-992-1955','829-777-7564',' N/A ','san-pedro',50000)
insert into cliente values ('jose', 'checo','C/f. #6','809-882-9639','809-984-5335','809-667-2288','N/A','santo-domingo',50000)
insert into cliente values ('willy', 'quesada','C/florentino. #1','829-742-1233','809-112-5445','N/A','santo-domingo',70000)

CREATE PROCEDURE Procedimiento_cliente
@id_cliente int,
@nombre nvarchar (16),
@apellido nvarchar (25),
@direccion nvarchar (60),
@tel_celular nvarchar (15),
@tel_casa nvarchar (15),
@tel_oficina nvarchar (15),
@limite_credito int
AS
BEGIN TRANSACTION Reg_Cliente
BEGIN TRY
--Si el usuario existe, será actualizado
if exists (select id_cliente from CLIENTE where id_cliente = @id_cliente)
begin
print 'Este usario existe y será actualizado.'
update CLIENTE
set
/* id_cliente = @id_cliente, No se pone porque tiene un tipo de datos Identity*/
nombre = @nombre,
apellido = @apellido,
direccion = @direccion,
tel_celular = @tel_celular,
tel_casa = @tel_casa,
tel_oficina = @tel_oficina,
limite_credito = @limite_credito
where id_cliente = @id_cliente
print 'Usuario actualizado correctamente.'
end
--Si no existe, entonces se inserta por primera vez
else
begin
insert into cliente (Nombre,Apellido,Direccion,tel_celular,tel_casa,tel_oficina,
limite_credito)
values (@nombre,@apellido,@direccion,@tel_celular,@tel_casa,
@tel_oficina,@limite_credito)
print 'Usuario creado'
end
COMMIT TRAN Reg_Cliente
END TRY

BEGIN CATCH
print 'Ocurrió un error durante la transaccion: ' + ERROR_MESSAGE()
ROLLBACK TRAN Reg_Cliente
END CATCH

GO

--Tabla cuenta
 Create table cuenta(
 id_cliente int FOREIGN KEY REFERENCES cliente (id_cliente),
 id_cuenta int,tipo_cuenta nvarchar (10) check (tipo_cuenta in ('AHORRO','CORRIENTE','INVERSION')),
 balance_cuenta int, actividad char (8))

  ---registro cuenta
 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',1,4525,1800,'ACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',2,6325,5000,'NOACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',3,5236,1500,'NOACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',4,4529,5020,'ACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',5,4452,1200,'NOACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('AHORRO',6,4891,1800,'ACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('CORRIENTE',7,8991,15000,'ACTIVO');

 iNSERT cuenta(tipo_cuenta,id_cliente,id_cuenta,balance_cuenta,actividad)
 VALUES ('INVERSION',8,6985,5000,'NOACTIVO');

 ---proceso cuenta
 CREATE PROCEDURE Procedimiento_cuenta
 @id_cliente nvarchar (16),
 @id_cuenta int,
 @tipo_cuenta nvarchar (10),
 @balance_cuenta int,
 @actividad char (8)
 AS
BEGIN TRANSACTION Reg_Cuenta

BEGIN TRY
--Si la cuenta esta activa,se puede realizar el deposito
if exists (select @id_cuenta from cuenta where @id_cuenta = @id_cuenta)
begin
print 'si la cuenta esta activa se puede realizar el deposito.'
--Actualiza la cuenta
update cuenta
set
@id_cliente = @id_cliente,
@id_cuenta =  @id_cuenta ,
@tipo_cuenta = @tipo_cuenta,
@balance_cuenta = @balance_cuenta,
@actividad = @actividad 
where @id_cuenta = @id_cuenta
print 'Deposito efectuado correcta mente.'
end
--Si la cuenta no esta activa o no existe, entonces se  activara o se inserta por primera vez los datos
else
begin
SET IDENTITY_INSERT cuenta ON
insert into cuenta (id_cliente,id_cuenta,tipo_cuenta,balance_cuenta,actividad)
values (@id_cliente,@id_cuenta,@tipo_cuenta,@balance_cuenta,@actividad)
print 'Registrado correctamete'
print 'Registrando deposito'
end
COMMIT TRAN Reg_cuenta
END TRY

BEGIN CATCH
PRINT 'Ocurrió un error durante la transaccion: ' +ERROR_MESSAGE()
END CATCH

---Tabla entidad financiera
 CREATE TABLE Entidades_financiera (
 entidades_financiera nvarchar (25),
 id_cliente int FOREIGN KEY REFERENCES cliente (id_cliente),
 numero_entidadfianciera int)
 
 ---registros de la tabla financiera
 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('BANCO RESERVAS',1,4525);

 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('BANCO POPULAR',2,2565);

 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('BANCO ADEMI',3,5756);

 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('BANCO BHD',4,4842);

 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('ASOSICION POPULAR',5,2789);

 iNSERT Entidades_financiera (entidades_financiera,id_cliente,numero_entidadfianciera)
 VALUES ('COPERATIVA CENTRAL',6,5412);

 -- Tabla Tarjetas
 Create table Tarjetas(
 id_cliente int FOREIGN KEY REFERENCES cliente (id_cliente),
 id_Tarjetas int,tipo_Tarjetas nvarchar (100) check (tipo_Tarjetas in ('DEBITO','CREDITO','Pre-pagada')),
 balance_Tarjetas int, Actividad char (80),monto_Tarjetas decimal (10,3))

 ---registros Tajetas
 iNSERT Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (1,1234,'DEBITO',5000,'ACTIVO',10000);

 iNSERT  Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (2,456353,'CREDITO',6000,'ACTIVO',15000);

 iNSERT  Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (3,8523,'DEBITO',2000,'ACTIVO',50);

 iNSERT  Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (4,4128,'Pre-pagada',1500,'NOACTIVO',50);

 iNSERT  Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (5,7852,'DEBITO',8500,'ACTIVO',10);

 iNSERT  Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (6,8911,'Pre-pagada',9852,'ACTIVO',15);

 iNSERT Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (7,9145,'CREDITO',7200,'ACTIVO',10);

 iNSERT Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (8,6985,'Pre-pagada',4000,'NOACTIVO',50);

 iNSERT Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (9,7894,'CREDITO',111000,'ACTIVO',200);

 iNSERT Tarjetas(id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas)
 VALUES (10,8523,'CREDITO',9000,'ACTIVO',15);

--Creacion de Tabla Prestamos
 
CREATE TABLE PRESTAMOS (
id_cliente int FOREIGN KEY REFERENCES cliente (id_cliente),
num_prestamo int IDENTITY PRIMARY KEY,
fecha_solicitud nvarchar (15),
monto_solicitado int,
fecha_desembolso nvarchar (15),
monto_aprobado int, /* No se permiten subconsultas aqui */
balance int,
tipo_credito nvarchar (15) check (tipo_credito in ('CONSUMO','COMERCIAL','HIPOTECARIO')),
plazo nvarchar (15),
dia_pago nvarchar (15))

-- ************************************************** ***********
--Registros la tabla Prestamos

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (1,'01/01/2011',90000,'01/02/2011',90000,0,'CONSUMO','30','01/03/2011')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (2,'03/04/2017',900000,'03/04/2017',90000,0,'CONSUMO','40','01/06/2017')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (3,'11/05/2016',90000,'11/05/2016',70000,0,'CONSUMO','50','07/06/2016')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (4,'09/04/2019',78000,'09/04/2019',80000,0,'CONSUMO','60','05/06/2019')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (5,'06/04/2018',60000,'01/02/2011',62000,0,'CONSUMO','50','01/06/2018')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (6,'13/04/2019',90000,'13/04/2019',87000,0,'CONSUMO','40','11/03/2020')

insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (7,'1/03/2019',80000,'3/05/2019',70000,0,'COMERCIAL','50','1/03/2020')
-- ************************************************** ********
--Procedimiento Almacenado para registrar datos en la tabla PRESTAMOS

CREATE PROCEDURE Procedimiento_Prestamo
@id_cliente nvarchar (16),
@num_prestamo int,
@fecha_solicitud nvarchar (15),
@monto_solicitado int,
@fecha_desembolso nvarchar (15),
@monto_aprobado int,
@balance int,
@tipo_credito nvarchar (100),
@plazo nvarchar (15),
@dia_pago nvarchar (15)

AS
BEGIN TRANSACTION Reg_Prestamo

BEGIN TRY
--Si el prestamo existe, será actualizado
if exists (select @num_prestamo from PRESTAMOS where @num_prestamo = @num_prestamo)
begin
print 'Este prestamo ya existe y será actualizado.'
--Actualiza el prestamo
update prestamos
set
@id_cliente = @id_cliente,
/* num_prestamo = @num_prestamo, Al ser identity, no se puede actualizar */
@fecha_solicitud = @fecha_solicitud,
@monto_solicitado = @monto_solicitado,
@fecha_desembolso = @fecha_desembolso,
@monto_aprobado = (select limite_credito from cliente),
@balance = @balance,
@tipo_credito = @tipo_credito,
@plazo = @plazo,
@dia_pago = @dia_pago
where @num_prestamo = @num_prestamo
print 'Prestamo actualizado correctamente.'
end
--Si no existe, entonces se inserta por primera vez
else
begin
SET IDENTITY_INSERT PRESTAMOS ON
insert into prestamos (id_cliente,fecha_solicitud,monto_solicitado,fecha_desembolso,monto_aprobado,balance,tipo_credito,plazo,dia_pago)
values (@id_cliente,@fecha_solicitud,@monto_solicitado,@fecha_desembolso,@monto_aprobado,@balance,@tipo_credito,@plazo,@dia_pago)
print 'Prestamo Registrado'
end
COMMIT TRAN Reg_Prestamo
END TRY

BEGIN CATCH
PRINT 'Ocurrió un error durante la transaccion: ' +ERROR_MESSAGE()
END CATCH
--- funcion
CREATE FUNCTION BALANCE_MONTO(@balance_cuenta int) RETURNS INT
AS

BEGIN
DECLARE @BALANCE_FINAL INT 

SELECT @BALANCE_FINAL =(monto_aprobado + balance_cuenta )/2 FROM PRESTAMOS,CUENTA WHERE balance_cuenta = @balance_cuenta

RETURN @BALANCE_FINAL

END
 SELECT id_cuenta AS IDCUENTA,[dbo].[BALANCE_MONTO](1800) AS BALANCE FROM cuenta,PRESTAMOS WHERE balance_cuenta = 1800

--vistas tabla cliente
CREATE VIEW listado_cliente  
AS  
SELECT NOMBRE,apellido ,direccion,  tel_celular,tel_casa,id_cliente
FROM CLIENTE;

-- lista prestamos
CREATE VIEW listado_prestamos  
AS  
SELECT num_prestamo,fecha_solicitud,id_cliente
FROM PRESTAMOS;

CREATE VIEW listdo_financiera
As
SELECT entidades_financiera,numero_entidadfianciera,id_cliente
FROM Entidades_financiera;

CREATE VIEW listdo_Cuenta
As
SELECT tipo_cuenta,id_cliente,balance_cuenta,id_cuenta,actividad
FROM cuenta;

CREATE VIEW listado_Tarjeta 
AS  
SELECT id_cliente,id_Tarjetas,tipo_Tarjetas,balance_Tarjetas,Actividad,monto_Tarjetas
FROM Tarjetas;


