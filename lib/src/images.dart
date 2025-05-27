part of 'widget.dart';

// nodoc
enum PackageImage {
  image_1,
  image_2,
  image_3,
  image_4,
}

const _$PackageImageTypeMap = {
  PackageImage.image_1: 'assets/images/emptyImage.png',
  PackageImage.image_2: 'assets/images/im_emptyIcon_1.png',
  PackageImage.image_3: 'assets/images/im_emptyIcon_2.png',
  PackageImage.image_4: 'assets/images/im_emptyIcon_3.png',
};

extension ConvertExt on PackageImage? {
  String? encode() => _$PackageImageTypeMap[this!];

  PackageImage? key(String value) => decodePackageImage(value);

  PackageImage? decodePackageImage(String value) {
    return _$PackageImageTypeMap.entries.singleWhere((element) => element.value == value).key;
  }
}
