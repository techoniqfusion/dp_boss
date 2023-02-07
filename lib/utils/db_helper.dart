import 'package:sqflite/sqflite.dart';
import '../API Response Model/Registration Model/registration_model.dart';
import 'package:path/path.dart';

class SQLService {
  Database? db;

  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'dpBoss.db');
      // open the database
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          // print(db);
          this.db = db;
          createTables();
        },
      );
      return true;
    } catch (e) {
      // print("ERROR IN OPEN DATABASE $e");
      return Future.error(e);
    }
  }

  createTables() async {
    try {
      var usersqry = "CREATE TABLE IF NOT EXISTS users ( "
          "email Text,"
          "name Text,"
          "mobile Text,"
          "address Text,"
          "gender Text,"
          "dob Text,"
          "state Text,"
          "city Text,"
          "my_refer Text,"
          "created_at Text,"
          "wallet Text)";
      await db?.execute(usersqry);
    } catch (e) {
      print("ERROR IN CREATE TABLE");
      print(e);
    }
  }

  Future getUser() async {
    try {
      var list = await db?.rawQuery('SELECT * FROM users', []);
      print("list data is $list");
      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future addToUser(UserData data) async {
    // print("add user data is ${data.userName}  and ${data.userEmail}, ${data.userMobile},${data.userImage},${data.userDob}, ${data.userGender},${data.userState},${data.userCity},${data.loginId}");
    await db?.transaction((txn) async {
      var qry =
          'INSERT INTO users(email, name, mobile, address, gender, dob, state, city, my_refer, wallet, created_at) VALUES("${data.email}", "${data.name}", "${data.mobile}", "${data.address}", "${data.gender}", "${data.dob}", "${data.state}", "${data.city}", "${data.myRefer}", "${data.wallet}", "${data.createdAt}")';
      // print("insert query => ${qry}");
      int id1 = await txn.rawInsert(qry);
      return id1;
    });
    print("user added");
  }

  Future updateUserData(UserData data) async {
    // print("user data update query ${data.userName}");
    var qry =
        "UPDATE users SET name = '${data.name}', email = '${data.email}', address = '${data.address}', gender = '${data.gender}', city = '${data.city}', state = '${data.state}', dob = '${data.dob}' ";
    print("user data update query $qry");
    return await db?.rawUpdate(qry);
  }

  Future deleteUser() async {
    var qry = "DELETE FROM users";
    return await db?.rawDelete(qry);
  }

// Future closeUserDb() async{
//   return await db?.close();
// }
}
