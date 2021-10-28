import 'dart:convert';

import 'package:mobileapp/domain/model/Binding.dart';
import 'package:mobileapp/enum/selectedType.dart';
import 'package:dio/dio.dart';

class BindingManager {
  Future<List<Binding>> getBindings(SelectedType selectedType) async {
    var dio = Dio();
    String query = '''
        SELECT ?itemLabel ?geo WHERE {
    ?item (wdt:P31/(wdt:P279*)) wd:''' +
        selectedType.typeId +
        ''';
    wdt:P625 ?geo;
    wdt:P17 wd:Q45.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "pt,en". }
    }
    ''';

    Response response = await dio.get(
        'https://query.wikidata.org/bigdata/namespace/wdq/sparql?format=json&query=' +
            Uri.encodeComponent(query));

    return jsonDecode(response.data)['results']['bindings']
        .map<Binding>((e) => Binding.fromJson(e))
        .toList();
  }
}
