class Recipe {
  int no = 0;
  String name;
  String image = "assets/recipes/tarif1.jpg";
  int serves = 2;
  List<String> ingredients = ["Erişte, 500 gr."];
  Recipe({name}) {
    this.name = name ?? "Tarif";
  }
}
