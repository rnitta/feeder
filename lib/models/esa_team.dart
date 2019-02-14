class EsaTeam {
  final String url;
  final String name;
  final String iconUrl;
  final String description;

  EsaTeam.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        name = json['name'],
        iconUrl = json['icon'],
        description = json['description'];
}
