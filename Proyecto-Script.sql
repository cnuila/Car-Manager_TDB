-------------------------------------------------- Creacion de Tablas ----------------------------------------------------------

CREATE TABLE Compañia(
    idCompañia VARCHAR(10) NOT NULL,
    nombreCompañia VARCHAR(30) NOT NULL,
    PRIMARY KEY(idCompañia),
    UNIQUE(nombreCompañia)
);

CREATE TABLE Concesionario (
    rtnCon VARCHAR(10) NOT NULL,
    nombreConcesionario VARCHAR(15) NOT NULL,
    pais VARCHAR(25) NOT NULL,
    PRIMARY KEY(rtnCon)
);

CREATE TABLE PlantaFabricacion (
    idPlanta VARCHAR(10) NOT NULL,
    idCompañia VARCHAR(10) NOT NULL,
    nombrePlanta VARCHAR(15) NOT NULL,
    tipoPlanta VARCHAR(14) NOT NULL,
    PRIMARY KEY(idPlanta),
    UNIQUE(nombrePlanta),
    CONSTRAINT fk_Compañia
        FOREIGN KEY(idCompañia) 
        REFERENCES Compañia(idCompañia)
        ON DELETE CASCADE,
    CONSTRAINT check_TipoPlanta CHECK( tipoPlanta in ('Suministradora','Ensambladora'))
);

CREATE TABLE Vehiculo(
    vin VARCHAR(10) NOT NULL,
    idCompañia VARCHAR(10) NOT NULL,
    tipoMotor VARCHAR(20) NOT NULL,
    color VARCHAR(20) NOT NULL,
    transmision VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    tipoCarroceria VARCHAR(10) NOT NULL,
    precioCompra NUMBER(13,3) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    PRIMARY KEY(vin),
    CONSTRAINT fk_CompañiaV
        FOREIGN KEY(idCompañia)
        REFERENCES Compañia(idCompañia)
        ON DELETE CASCADE
);

CREATE TABLE Proveedor(
    idProveedor VARCHAR(10) NOT NULL,
    nombreProveedor VARCHAR(15) NOT NULL,
    PRIMARY KEY(idProveedor)
);

CREATE TABLE Cliente(
    rtnClien VARCHAR(10) NOT NULL,
    nombreCliente VARCHAR(15) NOT NULL,
    direccion VARCHAR(15) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    tipoCliente VARCHAR(7) NOT NULL,
    idPersona VARCHAR(10),
    sexo char(1),
    ingresoAnual NUMBER(13,3),
    tipoEmpresa VARCHAR(10),
    PRIMARY KEY(rtnClien),
    UNIQUE(idPersona)
);

CREATE TABLE Provee(
    idProveedor VARCHAR(10) NOT NULL,
    idCompañia VARCHAR(10) NOT NULL,
    nombreProducto VARCHAR(30) NOT NULL,
    CONSTRAINT fk_CompañiaP
        FOREIGN KEY(idCompañia)
        REFERENCES Compañia(idCompañia)
        ON DELETE CASCADE,
    CONSTRAINT fk_ProveedorV
        FOREIGN KEY(idProveedor)
        REFERENCES Proveedor(idProveedor)
        ON DELETE CASCADE
);

CREATE TABLE Compra_A (
    rtnCon VARCHAR(10) NOT NULL,
    idCompañia VARCHAR(10) NOT NULL,
    vinVehiculoComprado VARCHAR(10) NOT NULL,
    precioVenta NUMBER(13,3) NOT NULL,
    fechaComprado DATE NOT NULL,
    CONSTRAINT fk_ConcesionarioC
        FOREIGN KEY(rtnCon)
        REFERENCES Concesionario(rtnCon)
        ON DELETE CASCADE,
    CONSTRAINT fk_CompañiaC
        FOREIGN KEY(idCompañia)
        REFERENCES Compañia(idCompañia)
        ON DELETE CASCADE
);

