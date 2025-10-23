-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema rentabici
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `rentabici` ;

-- -----------------------------------------------------
-- Schema rentabici
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rentabici` DEFAULT CHARACTER SET utf8 ;
USE `rentabici` ;

-- -----------------------------------------------------
-- Table `rentabici`.`aparcamientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`aparcamientos` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`aparcamientos` (
  `idaparcamiento` INT(11) NOT NULL AUTO_INCREMENT,
  `Direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idaparcamiento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `rentabici`.`modelosbici`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`modelosbici` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`modelosbici` (
  `idModelosBici` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `fecha_garantia` DATE NOT NULL,
  `nombrefabricante` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idModelosBici`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `rentabici`.`estados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`estados` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`estados` (
  `idestados` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idestados`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `rentabici`.`bicicletas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`bicicletas` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`bicicletas` (
  `idbicicletas` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio_expl` DATE NOT NULL,
  `estadoid` INT(11) NOT NULL,
  `idclientes` VARCHAR(45) NULL DEFAULT NULL,
  `idModelosBici` INT(11) NOT NULL,
  PRIMARY KEY (`idbicicletas`),
  CONSTRAINT `fk_bicicletas_ModelosBici1`
    FOREIGN KEY (`idModelosBici`)
    REFERENCES `rentabici`.`modelosbici` (`idModelosBici`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bicicletas_estados`
    FOREIGN KEY (`estadoid`)
    REFERENCES `rentabici`.`estados` (`idestados`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_bicicletas_ModelosBici1` ON `rentabici`.`bicicletas` (`idModelosBici` ASC) VISIBLE;

CREATE INDEX `fk_bicicletas_estados` ON `rentabici`.`bicicletas` (`estadoid` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rentabici`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`clientes` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`clientes` (
  `idclientes` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `dni` VARCHAR(9) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idclientes`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `rentabici`.`mantenimiento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`mantenimiento` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`mantenimiento` (
  `idMantenimiento` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha_ini` DATE NOT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `descricion` VARCHAR(450) NOT NULL,
  `precio` DECIMAL(10,0) NULL DEFAULT NULL,
  `bicicletas_idbicicletas` INT(11) NOT NULL,
  PRIMARY KEY (`idMantenimiento`),
  CONSTRAINT `fk_Mantenimiento_bicicletas1`
    FOREIGN KEY (`bicicletas_idbicicletas`)
    REFERENCES `rentabici`.`bicicletas` (`idbicicletas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_Mantenimiento_bicicletas1` ON `rentabici`.`mantenimiento` (`bicicletas_idbicicletas` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rentabici`.`pricebook`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`pricebook` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`pricebook` (
  `idpricebook` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha_ini` DATE NULL DEFAULT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `ModelosBici_idModelosBici` INT(11) NOT NULL,
  PRIMARY KEY (`idpricebook`),
  CONSTRAINT `fk_pricebook_ModelosBici1`
    FOREIGN KEY (`ModelosBici_idModelosBici`)
    REFERENCES `rentabici`.`modelosbici` (`idModelosBici`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_pricebook_ModelosBici1` ON `rentabici`.`pricebook` (`ModelosBici_idModelosBici` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rentabici`.`rentas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`rentas` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`rentas` (
  `clientes_idclientes` INT(11) NOT NULL,
  `bicicletas_idbicicletas` INT(11) NOT NULL,
  `tiempo_inicio_renta` DATETIME NOT NULL,
  `tiempo_fin_renta` DATETIME NULL DEFAULT NULL,
  `aparcamiento_final` INT(11) NOT NULL,
  `aparcamiento_init` INT(11) NOT NULL,
  `idrentas` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idrentas`),
  CONSTRAINT `fk_clientes_has_bicicletas_bicicletas1`
    FOREIGN KEY (`bicicletas_idbicicletas`)
    REFERENCES `rentabici`.`bicicletas` (`idbicicletas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_clientes_has_bicicletas_clientes`
    FOREIGN KEY (`clientes_idclientes`)
    REFERENCES `rentabici`.`clientes` (`idclientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rentas_aparcamientos1`
    FOREIGN KEY (`aparcamiento_final`)
    REFERENCES `rentabici`.`aparcamientos` (`idaparcamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rentas_aparcamientos2`
    FOREIGN KEY (`aparcamiento_init`)
    REFERENCES `rentabici`.`aparcamientos` (`idaparcamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_clientes_has_bicicletas_clientes` ON `rentabici`.`rentas` (`clientes_idclientes` ASC) VISIBLE;

CREATE INDEX `fk_clientes_has_bicicletas_bicicletas1` ON `rentabici`.`rentas` (`bicicletas_idbicicletas` ASC) VISIBLE;

CREATE INDEX `fk_rentas_aparcamientos1` ON `rentabici`.`rentas` (`aparcamiento_final` ASC) VISIBLE;

CREATE INDEX `fk_rentas_aparcamientos2` ON `rentabici`.`rentas` (`aparcamiento_init` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rentabici`.`facturas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rentabici`.`facturas` ;

CREATE TABLE IF NOT EXISTS `rentabici`.`facturas` (
  `idfacturas` INT(11) NOT NULL AUTO_INCREMENT,
  `precio_hora` DECIMAL(10,0) NULL DEFAULT NULL,
  `precio_total` DECIMAL(10,0) NULL DEFAULT NULL,
  `tipodefactura` VARCHAR(45) NULL DEFAULT NULL,
  `rentas_idrentas` INT(11) NOT NULL,
  `clientes_idclientes` INT(11) NOT NULL,
  `bicicletas_idbicicletas` INT(11) NOT NULL,
  `pricebook_idpricebook` INT(11) NOT NULL,
  `Mantenimiento_idMantenimiento` INT(11) NOT NULL,
  PRIMARY KEY (`idfacturas`),
  CONSTRAINT `fk_facturas_Mantenimiento1`
    FOREIGN KEY (`Mantenimiento_idMantenimiento`)
    REFERENCES `rentabici`.`mantenimiento` (`idMantenimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facturas_bicicletas1`
    FOREIGN KEY (`bicicletas_idbicicletas`)
    REFERENCES `rentabici`.`bicicletas` (`idbicicletas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facturas_clientes1`
    FOREIGN KEY (`clientes_idclientes`)
    REFERENCES `rentabici`.`clientes` (`idclientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facturas_pricebook1`
    FOREIGN KEY (`pricebook_idpricebook`)
    REFERENCES `rentabici`.`pricebook` (`idpricebook`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facturas_rentas1`
    FOREIGN KEY (`rentas_idrentas`)
    REFERENCES `rentabici`.`rentas` (`idrentas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_facturas_rentas1` ON `rentabici`.`facturas` (`rentas_idrentas` ASC) VISIBLE;

CREATE INDEX `fk_facturas_clientes1` ON `rentabici`.`facturas` (`clientes_idclientes` ASC) VISIBLE;

CREATE INDEX `fk_facturas_bicicletas1` ON `rentabici`.`facturas` (`bicicletas_idbicicletas` ASC) VISIBLE;

CREATE INDEX `fk_facturas_pricebook1` ON `rentabici`.`facturas` (`pricebook_idpricebook` ASC) VISIBLE;

CREATE INDEX `fk_facturas_Mantenimiento1` ON `rentabici`.`facturas` (`Mantenimiento_idMantenimiento` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/*----------------------------------------------------------*/
/*----------------------------------------------------------*/
/*----------------------------------------------------------*/

SELECT * FROM rentabici.bicicletas;
SELECT * FROM rentabici.clientes;
SELECT * FROM rentabici.estados;
SELECT * FROM rentabici.modelosbici;

select b.idbicicletas, b.fecha_inicio_expl, e.nombre, m.nombre, c.nombre, c.apellidos, c.dni
FROM rentabici.bicicletas b, rentabici.clientes c, rentabici.estados e, rentabici.modelosbici m
where 
  b.estadoid=e.idestados and 
  b.idclientes=c.idclientes and 
  b.idModelosBici=m.idModelosBici
  
  SELECT b.idbicicletas, b.fecha_inicio_expl, e.nombre, m.nombre, c.nombre, c.apellidos, c.dni
     FROM rentabici.bicicletas b
     LEFT JOIN rentabici.clientes c
          ON  b.idclientes=c.idclientes 
	INNER JOIN rentabici.estados e
          ON b.estadoid=e.idestados
	INNER JOIN rentabici.modelosbici m
          ON b.idModelosBici=m.idModelosBici
     



     {  "idbicicletas": "6", "fecha_inicio_expl": "2024-01-01" , "estadoid": "1" }

     http://localhost:3000/api/v1/todo/1

     http://localhost:3000/api/v1/todos?estadoid=2