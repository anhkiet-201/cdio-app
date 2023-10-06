part of 'SearchResult.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);

  final BuildContext context;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final _service = QueryService.shared;
  int _currentPage = 0;

  var isOptionsLoaded = false;
  List<HouseResponse> house = [];
  var options = <FilterOption>[];
  var hasNext = false;
  var key = '';
  var isLoaded = false;
  FilterOption? _province;
  FilterOption? _district;
  FilterOption? _wards;
  FilterOption? _street;

  Future<void> _loadOptions() async {
    await _service
        .getAllAddress()
        .then(_convertAddressToOptions)
        .catchError(() {
      context.showSnackBar(SnackBarType.error);
    }).whenComplete(() => isOptionsLoaded = true);
  }

  _convertAddressToOptions(List<Address> addresses) {
    final province = FilterOption(label: 'Tỉnh/Thành phố', options: ['Tất cả']);
    final district = FilterOption(label: 'Quận/Huyện', options: ['Tất cả']);
    final wards = FilterOption(label: 'Phường/Xã', options: ['Tất cả']);
    final street = FilterOption(label: 'Đường', options: ['Tất cả']);
    for (var element in addresses) {
      if (element.province != null) {
        if (!province.options.contains(element.province!) &&
            (element.province!).isNotEmpty) {
          province.options.add(element.province!);
        }
      }
      if (element.district != null) {
        if (!district.options.contains(element.district!) &&
            (element.district!).isNotEmpty) {
          district.options.add(element.district!);
        }
      }
      if (element.wards != null) {
        if (!wards.options.contains(element.wards!) &&
            (element.wards!).isNotEmpty) {
          wards.options.add(element.wards!);
        }
      }
      if (element.street != null) {
        if (!street.options.contains(element.street!) &&
            (element.street!).isNotEmpty) {
          street.options.add(element.street!);
        }
      }
    }
    options.add(province);
    options.add(district);
    options.add(wards);
    options.add(street);
  }

  Future<void> search({
    bool sortByDesc = true,
    int size = 10,
    bool clear = true
  }) async {
    isLoading = true;
    await _service
        .search(
            key: key,
            province: _province?.selected,
            district: _district?.selected,
            wards: _wards?.selected,
            street: _street?.selected,
            sortByDesc: sortByDesc,
            size: size,
            index: _currentPage)
        .then((value) {
      if(clear) {
        house.clear();
      }
      house.addAll(value.items ?? []);
      hasNext = value.hasNextPage ?? false;
      isLoaded = true;
    }).catchError(() {
      context.showSnackBar(SnackBarType.error);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  searchWithOptions({String? key}) async {
    if(key != null) {
      this.key = key;
    }
    isLoaded = false;
    _currentPage = 0;
    if (!isOptionsLoaded) {
      isLoading = true;
      await _loadOptions();
    }
    if (options.isNotEmpty) {
      _province = options[0];
      _district = options[1];
      _wards = options[2];
      _street = options[3];
    }
    await search();
  }

  Future<void> loadMore() async {
    _currentPage += 1;
    await search(clear: false);
  }
}