CREATE TABLE Le_Vende_A (
    rtnCon VARCHAR(10) NOT NULL,
    rtnClien VARCHAR(10) NOT NULL,
    vinVehiculoVendido VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT fk_ConcesionarioV
        FOREIGN KEY(rtnCon)
        REFERENCES Concesionario(rtnCon)
        ON DELETE CASCADE,
    CONSTRAINT fk_ClienteV
        FOREIGN KEY(rtnClien)
        REFERENCES Cliente(rtnClien)
        ON DELETE CASCADE
);

CREATE TABLE Bitacora(
    ip VARCHAR(50) NOT NULL,
    tablaReferencia VARCHAR(17) NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    operacion VARCHAR(7) NOT NULL,
    fecha TIMESTAMP NOT NULL
);

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------- Procedimientos Almacenados-------------------------------------------------------


------------------------------------------------------ Compañia-----------------------------------------------------------------

-- Insetar
CREATE PROCEDURE sp_insertarCompañia(
        idCompañia IN compañia.idcompañia%TYPE, 
        nombreCompañia IN compañia.nombrecompañia%TYPE)
    IS
    BEGIN
        INSERT INTO compañia VALUES (idCompañia,nombreCompañia);
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar 
CREATE PROCEDURE sp_modificarCompañia(
        idCompVerificar IN compañia.idcompañia%TYPE, 
        newNameEnterp IN compañia.nombrecompañia%TYPE)
    IS
    BEGIN
        UPDATE compañia
        SET nombreCompañia = newNameEnterp
        WHERE idCompañia = idCompVerificar;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Eliminar
CREATE PROCEDURE sp_eliminarCompañia(
        idCompVerificar IN compañia.idcompañia%TYPE)
    IS
    BEGIN
        DELETE FROM compañia 
        WHERE idCompañia = idCompVerificar; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;


------------------------------------------------------Concesionario-------------------------------------------------------------

-- Insetar
CREATE or replace PROCEDURE sp_insertarConcesionario(
        rtnCon IN concesionario.rtnCon%TYPE, 
        nombreConcesionario IN concesionario.nombreConcesionario%TYPE,
        pais IN concesionario.pais%TYPE)
    IS
    BEGIN
        INSERT INTO concesionario VALUES (rtncon,nombreconcesionario,pais);
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Modificar
CREATE PROCEDURE sp_modificarConcesionario(
        rtnConVerificar IN concesionario.rtnCon%TYPE, 
        newNombreCon IN concesionario.nombreConcesionario%TYPE,
        paisNuevo IN concesionario.pais%TYPE)
    IS
    BEGIN
        UPDATE concesionario
        SET nombreconcesionario= newNombreCon, pais = paisNuevo
        WHERE rtncon = rtnconverificar;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
--Eliminar
CREATE PROCEDURE sp_eliminarConcesionario(
        rtnConVerificar IN concesionario.rtncon%TYPE)
    IS
    BEGIN
        DELETE FROM concesionario 
        WHERE rtncon = rtnconverificar; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

-----------------------------------------------------Planta Fabricacion---------------------------------------------------------

-- Insertar
CREATE PROCEDURE sp_insertarPFabricacion(
        idPlanta IN plantafabricacion.idPlanta%TYPE, 
        idCompañia IN plantafabricacion.idCompañia%TYPE,
        nombrePlanta IN plantafabricacion.nombrePlanta%TYPE,
        tipoPlanta IN plantafabricacion.tipoPlanta%TYPE)
    IS
    BEGIN
        INSERT INTO plantaFabricacion VALUES (idPlanta,idCompañia,nombrePlanta,tipoPlanta);
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Modificar
CREATE PROCEDURE sp_modificarPFabricacion(
        idPlantaVerif IN plantafabricacion.idPlanta%TYPE, 
        idCompañiaNuevo IN plantafabricacion.idCompañia%TYPE,
        nombrePlantaNuevo IN plantafabricacion.nombrePlanta%TYPE,
        tipoPlantaNuevo IN plantafabricacion.tipoPlanta%TYPE)
    IS
    BEGIN
        UPDATE plantaFabricacion
        SET idcompañia= idcompañianuevo, nombreplanta = nombreplantanuevo, tipoplanta = tipoplantanuevo
        WHERE idplanta = idplantaverif;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE PROCEDURE sp_eliminarPFabricacion(
        idPlantaVerif IN plantafabricacion.idPlanta%TYPE)
    IS
    BEGIN
        DELETE FROM plantaFabricacion
        WHERE idplanta = idplantaverif; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;


