
class BillInfo {
  final String name;
  final double amount;

  BillInfo({
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "amount": amount,
    };
  }
}

class Bill {
  final String title;
  final double total;
  final String splitType;
  final List<BillInfo> info;

  Bill({
    required this.title,
    required this.total,
    required this.splitType,
    required this.info,
  });

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "total": total,
      "splitType": splitType,
      "info": info.map((m) => m.toJson()).toList(),
    };
  }
}