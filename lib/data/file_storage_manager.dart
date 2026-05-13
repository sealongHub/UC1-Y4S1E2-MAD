
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorageManager {

  Future<void> initFileStorage() async {
    final appDocDir =  await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    final file = File('${path}/book.txt');
    if(await file.exists() == false){
      file.create(recursive: true);
    }
  }

  Future<void> saveFileStorage() async {
    final appDocDir =  await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    final file = File('${path}/book.txt');

    String b1 = "bookId=1,price=10000,qty=1"+"\n";
    String b2 = "bookId=2,price=8000,qty=1"+"\n";
    String b3 = "bookId=3,price=12000,qty=1"+"\n";

    file.writeAsString(b1, mode: FileMode.append);

  }

  Future<void> readFileStorage() async {
  try {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/book.txt');

    if (await file.exists()) {
      String content = await file.readAsString();
      print(content);
    } else {
      print("book.txt does not exist");
    }
  } catch (e) {
    print(e);
  }
}
}