----------------------------------------------------------Vehiculo--------------------------------------------------------------


--Insertar
CREATE PROCEDURE sp_insertarVehiculo(
        vin IN vehiculo. vin%TYPE,
        idCompañia IN vehiculo.idCompañia%TYPE,
        tipoMotor IN vehiculo.tipoMotor%TYPE,
        color IN vehiculo.color%TYPE,
        transimision IN vehiculo.transmision%TYPE,
        modelo IN vehiculo.modelo%TYPE,
        tipoCarroceria IN vehiculo.tipoCarroceria%TYPE,
        precioCompra IN vehiculo.preciocompra%TYPE,
        marca IN vehiculo.marca%TYPE)
    IS
    BEGIN
        INSERT INTO vehiculo VALUES (vin,idcompañia,tipomotor,color,transimision,modelo,tipocarroceria,preciocompra,marca);
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Modificar
CREATE PROCEDURE sp_modificarVehiculo(
        vinVerif IN vehiculo. vin%TYPE,
        idCompañiaNew IN vehiculo.idCompañia%TYPE,
        tipoMotorNew IN vehiculo.tipoMotor%TYPE,
        colorNew IN vehiculo.color%TYPE,
        transimisionNew IN vehiculo.transmision%TYPE,
        modeloNew IN vehiculo.modelo%TYPE,
        tipoCarroceriaNew IN vehiculo.tipoCarroceria%TYPE,
        precioCompraNew IN vehiculo.preciocompra%TYPE,
        marcaNew IN vehiculo.marca%TYPE)
    IS
    BEGIN
        UPDATE vehiculo
        SET idcompañia = idcompañianew, tipomotor = tipomotornew, color = colornew, transmision = transimisionnew, modelo = modelonew, tipocarroceria = tipocarrocerianew, preciocompra = preciocompranew, marca = marcanew 
        WHERE vin = vinverif;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE PROCEDURE sp_eliminarVehiculo(
        vinVerif IN vehiculo.vin%TYPE)
    IS
    BEGIN
        DELETE FROM vehiculo
        WHERE vin = vinverif; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

---------------------------------------------------------- Cliente--------------------------------------------------------------

-- Insertar
CREATE PROCEDURE sp_insertarCliente(
        rtnClien IN cliente.rtnclien%TYPE,
        nombreCliente IN cliente.nombrecliente%TYPE,
        direccion IN cliente.direccion%TYPE,
        telefono IN cliente.telefono%TYPE,
        tipoClienteNum IN INTEGER,
        idPersona IN cliente.idpersona%TYPE,
        sexo IN cliente.sexo%TYPE,
        ingresoAnual IN cliente.ingresoanual%TYPE,
        tipoEmpresa IN cliente.tipoempresa%TYPE)
    IS
    BEGIN
        IF tipoClienteNum = 0 THEN
            INSERT INTO cliente VALUES (rtnClien,nombreCliente,direccion,telefono,'Empresa',NULL,NULL,NULL,tipoEmpresa);
        ELSE
            INSERT INTO cliente VALUES (rtnClien, nombreCliente, direccion, telefono, 'Persona', idPersona,sexo,ingresoAnual,NULL);
        END IF; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

