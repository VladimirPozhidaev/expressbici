const express = require("express");
const router = express.Router();
const todoController = require("../controllers/todo.controller");


router.get("/", (req, res) => {
    res.json({"saludo": "hola"})
});

/**
 * @route GET /api/v1/bicycles
 * @desc: Obtener todas las tareas (confiltro opcionales)
 * @query complete (boolean), priority (low|midium|high)
 * @access Public
*/

router.get("/bicycles", todoController.getAllTodos)

/**
 * @route POST /api/v1/bicycles
 * @desc: Crear una nueva tarea
 * @access Public
*/

router.post("/bicycle", todoController.createTodo)

/**
 * @route GET /api/v1/bicycle/:id
 * @desc: Obtener una tarea por ID
 * @access Public
 */
// TODO: router.get("/bicycle/:id", todoController.getTodoById)
router.get("/bicycle/:id", todoController.getTodoById)

/**
 * @route PUT /api/v1/bicycle/:id
 * @desc: Actualizar una tarea por ID
 * @access Public
 */
// TODO: router.put("/bicycle/:id", todoController.updateTodo)
router.put("/bicycle/:id", todoController.updateTodo)

/**
 * @route DELETE /api/v1/bicycle/:id
 * @desc: Eliminar una tarea por ID
 * @access Public
 */
// TODO: router.delete("/bicycle/:id", todoController.deleteTodo)
router.delete("/bicycle/:id", todoController.deleteTodo)

/**
 * @route GET /api/v1/bicycles/stats
 * @desc: Obtener estadísticas de las tareas
 * @access Public
 */
// TODO: router.get("/bicycles/stats", todoController.getStats)
router.get("/bicycle/stats", todoController.getStats)




/**
 * @route GET /api/v1/bicycles/free
 * @desc: Obtener todas las bicicletas libres
 * @access Public
*/

router.get("/bicycles/free", todoController.getFreeBicycles);

/**
 * @route GET /api/v1/bicycles/mantenimientos
 * @desc: Obtener mantenimientos de bicicletas
 * @access Public
*/
router.get("/bicycles/mantenimientos", todoController.getMantenimientos);


/**
 * @route GET /api/v1/bicycles/clientes
 * @desc: Obtener clientes
 * @access Public
*/
router.get("/bicycles/clientes", todoController.getClientes);


/**
 * @route GET /api/v1/bicycles/modelos
 * @desc: Obtener modelos de bicicletas
 * @access Public
*/
router.get("/bicycles/modelos", todoController.getModelos);


/**
 * @route GET /api/v1/bicycles/rentas
 * @desc: Obtener rentas de bicicletas
 * @access Public
*/
router.get("/bicycles/rentas", todoController.getRentas);






module.exports = router;