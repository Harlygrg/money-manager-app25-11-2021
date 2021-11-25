import 'package:hive/hive.dart';
part 'data_model.g.dart';
// flutter packages pub run build_runner build
@HiveType(typeId: 1)
class IncomeExpenseModel{
@HiveField(2)
late bool isIncome;
@HiveField(3)
late String category;
@HiveField(4)
double?amount;
@HiveField(5)
late DateTime createdDate;
@HiveField(6)
String ?extraNotes;
IncomeExpenseModel({
  required this.isIncome,
  required this.category,
  this.amount,
  required this.createdDate,
  this.extraNotes
});
}

@HiveType(typeId:7)
class CategoryModel{
  @HiveField(8)
  String ?category;
  @HiveField(9)
  late bool isIncome;
  CategoryModel({this.category,required this.isIncome});
}