--Modificar
CREATE PROCEDURE sp_modificarCliente(
        rtnClienVerif IN cliente.rtnclien%TYPE,
        nombreClienteNew IN cliente.nombrecliente%TYPE,
        direccionNew IN cliente.direccion%TYPE,
        telefonoNew IN cliente.telefono%TYPE,
        tipoClienteVerif IN cliente.tipocliente%TYPE,
        idPersonaNew IN cliente.idpersona%TYPE,
        sexoNew IN cliente.sexo%TYPE,
        ingresoAnualNew IN cliente.ingresoanual%TYPE,
        tipoEmpresaNew IN cliente.tipoempresa%TYPE)
    IS
    BEGIN
        IF tipoclienteverif = 'Cliente' THEN
            UPDATE cliente
            SET nombrecliente = nombreclientenew, direccion = direccionnew, telefono = telefononew, idpersona = idpersonanew, sexo = sexonew, ingresoanual = ingresoanualnew
            WHERE rtnclien = rtnclienverif;
        ELSE
            UPDATE cliente
            SET nombrecliente = nombreclientenew, direccion = direccionnew, telefono = telefononew, tipoempresa = tipoempresanew
            WHERE rtnclien = rtnclienverif;
        END IF;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Eliminar
CREATE PROCEDURE sp_eliminarCliente(
        rtnClienVerif IN cliente.rtnclien%TYPE)
    IS
    BEGIN
        DELETE FROM cliente
        WHERE rtnclien = rtnclienverif; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
    
---------------------------------------------------------- Proveedor------------------------------------------------------------

-- Insertar
CREATE PROCEDURE sp_insertarProveedor(
        idProveedor IN proveedor.idProveedor%TYPE,
        nombreProveedor IN proveedor.nombreproveedor%TYPE)
    IS
    BEGIN
        INSERT INTO proveedor VALUES (idProveedor,nombreProveedor); 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Modificar
CREATE PROCEDURE sp_modificarProveedor(
        idProveedorVerif IN proveedor.idProveedor%TYPE,
        nombreProveedorNew IN proveedor.nombreproveedor%TYPE)
    IS
    BEGIN
        UPDATE proveedor
        SET nombreProveedor = nombreProveedorNew
        WHERE idProveedor = idProveedorVerif;
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;  
    
--Eliminar
CREATE PROCEDURE sp_eliminarProveedor(
       idProveedorVerif IN proveedor.idProveedor%TYPE)
    IS
    BEGIN
        DELETE FROM proveedor
        WHERE idproveedor = idProveedorVerif; 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

----------------------------------------------------------Provee----------------------------------------------------------------
    
-- Insertar
CREATE PROCEDURE sp_insertarProvee(
        idProveedor IN provee.idProveedor%TYPE,
        idCompañia IN provee.idCompañia%TYPE,
        nombreProducto IN provee.nombreProducto%TYPE)
    IS
    BEGIN
        INSERT INTO provee VALUES (idProveedor,idCompañia,nombreProducto); 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;   

----------------------------------------------------------Compra_A--------------------------------------------------------------

-- Insertar
CREATE or replace PROCEDURE sp_insertarCompra_A(
        rtnCon IN compra_a.rtnCon%TYPE,
        idCompañia IN compra_a.idCompañia%TYPE,
        vinVehiculoComprado IN compra_a.vinVehiculoComprado%TYPE,
        precioVenta IN compra_a.precioVenta%TYPE,
        fechaComprado IN compra_a.fechaComprado%TYPE)
    IS
    BEGIN
        INSERT INTO compra_a VALUES (rtnCon,idCompañia,vinVehiculoComprado,precioVenta,fechaComprado); 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END; 


----------------------------------------------------------Le_Vende_A------------------------------------------------------------

-- Insertar
CREATE or replace PROCEDURE sp_insertarLe_Vende_A(
        rtnCon IN le_vende_a.rtnCon%TYPE,
        rtnClien IN le_vende_a.rtnClien%TYPE,
        vinVehiculoVendido IN le_vende_a.vinVehiculoVendido%TYPE,
        fecha IN le_vende_a.fecha%TYPE)
    IS
    BEGIN
        INSERT INTO le_vende_a VALUES (rtnCon,rtnClien,vinVehiculoVendido,fecha); 
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------Funciones--------------------------------------------------------------

