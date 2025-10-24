const connex = require("../mysql/connex");

/**
 * Obtiene todas las tareas
 * @params {Object} filters: Filtros Opcionales (completed, priority)
 * @returns {Array} Lista de tareas
*/
async function getAll(filters = {}) {
    try {
        let query = "SELECT * FROM bicicletas WHERE 1=1";
        const params = [];

        // filtrar por estado completado
        if (filters.estadoid !== undefined) {
            query += " AND estadoid = ?";
            params.push(filters.estadoid);
        }

        // filtrar por prioridad
        if (filters.idModelo !== undefined) {
            query += " AND idModelosBici = ?";
            params.push(filters.idModelo);
        }

        console.log("Query:", query);
        console.log("Params:", params);
        console.log("filters.estadoid:", filters.estadoid);

        const [rows] = await connex.query(query, params);
        //const [rows] = await connex.query("SELECT * FROM bicicletas");
        return rows;
    } catch (error) {
        throw error;
    }
}

/**
 * Crear una nueva Tarea
 * @params {Object} todoDATA
 * @returns {Array} Lista de tareas
*/
async function create(todoDATA) {
    try {
        const [result] = await connex.query("INSERT INTO bicicletas (idbicicletas, fecha_inicio_expl, estadoid) VALUES (?,?,?)", 
            [todoDATA.idbicicletas, todoDATA.fecha_inicio_expl, todoDATA.estadoid]);
        return result;
    } catch (error) {
        throw error;
    }
}


/**
 * Obtener una tarea por ID
 * @params {number} id - ID de la tarea
 * @returns {Object|null} Tarea encontrada o null
 */
async function getByID(id = 0) {
    try {
        if (!isNaN(id) && id > 0) {
            const [rows] = await connex.query("SELECT * FROM bicicletas WHERE idbicicletas = ?", [id]);
            return rows[0] || null;
        }
        return null;
    } catch (error) {
        throw error;
    }
}


/**
 * Actualizar una tarea existente
 * @params {number} id - ID de la tarea
 * @params {Object} updateData - Datos a actualizar
 * @returns {Object|null} Tarea actualizada o null
 */
async function update(id, todoDATA) {
    try {
        const updates = [];
        const params = [];
       
        console.log("Parámetros de actualización:", params);

        if (todoDATA.fecha_inicio_expl !== undefined) {
            updates.push("fecha_inicio_expl = ?");
            params.push(todoDATA.fecha_inicio_expl);
        }
        if (todoDATA.estadoid !== undefined) {
            updates.push("estadoid = ?");
            params.push(todoDATA.estadoid ? 1 : 0);
        }
        if (todoDATA.idclientes !== undefined) {
            updates.push("idclientes = ?");
            params.push(todoDATA.idclientes);
        }
        if (todoDATA.idModelosBici !== undefined) {
            updates.push("idModelosBici = ?");
            params.push(todoDATA.idModelosBici);
        }

        if (updates.length === 0) return null;

        params.push(id);
        const query = `UPDATE bicicletas SET ${updates.join(", ")} WHERE idbicicletas = ?`;
        console.log("Query de actualización:", query);
        console.log("Parámetros de actualización:", params);

        const [result] = await connex.query(query, params);

        if (result.affectedRows === 0) return null;

        // Obtener la tarea actualizada
        const [rows] = await connex.query("SELECT * FROM bicicletas WHERE idbicicletas = ?", [id]);
        return rows[0];
    } catch (error) {
        throw error;
    }
}


/**
 * Eliminar una tarea por ID
 * @params {number} id - ID de la tarea
 * @returns {boolean} true si se eliminó, false si no se encontró
 */
async function deleteID(id) {
    try {
        // Primero obtener la tarea antes de eliminarla
        const [rows] = await connex.query("SELECT * FROM bicicletas WHERE idbicicletas = ?", [id]);

        if (rows.length === 0) return false;

        const deletedTodo = rows[0];
        await connex.query("DELETE FROM bicicletas WHERE idbicicletas = ?", [id]);

        return deletedTodo;
    } catch (error) {
        throw error;
    }
}


/**
 * Obtener estadísticas de las tareas
 * @returns {Object} Estadísticas:
 *   - completed: cantidad de tareas completadas
 *   - pending: cantidad de tareas pendientes
 *   - byPriority: { low: X, medium: Y, high: Z }
 */
