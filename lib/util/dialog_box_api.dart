import 'package:flutter/material.dart';

class DialogBoxApi extends StatelessWidget {
  const DialogBoxApi({super.key});

  static const List<String> cities = ['Adilabad', 'Agar Malwa', 'Agra', 'Ahmadnagar', 'Ahmedabad', 'Aizawl', 'Ajmer', 'Akola', 'Alappuzha', 'Aligarh', 'Alipurduar'];

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if(textEditingValue.text==""){
            return const Iterable<String>.empty();
          }
          return cities.where((String item) {
            return item.contains(textEditingValue.text.toLowerCase());
          },);
        },
      onSelected: (String item){
          print("${item}");
      },
    );
  }
}