--Funcion que obtiene la ip de la maquina
CREATE FUNCTION obtener_IP RETURN VARCHAR
    IS
        ip VARCHAR(50);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO ip 
        FROM dual;
        return ip;
    END;

--Funcion que retorna el Timestamp actual
CREATE FUNCTION obtener_Timestamp RETURN TIMESTAMP
    IS
        currentT TIMESTAMP;
    BEGIN
        SELECT CURRENT_TIMESTAMP INTO currentT
        FROM dual;
        return currentT;
    END;

--Funcion que retorna la ultima fecha en que se vendio un vehiculo
CREATE FUNCTION obtenerUltimaFecha RETURN DATE
    IS
        fechaFinal DATE;
    BEGIN
        SELECT max(fecha) INTO fechafinal
        FROM le_vende_a;
        RETURN fechafinal;
    END;

--Funcion qye encuentra la diferencia entre dos fechas
CREATE FUNCTION obtenerDiferenciaDias(fecha1 DATE,fecha2 DATE) RETURN INTEGER
    IS
        diferenciaDias INTEGER;
    BEGIN
        SELECT fecha1 - fecha2 INTO diferenciaDias
        FROM dual;
        return diferenciaDias;
    END;

-------------------------------------------------------Triggers-----------------------------------------------------------------


------------------------------------------------------ Compañia-----------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarCompañia AFTER INSERT ON compañia
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Compañia',:NEW.idCompañia,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarCompañia AFTER UPDATE ON compañia
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Compañia',:NEW.idCompañia,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarCompañia AFTER DELETE ON compañia
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Compañia',:OLD.idCompañia,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
    
------------------------------------------------------Concesionario-------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarConcesionario AFTER INSERT ON Concesionario
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Concesionario',:NEW.rtnCon,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarConcesionario AFTER UPDATE ON Concesionario
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Concesionario',:NEW.rtnCon,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarConcesionario AFTER DELETE ON Concesionario
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Concesionario',:OLD.rtnCon,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;


-----------------------------------------------------Planta Fabricacion---------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarPFabricacion AFTER INSERT ON PlantaFabricacion
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'PlantaFabricacion',:NEW.idPlanta,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarPFabricacion AFTER UPDATE ON PlantaFabricacion
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'PlantaFabricacion',:NEW.idPlanta,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarPFabricacion AFTER DELETE ON PlantaFabricacion
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'PlantaFabricacion',:OLD.idPlanta,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

----------------------------------------------------------Vehiculo--------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarVehiculo AFTER INSERT ON Vehiculo
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Vehiculo',:NEW.vin,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarVehiculo AFTER UPDATE ON Vehiculo
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Vehiculo',:NEW.vin,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarVehiculo AFTER DELETE ON Vehiculo
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Vehiculo',:OLD.vin,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;


---------------------------------------------------------- Cliente--------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarCliente AFTER INSERT ON Cliente
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Cliente',:NEW.rtnClien,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarCliente AFTER UPDATE ON Cliente
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Cliente',:NEW.rtnClien,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarCliente AFTER DELETE ON Cliente
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Cliente',:OLD.rtnClien,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    

---------------------------------------------------------- Proveedor------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarProveedor AFTER INSERT ON Proveedor
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Proveedor',:NEW.idProveedor,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

-- Modificar
CREATE TRIGGER trg_modificarProveedor AFTER UPDATE ON Proveedor
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Proveedor',:NEW.idProveedor,'Update',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
-- Eliminar
CREATE TRIGGER trg_eliminarProveedor AFTER DELETE ON Proveedor
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Proveedor',:OLD.idProveedor,'Delete',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;
    