async function getStats() {
    try {
        const [completedResult] = await connex.query(
            "SELECT COUNT(*) as count FROM todos WHERE completed = 1"
        );
        const [pendingResult] = await connex.query(
            "SELECT COUNT(*) as count FROM todos WHERE completed = 0"
        );
        const [priorityResult] = await connex.query(
            "SELECT priority, COUNT(*) as count FROM todos GROUP BY priority"
        );

        const byPriority = {
            low: 0,
            medium: 0,
            high: 0
        };

        priorityResult.forEach(row => {
            if (row.priority) {
                byPriority[row.priority] = row.count;
            }
        });

        const estadisticas = {
            estadisticas: {
                completed: completedResult[0].count,
                pending: pendingResult[0].count,
                byPriority: byPriority
            }
        };

        return estadisticas;
    } catch (error) {
        throw error;
    }
}

/**
 * Devuelve booleano indicando si existe un ID
 * @params {id: num} - id a encontrar
 * @returns {bool} Indica si se ha encontrado la tarea de Id
 */
async function existeID(id) {
    try {
        const [rows] = await connex.query("SELECT idbicicletas FROM bicicletas WHERE idbicicletas = ?", [id]);
        return rows.length > 0;
    } catch (error) {
        throw error;
    }
}




/**
 * Obtiene todas las tareas
 * @params {Object} filters: Filtros Opcionales (completed, priority)
 * @returns {Array} Lista de tareas
*/
async function getFreeBicycles() {
    try {
        const params = [];
        //let query = "SELECT * FROM bicicletas WHERE 1=1";
        let query = 
        'SELECT b.idbicicletas BiciId, b.fecha_inicio_expl "Fecha ini explotacion", e.nombre estado, m.nombre modelo, c.nombre, c.apellidos, c.dni ' +
        ' FROM rentabici.bicicletas b '+
        ' LEFT JOIN rentabici.clientes c ON  b.idclientes=c.idclientes' +
        ' INNER JOIN rentabici.estados e ON b.estadoid=e.idestados ' +
        ' INNER JOIN rentabici.modelosbici m ON b.idModelosBici=m.idModelosBici '+
        ' WHERE b.estadoid=3'; // estadoid=3 significa "free" o "disponible"
        
        const [rows] = await connex.query(query, params);
        return rows;
    } catch (error) {
        throw error;
    }
}




/**
 * Obtiene todas los mantenimientos
 * @returns {Array} Lista de mantenimientos
*/
async function getMantenimientos() {
    try {
        const params = [];
        //let query = "SELECT * FROM bicicletas WHERE 1=1";
        let query = 
        'SELECT idMantenimiento, fecha_ini, fecha_fin, descripcion, precio, bicicletas_idbicicletas,  e.nombre estado' +
        ' FROM mantenimiento m, bicicletas b, rentabici.estados e' +
        ' WHERE b.estadoid=e.idestados and m.bicicletas_idbicicletas=b.idbicicletas'; 

        const [rows] = await connex.query(query, params);
        return rows;
    } catch (error) {
        throw error;
    }
}



/**
 * Lista clientes
 * @returns {Array} Lista de clientes
*/
async function getClientes() {
    try {
        const params = [];
        //let query = "SELECT * FROM bicicletas WHERE 1=1";
        let query = 
        'SELECT idclientes, nombre, apellidos, dni, direccion, email, telefono FROM clientes'; 

        const [rows] = await connex.query(query, params);
        return rows;
    } catch (error) {
        throw error;
    }
}


/**
 * Lista modelos con cantidad de bicicletas
 * @returns {Array} Lista de modelos con cantidad de bicicletas
*/
async function getModelos() {
    try {
        const params = [];
        //let query = "SELECT * FROM bicicletas WHERE 1=1";
        let query = 
        'SELECT idModelosBici, nombre, fecha_garantia, nombrefabricante,' +
        ' (select count(*) from bicicletas b ' +
        ' where b.idModelosBici=m.idModelosBici)' +
        ' FROM modelosbici m'; 

        const [rows] = await connex.query(query, params);
        return rows;
    } catch (error) {
        throw error;
    }
}




/**
 * Lista rentas
 * @returns {Array} Lista de rentas
*/
async function getRentas() {
  try {
    const params = [];
    let query =
      "SELECT clientes_idclientes IdCliente, c.nombre, c.apellidos, c.dni, bicicletas_idbicicletas, tiempo_inicio_renta, tiempo_fin_renta," +
      ' (select direccion from aparcamientos a where a.idaparcamiento = r.aparcamiento_init) "Dir init" , ' +
      ' (select direccion from aparcamientos a where a.idaparcamiento = r.aparcamiento_final) "Dir fin"' +
      " FROM rentas r, clientes c" +
      " where r.clientes_idclientes=c.idclientes";

    const [rows] = await connex.query(query, params);
    return rows;
  } catch (error) {
    throw error;
  }
}









module.exports = {
    getAll,
    create,
    getByID,
    update,
    deleteID,
    getStats,
    existeID,
    getFreeBicycles,
    getMantenimientos,
    getClientes,
    getModelos,
    getRentas
}