import 'package:projektsheet_19/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  List<String> _items = [];

  // Hinzufügen und Speichern
  @override
  Future<void> addItem(String item) async {
    _items.add(item);
    await _saveItem(); // Speichert Liste in SharedPreferences
  }

  // Löschen und das gelöschte Speichern
  @override
  Future<void> deleteItem(int index) async {
    _items.removeAt(index);
    await _saveItem();
  }

  // Bearbeiten und das bearbeitete Speichern
  @override
  Future<void> editItem(int index, String newItem) async {
    getItems();
    _items[index] = newItem;
    await _saveItem();
  }

  // Zeigt alles was gespeichert wurde in einer Liste
  @override
  Future<List<String>> getItems() async {
    _items = await prefs.getStringList("Aufgaben") ?? [];
    return _items;
  }

  // Zeigt unter Statistik an wie viele Einträge gespeichert wurden.
  @override
  Future<int> get itemCount async {
    await getItems();
    return _items.length;
  }

  // Speichert die Funktion saveItem
  Future<void> _saveItem() async {
    await prefs.setStringList("Aufgaben", _items);
  }
}