---------------------------------------------------------- Provee---------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarProvee AFTER INSERT ON Provee
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Provee',:NEW.idProveedor,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

---------------------------------------------------------- Compra_A-------------------------------------------------------------

-- Insetar
CREATE TRIGGER trg_insetarCompra_A AFTER INSERT ON Compra_a
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Compra_A',:NEW.vinVehiculoComprado,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

---------------------------------------------------------- Le_Vende_A-----------------------------------------------------------

--Insertar
CREATE TRIGGER trg_insetarLe_Vende_A AFTER INSERT ON Le_Vende_A
    FOR EACH ROW
    BEGIN
        INSERT INTO bitacora VALUES (obtener_IP(),'Le_Vende_A',:NEW.vinVehiculoVendido,'Insert',obtener_timestamp());
    EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    END;

---------------------------------------------------------- Views ---------------------------------------------------------------

-- 1. Mostrar tendencias de ventas para varias marcas en los últimos 3 años, por año, mes, semana. Luego separe estos datos por 
-- género del comprador y luego por rango de ingresos.

-- Vista que ejecuta las por año y genero
CREATE VIEW tendenciaVentasAñoGen AS
SELECT marca, count(marca) as CantMarca,EXTRACT(YEAR FROM le_vende_a.fecha) as Año, sexo as Genero
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, EXTRACT(YEAR FROM le_vende_a.fecha), sexo
ORDER BY EXTRACT(YEAR FROM le_vende_a.fecha);

-- Vista que ejecuta las por año e ingreso
CREATE VIEW tendenciaVentasAñoIngreso AS
SELECT marca, count(marca) as CantMarca,EXTRACT(YEAR FROM le_vende_a.fecha) as Año, cliente.ingresoanual as Ingresos
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, EXTRACT(YEAR FROM le_vende_a.fecha), le_vende_a.fecha, cliente.ingresoanual, cliente.sexo
ORDER BY EXTRACT(YEAR FROM le_vende_a.fecha);

-- Vista que ejecuta las por mes y genero
CREATE VIEW tendenciaVentasMesGen AS
SELECT marca, count(marca) as CantMarca,EXTRACT(MONTH FROM le_vende_a.fecha) as Mes, sexo as Genero
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, EXTRACT(MONTH FROM le_vende_a.fecha), sexo
ORDER BY EXTRACT(MONTH FROM le_vende_a.fecha);

-- Vista que ejecuta las por mes e ingreso

CREATE VIEW tendenciaVentasMesIngreso AS
SELECT marca, count(marca) as CantMarca,EXTRACT(MONTH FROM le_vende_a.fecha) as Mes, cliente.ingresoanual as Ingresos
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, EXTRACT(MONTH FROM le_vende_a.fecha), le_vende_a.fecha, cliente.ingresoanual, cliente.sexo
ORDER BY EXTRACT(MONTH FROM le_vende_a.fecha);

-- Vista que ejecuta las por semana y genero
CREATE VIEW tendenciaVentasSemanaGen AS
SELECT marca, count(marca) as CantMarca,to_number(to_char(le_vende_a.fecha,'WW')) as Semana, sexo as Genero
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, to_number(to_char(le_vende_a.fecha,'WW')), sexo
ORDER BY to_number(to_char(le_vende_a.fecha,'WW'));

-- Vista que ejecuta las por semana e ingreso
CREATE VIEW tendenciaVentasSemanaIngreso AS
SELECT marca, count(marca) as CantMarca,to_number(to_char(le_vende_a.fecha,'WW')) as Semana, cliente.ingresoanual as Ingresos
FROM cliente INNER JOIN le_vende_a ON cliente.rtnClien = le_vende_a.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE cliente.tipoCliente = 'Persona' and EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '3' YEAR))  
GROUP BY marca, to_number(to_char(le_vende_a.fecha,'WW')), le_vende_a.fecha, cliente.ingresoanual, cliente.sexo
ORDER BY to_number(to_char(le_vende_a.fecha,'WW'));


