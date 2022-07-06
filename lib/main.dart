// Coloquei tudo na main para ser mais fácil enviar

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const Home(),
        '/detalhes': (context) => const Detalhes(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false, // Coloquei para tirar o Banner Debug
    );
  }
}

//------------------------------------------------------------------------------
// Primeira Tela

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Pokemons> listaPokemons = [];
  bool loading = true;

  @override
  void initState() {
    _getPokemons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 200),
              child: const Text('Pokedex'),
            ),
            Image.network(
              'https://raw.githubusercontent.com/RafaelBarbosatec/SimplePokedex/master/assets/pokebola_img.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: listaPokemons.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                      title: Text(listaPokemons[index].name ?? ''),
                      onTap: () {
                        Navigator.of(context).pushNamed('/detalhes',
                            arguments: listaPokemons[index]);
                      },
                      leading: Image.network(
                          listaPokemons[index].thumbnailImage ?? ''),
                      trailing: Text('#${listaPokemons[index].number ?? ''}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 190, 190))),
                    ),
                  ),
                );
              }),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _getPokemons() {
    Uri url = Uri.parse('http://104.131.18.84/pokemon/?limit=50&page=0');

    setState(() {
      loading = true;
    });

    http.get(url).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          Map json = const JsonDecoder().convert(value.body);

          for (var element in (json['data'] as List)) {
            listaPokemons.add(Pokemons.fromJson(element));
          }
          loading = false;
        });
      }
    });
  }
}

//------------------------------------------------------------------------------
// Segunda tela

class Detalhes extends StatelessWidget {
  const Detalhes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pokemons dados = ModalRoute.of(context)!.settings.arguments as Pokemons;
    return Scaffold(
      appBar: AppBar(
        title: Text('${dados.name}'),
      ),
      body: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 125),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromARGB(150, 236, 236, 236)),
                        width: double.infinity,
                        child: Image.network(dados.thumbnailImage ?? '')),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Text('#${dados.number}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${dados.description}',
                textAlign: TextAlign.left,
              ),
              const Divider(
                height: 30,
                thickness: 0.5,
              ),
              const Text(
                'Tipo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(dados.type!.join('   ')),
              const Divider(
                height: 30,
                thickness: 0.5,
              ),
              const Text('Fraquezas:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 2,
              ),
              Text(dados.weakness!.join('   ')),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Classe Pokemon

class Pokemons {
  List<String>? abilities;
  String? detailPageUrl;
  int? weight;
  List<String>? weakness;
  String? number;
  int? height;
  String? collectiblesSlug;
  String? featured;
  String? slug;
  String? description;
  String? name;
  String? thumbnailAltText;
  String? thumbnailImage;
  int? id;
  List<String>? type;

  Pokemons(
      {this.abilities,
      this.detailPageUrl,
      this.weight,
      this.weakness,
      this.number,
      this.height,
      this.collectiblesSlug,
      this.featured,
      this.slug,
      this.description,
      this.name,
      this.thumbnailAltText,
      this.thumbnailImage,
      this.id,
      this.type});

  Pokemons.fromJson(Map<String, dynamic> json) {
    this.abilities =
        json["abilities"] == null ? null : List<String>.from(json["abilities"]);
    this.detailPageUrl = json["detailPageURL"];
    this.weight = json["weight"];
    this.weakness =
        json["weakness"] == null ? null : List<String>.from(json["weakness"]);
    this.number = json["number"];
    this.height = json["height"];
    this.collectiblesSlug = json["collectibles_slug"];
    this.featured = json["featured"];
    this.slug = json["slug"];
    this.description = json["description"];
    this.name = json["name"];
    this.thumbnailAltText = json["thumbnailAltText"];
    this.thumbnailImage = json["thumbnailImage"];
    this.id = json["id"];
    this.type = json["type"] == null ? null : List<String>.from(json["type"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abilities != null) data["abilities"] = this.abilities;
    data["detailPageURL"] = this.detailPageUrl;
    data["weight"] = this.weight;
    if (this.weakness != null) data["weakness"] = this.weakness;
    data["number"] = this.number;
    data["height"] = this.height;
    data["collectibles_slug"] = this.collectiblesSlug;
    data["featured"] = this.featured;
    data["slug"] = this.slug;
    data["description"] = this.description;
    data["name"] = this.name;
    data["thumbnailAltText"] = this.thumbnailAltText;
    data["thumbnailImage"] = this.thumbnailImage;
    data["id"] = this.id;
    if (this.type != null) data["type"] = this.type;
    return data;
  }
}
