import 'package:dept_book/model.dart';
import 'package:dept_book/storage_mananger.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  var linkImage = "".obs;

  var people = <Person>[].obs;
  final StorageManager storageManager = StorageManager();
  static const String _peopleKey = "people_data";

  @override
  void onInit() {
    super.onInit();
    loadPeopleData();
  }

  updateLink(String link) {
    linkImage.value = link;
    storageManager.saveData("linkImage", link);
  }

  Future<void> savePeopleData() async {
    await storageManager.saveObjectList(
        _peopleKey, people.map((p) => p.toJson()).toList());
  }

  Future<void> loadPeopleData() async {
    List<Person>? storedPeople = storageManager.getObjectList(
        _peopleKey, (json) => Person.fromJson(json));
    if (storedPeople != null) {
      people.addAll(storedPeople);
    }
    linkImage.value = storageManager.getData("linkImage") ?? '';
  }

  void addPerson(Person person) {
    people.add(person);
    savePeopleData();
  }

  void editPerson(String id, String newName) {
    var person = people.firstWhere((p) => p.id == id);
    person.name = newName;
    savePeopleData();
    people.refresh();
  }

  void deletePerson(String id) {
    people.removeWhere((p) => p.id == id);
    savePeopleData();
  }

  void deleteExpensePerson(String id) {
    for (var element in people.value) {
      if (element.id == id) {
        element.balance = 0;
        element.expenses.clear();
        break;
      }
    }

    people.refresh();
    savePeopleData();
  }

  // Thêm chi tiêu cho một người
  void addExpenseToPerson(String personId, Expense expense) {
    expense.dateCreated = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var person = people.firstWhere((p) => p.id == personId);
    person.expenses.add(expense);
    person.balance += expense.amount; // Cập nhật số dư của người đó
    savePeopleData(); // Lưu lại dữ liệu
    people.refresh();
  }

  void editExpense(String personId, Expense updatedExpense) {
    updatedExpense.dateCreated =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    var person = people.firstWhere((p) => p.id == personId);
    var index = person.expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      person.expenses[index] = updatedExpense;
      savePeopleData();
    }
    people.refresh();
  }

  void deleteExpense(String personId, String expenseId) {
    var person = people.firstWhere((p) => p.id == personId);
    var expense = person.expenses.firstWhere((e) => e.id == expenseId);
    person.balance -= expense.amount;
    person.expenses.remove(expense);
    savePeopleData();
    people.refresh();
  }

  void resetExpenses() {
    for (var person in people) {
      person.expenses.clear();
      person.balance = 0.0;
    }
    savePeopleData();
    people.refresh();
  }
}
