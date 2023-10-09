import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final shared = StorageService();
  final _instants = FirebaseStorage.instanceFor(bucket: 'gs://vs-videosocial.appspot.com');

  Future<String> upload(XFile file) async {
    final bytes = await file.readAsBytes();
    final task = await _instants.ref('cdio').child('images').child(file.name)
        .putData(bytes);
    return task.ref.getDownloadURL();
  }

  Future<List<String>> uploadMultiple(List<XFile> files) async {
    final tasks = files.map((e) => upload(e));
    return Future.wait(tasks);
  }
}