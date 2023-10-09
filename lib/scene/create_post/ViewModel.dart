part of 'CreatePostView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);
  final BuildContext context;
  final _service = HouseService.shared;
  final _storageService = StorageService.shared;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  post({required String displayName,
    String? description,
    int? projectId,
    String? projectName,
    String? projectStatus,
    String? contactInfo,
    XFile? projectThumbNailFile,
    String? projectDescription,
    String? province,
    String? district,
    String? wards,
    String? street,
    String? addressDescription,
    XFile? thumbNailFile,
    int? numKitchen,
    int? numBathroom,
    int? numToilet,
    int? numLivingRoom,
    int? numBedRoom,
    List<XFile>? imagesFile,
    double? rentPrice,
    double? sellPrice}) async {
    isLoading = true;
    App.presentController.dismissible = false;

    String? thumbNailUrl;
    List<String>? images;
    String? projectThumbNailUrl;
    if(thumbNailFile != null) {
      thumbNailUrl = await _storageService.upload(thumbNailFile);
    }
    if(imagesFile != null && imagesFile.isNotEmpty) {
      images = await _storageService.uploadMultiple(imagesFile);
    }
    if(projectThumbNailFile != null) {
      projectThumbNailUrl = await _storageService.upload(projectThumbNailFile);
    }
    await _service.createHouse(
        displayName: displayName,
      projectId: projectId,
      projectName: projectName,
      projectStatus: projectStatus,
      contactInfo: contactInfo,
      projectThumbNailUrl: projectThumbNailUrl,
      projectDescription: projectDescription,
      province: province,
      district: district,
      wards: wards,
      street: street,
      addressDescription: addressDescription,
      thumbNailUrl: thumbNailUrl,
      numKitchen: numKitchen,
      numBathroom: numBathroom,
      numBedRoom: numBedRoom,
      numLivingRoom: numLivingRoom,
      numToilet: numToilet,
      images: images,
      sellPrice: sellPrice,
      rentPrice: rentPrice
    ).then((value){
      if(value?.house != null) {
        context.showCustomSnackBar('Thành công!');
        dismiss(clear: true);
      } else {
        context.showCustomSnackBar('Thất bại!');
      }
    }).onError((error, stackTrace) => context.showSnackBar(SnackBarType.error))
        .whenComplete(() {
      isLoading = false;
      App.presentController.dismissible = true;
    });
  }
}

