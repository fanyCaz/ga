import 'package:flutter/cupertino.dart';
import 'package:gallery_array/classes/photo.dart';

enum GalleryState{
  normal,
}

class GalleryStoreBlock with ChangeNotifier{

  //Estados
  //Normal
  GalleryState galleryState = GalleryState.normal;
  List<Photo> catalog = List.unmodifiable(groceryProducts);
  List<GroceryProductItem> cart = []; //recomendable para inicializar listas

}

class GroceryProductItem {

}