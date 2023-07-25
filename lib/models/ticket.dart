class Ticket {
  String? header;
  String? footer;
  String? telephone;

  Ticket({
    this.header,
    this.footer,
    this.telephone,
  });

  Ticket.fromJson(Map<String, dynamic> json)
      : header = json['header'],
        footer = json['footer'],
        telephone = json['telephone'];

  Map<String, dynamic> toJson() => {
        'header': header,
        'footer': footer,
        'telephone': telephone,
      };
}