-- 2.Suponga que se descubre que las transmisiones realizadas por el proveedor ‘XXX’ entre dos fechas dadas son defectuosas. 
-- Encuentre el VIN de cada automóvil que contenga dicha transmisión y el cliente al que se vendió. Si su diseño lo permite, 
-- suponga que todas las transmisiones defectuosas provienen de solo una de las plantas de ‘XXX’.

CREATE VIEW transMisionDefectuosa AS
SELECT vehiculo.transmision, vehiculo.vin, cliente.rtnClien, cliente.nombreCliente, proveedor.idProveedor, proveedor.nombreProveedor, le_vende_a.fecha
FROM le_vende_a INNER JOIN cliente ON le_vende_a.rtnClien = cliente.rtnClien
     INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
     INNER JOIN compañia ON vehiculo.idCompañia = compañia.idCompañia
     INNER JOIN provee ON compañia.idCompañia = provee.idCompañia
     INNER JOIN proveedor ON provee.idProveedor = proveedor.idProveedor;

--hace la siguiente consulta en el mero programa
--SELECT vin, rtnClien, nombreCliente
--FROM transmisiondefectuosa
--WHERE fecha1 > transmisionDefectuosa.fecha and fecha2 < transmisionDefectuosa.fecha and
   -- transmisionDefectuosa.transmision = transmisionVerif and transmisionDefectuosa.idProveedor = idproveedorverif;

-- 3. Encuentra las 2 mejores marcas por cantidad en dólares vendidas en el último año
CREATE VIEW mejoresMarcasGanancia AS
SELECT marca, sum(precioVenta) as Cantidad
FROM le_vende_a INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
    INNER JOIN compra_a ON le_vende_a.rtnCon = compra_a.rtnCon
WHERE EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '1' YEAR))
        and rownum <= 2
GROUP BY marca
ORDER BY sum(precioVenta) DESC;

-- 4.Encuentre las 2 mejores marcas por unidad de ventas en el último año.
CREATE VIEW mejoresMarcasVentas AS
SELECT marca, count(marca) as "Unidad de Ventas"
FROM le_vende_a INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE EXTRACT(YEAR FROM le_vende_a.fecha) <= EXTRACT(YEAR FROM obtenerUltimaFecha) and EXTRACT(YEAR FROM le_vende_a.fecha) >= EXTRACT(YEAR FROM (obtenerUltimaFecha - INTERVAL '1' YEAR))
      and rownum <= 2  
GROUP BY marca
ORDER BY count(marca) DESC;

--5 ¿En qué mes(es) se venden mejor los convertibles?
CREATE VIEW mesConvertibles AS
SELECT tipoCarroceria, count(tipoCarroceria)as "Unidad de Ventas", EXTRACT(MONTH FROM le_vende_a.fecha) as Mes
FROM le_vende_a INNER JOIN vehiculo ON le_vende_a.vinVehiculoVendido = vehiculo.vin
WHERE vehiculo.tipoCarroceria = 'Convertible'
GROUP BY EXTRACT(MONTH FROM le_vende_a.fecha), tipoCarroceria
ORDER BY EXTRACT(MONTH FROM le_vende_a.fecha);

-- 6. Encuentre los distribuidores que mantienen un vehículo en inventario por el tiempo promedio más largo
CREATE VIEW distribMenosEficaz AS
SELECT concesionario.rtnCon, concesionario.nombreConcesionario,obtenerDiferenciaDias(le_vende_a.fecha,compra_a.fechaComprado) as "Dias De Tardanza"
FROM le_vende_a INNER JOIN compra_a ON le_vende_a.rtnCon = compra_a.rtnCon
    INNER JOIN concesionario ON compra_a.rtnCon = concesionario.rtnCon
WHERE le_vende_a.vinVehiculoVendido = compra_a.vinvehiculocomprado
ORDER BY obtenerDiferenciaDias(le_vende_a.fecha,compra_a.fechaComprado);



