import 'dart:convert';

void main() {

  String jsonString = '''
  {
    "animals": [
      { "animal": "dog,cat,dog,cow" },
      { "animal": "cow,cat,cat" },
      { "animal": null },
      { "animal": "" }
    ]
  }
  ''';


  Map<String, dynamic> jsonData = json.decode(jsonString);


  List<dynamic> animalsList = jsonData["animals"];
  for (var item in animalsList) {
    String? animalString = item["animal"];


    if (animalString == null || animalString.isEmpty) continue;


    Map<String, int> animalCount = {};
    for (var animal in animalString.split(',')) {
      animalCount[animal] = (animalCount[animal] ?? 0) + 1;
    }


    List<String> formattedOutput = [];
    animalCount.forEach((animal, count) {
      if (count > 1) {
        formattedOutput.add('$animal($count)');
      } else {
        formattedOutput.add(animal);
      }
    });


    print(formattedOutput.join(', '));
  }
}
