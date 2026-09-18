/// Contrato genérico de um repositório CRUD.
///
/// Estende-o apenas quando a feature precisa das quatro operações; caso
/// contrário define um contrato próprio no domínio da feature.
abstract class BaseRepository<T> {
  Future<void> addItem(T item);
  Future<void> deleteItem(T item);
  Future<void> updateItem(T item);
  Future<List<T>> getAllItems();
}
