import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final shared = StorageService();
  final _instants = FirebaseStorage.instanceFor(bucket: 'gs://vs-videosocial.appspot.com');

}