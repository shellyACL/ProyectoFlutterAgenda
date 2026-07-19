import 'package:agenda_part1/infrastructure/models/estado_model.dart';
import 'package:agenda_part1/infrastructure/models/horario_model.dart';
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:agenda_part1/infrastructure/models/periodo_model.dart';
import 'package:agenda_part1/infrastructure/models/programa_model.dart';
import 'package:agenda_part1/infrastructure/models/responsable_model.dart';
import 'package:agenda_part1/infrastructure/models/tarea_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoact_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoprog_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agenda.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE institucion (
        idIns TEXT PRIMARY KEY,
        nombreIns TEXT NOT NULL,
        tipoIns TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE responsable (
        idResponsable TEXT PRIMARY KEY,
        nombreResponsable TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE periodo (
        idPeriodo TEXT PRIMARY KEY,
        nombrePeriodo TEXT NOT NULL,
        diasDurPeriodo INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE estado (
        idEstado TEXT PRIMARY KEY,
        nombreEstado TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tipoProg (
        idTipoProg TEXT PRIMARY KEY,
        nombreTipoProg TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tipoAct (
        idTipoAct TEXT PRIMARY KEY,
        nombreTipoAct TEXT NOT NULL,
        reqNotaRapidaTipoAct INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE materia (
        idMateria TEXT PRIMARY KEY,
        nombreMateria TEXT NOT NULL,
        fechaIni TEXT,
        fechaFin TEXT,
        notaMinima INTEGER NOT NULL,
        notaAct INTEGER NOT NULL,
        idResponsable TEXT,
        idIns TEXT,
        idPeriodo TEXT,
        idEstado TEXT,
        FOREIGN KEY (idResponsable) REFERENCES responsable(idResponsable),
        FOREIGN KEY (idIns) REFERENCES institucion(idIns),
        FOREIGN KEY (idPeriodo) REFERENCES periodo(idPeriodo),
        FOREIGN KEY (idEstado) REFERENCES estado(idEstado)
      )
    ''');

    await db.execute('''
      CREATE TABLE programa (
        idProg TEXT PRIMARY KEY,
        nombreProg TEXT NOT NULL,
        idIns TEXT,
        idTipoProg TEXT,
        FOREIGN KEY (idIns) REFERENCES institucion(idIns),
        FOREIGN KEY (idTipoProg) REFERENCES tipoProg(idTipoProg)
      )
    ''');

    await db.execute('''
      CREATE TABLE horario (
        idHorario TEXT PRIMARY KEY,
        diaHorario TEXT NOT NULL,
        iniHorario TEXT NOT NULL,
        finHorario TEXT NOT NULL,
        idMateria TEXT,
        FOREIGN KEY (idMateria) REFERENCES materia(idMateria) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tarea (
        idTarea TEXT PRIMARY KEY,
        nombreTarea TEXT NOT NULL,
        descTarea TEXT,
        fechaCreaTarea TEXT NOT NULL,
        fechaEntTarea TEXT,
        estadoTarea TEXT NOT NULL,
        notaObtenida INTEGER,
        ponderacion INTEGER,
        idMateria TEXT,
        idTipoAct TEXT,
        FOREIGN KEY (idMateria) REFERENCES materia(idMateria) ON DELETE CASCADE,
        FOREIGN KEY (idTipoAct) REFERENCES tipoAct(idTipoAct)
      )
    ''');
  }

  // ==================== INSTITUCION ====================
  Future<int> insertInstitucion(Institucion institucion) async {
    Database db = await database;
    return await db.insert('institucion', institucion.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Institucion>> getAllInstitucion() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('institucion');
    return List.generate(maps.length, (i) => Institucion.fromMap(maps[i]));
  }

  Future<Institucion?> getInstitucionById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'institucion',
      where: 'idIns = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Institucion.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateInstitucion(Institucion institucion) async {
    Database db = await database;
    return await db.update(
      'institucion',
      institucion.toMap(),
      where: 'idIns = ?',
      whereArgs: [institucion.idIns],
    );
  }

  Future<int> deleteInstitucion(String id) async {
    Database db = await database;
    return await db.delete(
      'institucion',
      where: 'idIns = ?',
      whereArgs: [id],
    );
  }

  // ==================== RESPONSABLE ====================
  Future<int> insertResponsable(Responsable responsable) async {
    Database db = await database;
    return await db.insert('responsable', responsable.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Responsable>> getAllResponsable() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('responsable');
    return List.generate(maps.length, (i) => Responsable.fromMap(maps[i]));
  }

  Future<Responsable?> getResponsableById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'responsable',
      where: 'idResponsable = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Responsable.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateResponsable(Responsable responsable) async {
    Database db = await database;
    return await db.update(
      'responsable',
      responsable.toMap(),
      where: 'idResponsable = ?',
      whereArgs: [responsable.idResponsable],
    );
  }

  Future<int> deleteResponsable(String id) async {
    Database db = await database;
    return await db.delete(
      'responsable',
      where: 'idResponsable = ?',
      whereArgs: [id],
    );
  }

  // ==================== PERIODO ====================
  Future<int> insertPeriodo(Periodo periodo) async {
    Database db = await database;
    return await db.insert('periodo', periodo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Periodo>> getAllPeriodo() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('periodo');
    return List.generate(maps.length, (i) => Periodo.fromMap(maps[i]));
  }

  Future<Periodo?> getPeriodoById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'periodo',
      where: 'idPeriodo = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Periodo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePeriodo(Periodo periodo) async {
    Database db = await database;
    return await db.update(
      'periodo',
      periodo.toMap(),
      where: 'idPeriodo = ?',
      whereArgs: [periodo.idPeriodo],
    );
  }

  Future<int> deletePeriodo(String id) async {
    Database db = await database;
    return await db.delete(
      'periodo',
      where: 'idPeriodo = ?',
      whereArgs: [id],
    );
  }

  // ==================== ESTADO ====================
  Future<int> insertEstado(Estado estado) async {
    Database db = await database;
    return await db.insert('estado', estado.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Estado>> getAllEstado() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('estado');
    return List.generate(maps.length, (i) => Estado.fromMap(maps[i]));
  }

  Future<Estado?> getEstadoById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'estado',
      where: 'idEstado = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Estado.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateEstado(Estado estado) async {
    Database db = await database;
    return await db.update(
      'estado',
      estado.toMap(),
      where: 'idEstado = ?',
      whereArgs: [estado.idEstado],
    );
  }

  Future<int> deleteEstado(String id) async {
    Database db = await database;
    return await db.delete(
      'estado',
      where: 'idEstado = ?',
      whereArgs: [id],
    );
  }

  // ==================== TIPO PROG ====================
  Future<int> insertTipoProg(TipoProg tipoProg) async {
    Database db = await database;
    return await db.insert('tipoProg', tipoProg.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TipoProg>> getAllTipoProg() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tipoProg');
    return List.generate(maps.length, (i) => TipoProg.fromMap(maps[i]));
  }

  Future<TipoProg?> getTipoProgById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tipoProg',
      where: 'idTipoProg = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TipoProg.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTipoProg(TipoProg tipoProg) async {
    Database db = await database;
    return await db.update(
      'tipoProg',
      tipoProg.toMap(),
      where: 'idTipoProg = ?',
      whereArgs: [tipoProg.idTipoProg],
    );
  }

  Future<int> deleteTipoProg(String id) async {
    Database db = await database;
    return await db.delete(
      'tipoProg',
      where: 'idTipoProg = ?',
      whereArgs: [id],
    );
  }

  // ==================== TIPO ACT ====================
  Future<int> insertTipoAct(TipoAct tipoAct) async {
    Database db = await database;
    return await db.insert('tipoAct', tipoAct.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TipoAct>> getAllTipoAct() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tipoAct');
    return List.generate(maps.length, (i) => TipoAct.fromMap(maps[i]));
  }

  Future<TipoAct?> getTipoActById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tipoAct',
      where: 'idTipoAct = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TipoAct.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTipoAct(TipoAct tipoAct) async {
    Database db = await database;
    return await db.update(
      'tipoAct',
      tipoAct.toMap(),
      where: 'idTipoAct = ?',
      whereArgs: [tipoAct.idTipoAct],
    );
  }

  Future<int> deleteTipoAct(String id) async {
    Database db = await database;
    return await db.delete(
      'tipoAct',
      where: 'idTipoAct = ?',
      whereArgs: [id],
    );
  }

  // ==================== MATERIA ====================
  Future<int> insertMateria(Materia materia) async {
    Database db = await database;
    return await db.insert('materia', materia.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Materia>> getAllMateria() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        m.*,
        r.nombreResponsable,
        i.nombreIns, i.tipoIns,
        p.nombrePeriodo, p.diasDurPeriodo,
        e.nombreEstado
      FROM materia m
      LEFT JOIN responsable r ON m.idResponsable = r.idResponsable
      LEFT JOIN institucion i ON m.idIns = i.idIns
      LEFT JOIN periodo p ON m.idPeriodo = p.idPeriodo
      LEFT JOIN estado e ON m.idEstado = e.idEstado
    ''');
    return List.generate(maps.length, (i) => Materia.fromMap(maps[i]));
  }

  Future<Materia?> getMateriaById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        m.*,
        r.nombreResponsable,
        i.nombreIns, i.tipoIns,
        p.nombrePeriodo, p.diasDurPeriodo,
        e.nombreEstado
      FROM materia m
      LEFT JOIN responsable r ON m.idResponsable = r.idResponsable
      LEFT JOIN institucion i ON m.idIns = i.idIns
      LEFT JOIN periodo p ON m.idPeriodo = p.idPeriodo
      LEFT JOIN estado e ON m.idEstado = e.idEstado
      WHERE m.idMateria = ?
    ''', [id]);

    if (maps.isNotEmpty) {
      return Materia.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMateria(Materia materia) async {
    Database db = await database;
    return await db.update(
      'materia',
      materia.toMap(),
      where: 'idMateria = ?',
      whereArgs: [materia.idMateria],
    );
  }

  Future<int> deleteMateria(String id) async {
    Database db = await database;
    return await db.delete(
      'materia',
      where: 'idMateria = ?',
      whereArgs: [id],
    );
  }

  // ==================== PROGRAMA ====================
  Future<int> insertPrograma(Programa programa) async {
    Database db = await database;
    return await db.insert('programa', programa.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Programa>> getAllPrograma() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        p.*,
        i.nombreIns, i.tipoIns,
        tp.nombreTipoProg
      FROM programa p
      LEFT JOIN institucion i ON p.idIns = i.idIns
      LEFT JOIN tipoProg tp ON p.idTipoProg = tp.idTipoProg
    ''');
    return List.generate(maps.length, (i) => Programa.fromMap(maps[i]));
  }

  Future<Programa?> getProgramaById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        p.*,
        i.nombreIns, i.tipoIns,
        tp.nombreTipoProg
      FROM programa p
      LEFT JOIN institucion i ON p.idIns = i.idIns
      LEFT JOIN tipoProg tp ON p.idTipoProg = tp.idTipoProg
      WHERE p.idProg = ?
    ''', [id]);

    if (maps.isNotEmpty) {
      return Programa.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePrograma(Programa programa) async {
    Database db = await database;
    return await db.update(
      'programa',
      programa.toMap(),
      where: 'idProg = ?',
      whereArgs: [programa.idProg],
    );
  }

  Future<int> deletePrograma(String id) async {
    Database db = await database;
    return await db.delete(
      'programa',
      where: 'idProg = ?',
      whereArgs: [id],
    );
  }

  // ==================== HORARIO ====================
  Future<int> insertHorario(Horario horario) async {
    Database db = await database;
    return await db.insert('horario', horario.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Horario>> getAllHorario() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        h.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct
      FROM horario h
      LEFT JOIN materia m ON h.idMateria = m.idMateria
    ''');
    return List.generate(maps.length, (i) => Horario.fromMap(maps[i]));
  }

  Future<Horario?> getHorarioById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        h.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct
      FROM horario h
      LEFT JOIN materia m ON h.idMateria = m.idMateria
      WHERE h.idHorario = ?
    ''', [id]);

    if (maps.isNotEmpty) {
      return Horario.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Horario>> getHorarioByMateria(String idMateria) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        h.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct
      FROM horario h
      LEFT JOIN materia m ON h.idMateria = m.idMateria
      WHERE h.idMateria = ?
    ''', [idMateria]);

    return List.generate(maps.length, (i) => Horario.fromMap(maps[i]));
  }

  Future<int> updateHorario(Horario horario) async {
    Database db = await database;
    return await db.update(
      'horario',
      horario.toMap(),
      where: 'idHorario = ?',
      whereArgs: [horario.idHorario],
    );
  }

  Future<int> deleteHorario(String id) async {
    Database db = await database;
    return await db.delete(
      'horario',
      where: 'idHorario = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHorarioByMateria(String idMateria) async {
    Database db = await database;
    return await db.delete(
      'horario',
      where: 'idMateria = ?',
      whereArgs: [idMateria],
    );
  }
  // ==================== TAREA ====================
  Future<int> insertTarea(Tarea tarea) async {
    Database db = await database;
    return await db.insert('tarea', tarea.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tarea>> getAllTarea() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct,
        ta.nombreTipoAct, ta.reqNotaRapidaTipoAct
      FROM tarea t
      LEFT JOIN materia m ON t.idMateria = m.idMateria
      LEFT JOIN tipoAct ta ON t.idTipoAct = ta.idTipoAct
    ''');
    return List.generate(maps.length, (i) => Tarea.fromMap(maps[i]));
  }

  Future<Tarea?> getTareaById(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct,
        ta.nombreTipoAct, ta.reqNotaRapidaTipoAct
      FROM tarea t
      LEFT JOIN materia m ON t.idMateria = m.idMateria
      LEFT JOIN tipoAct ta ON t.idTipoAct = ta.idTipoAct
      WHERE t.idTarea = ?
    ''', [id]);

    if (maps.isNotEmpty) {
      return Tarea.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Tarea>> getTareaByMateria(String idMateria) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        m.nombreMateria, m.fechaIni, m.fechaFin, m.notaMinima, m.notaAct,
        ta.nombreTipoAct, ta.reqNotaRapidaTipoAct
      FROM tarea t
      LEFT JOIN materia m ON t.idMateria = m.idMateria
      LEFT JOIN tipoAct ta ON t.idTipoAct = ta.idTipoAct
      WHERE t.idMateria = ?
    ''', [idMateria]);

    return List.generate(maps.length, (i) => Tarea.fromMap(maps[i]));
  }

  Future<int> updateTarea(Tarea tarea) async {
    Database db = await database;
    return await db.update(
      'tarea',
      tarea.toMap(),
      where: 'idTarea = ?',
      whereArgs: [tarea.idTarea],
    );
  }

  Future<int> deleteTarea(String id) async {
    Database db = await database;
    return await db.delete(
      'tarea',
      where: 'idTarea = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTareaByMateria(String idMateria) async {
    try {

      final db = await database; 
      int resultado = await db.delete(
        'tarea', 
        where: 'idMateria = ?', 
        whereArgs: [idMateria],
      );
      return resultado;
    } catch (e) {
      throw Exception("Error al eliminar tareas por materia en la base de datos: $e");
    }
  }

  // ==================== MÉTODOS DE LIMPIEZA ====================
  Future<void> deleteAllTables() async {
    Database db = await database;
    await db.delete('tarea');
    await db.delete('horario');
    await db.delete('programa');
    await db.delete('materia');
    await db.delete('responsable');
    await db.delete('periodo');
    await db.delete('estado');
    await db.delete('tipoAct');
    await db.delete('tipoProg');
    await db.delete('institucion');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}