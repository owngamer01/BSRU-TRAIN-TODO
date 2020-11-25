import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/interface/database_interface.dart';
import 'package:todo/models/response_model.dart';
import 'package:todo/models/user_model.dart';

final String userTable     = 'user_table';

final String colId         = 'id';
final String colUsername   = 'username';
final String colNickname   = 'nickname';
final String colEmail      = 'email';
final String colPassword   = 'password';
final String colFirstTime  = 'first_time';

class UserDatabase extends DatabaseInterface {

  final _dbname  = 'user.db';
  final _version = 1;

  Database _db;

  @override
  Future<Database> onOpen() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbname);

    _db = await openDatabase(path, version: _version, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $userTable ( 
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colUsername TEXT NOT NULL,
          $colNickname TEXT NOT NULL,
          $colEmail TEXT NOT NULL,
          $colPassword TEXT NOT NULL,
          $colFirstTime INTEGER NOT NULL
        )
      ''');
    });

    return _db;
  }

  @override
  Future onClose() async => _db?.close();

  get _databaseBroke => UserResponse(
    isError: true,
    title: 'DB Broke',
    context: 'Unavaliable try again later.'
  );
  
  get _databaseCatch => UserResponse(
    isError: true,
    title: 'DB Catch',
    context: 'Unavaliable try again later.'
  );

  Future<UserResponse> insertUser(UserData data) async {
    try {
      if(await this.onOpen() == null) return _databaseBroke;
      if (await checkUserDuplicate(data, [colUsername, colEmail])) {
        return UserResponse(
          isError: true,
          title: 'Duplicate user',
          context: 'Sry can\'t add duplicate user'
        );
      }
      
      data.id = await _db.insert(userTable, data.toMap());
      return UserResponse(
        userData: data,
        title: 'User Added',
        context: 'Thank for register.'
      );
    } catch (e) {
      return _databaseCatch;
    } finally {
      this.onClose();
    }
  }

  
  Future<UserResponse> updateUser(UserData users) async {
    try {
      if(await this.onOpen() == null) return _databaseBroke;
      await _db.update(userTable, users.toMap(), 
        where: '$colId = ?', 
        whereArgs: [users.id]
      );
      return UserResponse(userData: users);
    } catch (e) {
      return _databaseCatch;
    } finally {
      this.onClose();
    }
  }

  Future<UserResponse> verifyUser() async {
    try {
      if(await this.onOpen() == null) return _databaseBroke;
      var users = await _db.query(userTable);
      if (users.length > 0) {
        return UserResponse(
          userData: UserData.fromMap(users.first),
        );
      }
      return UserResponse(isError: true);
    } catch (e) {
      return _databaseCatch;
    } finally {
      this.onClose();
    }
  }

  Future<UserResponse> getUserById(UserData userData) async {
    try {
      if(await this.onOpen() == null) return _databaseBroke;
      var users = await _db.query(userTable);

      var findUser = users.firstWhere((user) => 
        user[colUsername] == userData.username && user[colPassword] == userData.password,
      orElse: () => null);

      if (findUser == null) {
        return UserResponse(
          isError: true,
          title: 'ไม่พบ User ในระบบ',
          context: 'กรุณากรอกให้ถูกต้อง หรือ สมัครเลยตอนนี้'
        );
      }

      return UserResponse(
        userData: UserData.fromMap(findUser)
      );
    } catch (e) {
      return _databaseCatch;
    } finally {
      this.onClose();
    }
  }

  Future<bool> checkUserDuplicate(UserData oldUser, [List<String> columns]) async {
    var cols  = columns ?? [colId];
    var users = await _db.query(userTable, columns: cols);
    if (users.isEmpty) return false;

    var isEqauls = false;
    return users.indexWhere((user) {
      for (var col in cols) {
        if (user[col] == oldUser.toMap()[col]) {
          isEqauls = true;
          break;
        }
      }
      return isEqauls;
    }) != -1;
  }

}