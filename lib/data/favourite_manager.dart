import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/data/product.dart';

final favouriteManeger = FavouriteManeger();

class FavouriteManeger {
  static const _boxName = 'favourite';
  final _box = Hive.box<ProductEntity>(_boxName);

  ValueListenable<Box<ProductEntity>> get listanable =>
      Hive.box<ProductEntity>(_boxName).listenable();
  static init() async {
    //var path = Directory.current.path;
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void addFavourite(ProductEntity productEntity) {
    _box.put(productEntity.id, productEntity);
  }

  void delete(ProductEntity productEntity) {
    _box.delete(productEntity.id);
  }

  List<ProductEntity> get favourites => _box.values.toList();

  bool isFavourite(ProductEntity productEntity) {
    return _box.containsKey(productEntity.id);
  }
}
