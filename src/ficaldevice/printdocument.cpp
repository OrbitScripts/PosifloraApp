#include "printdocument.h"

PrintDocument::PrintDocument() :
  m_nextCommand(-1)
{
  //
}

PrintDocument::PrintDocument(const PrintDocument &doc) {
  m_nextCommand = doc.m_nextCommand;
  m_list = doc.m_list;
}

PrintDocument::~PrintDocument() {
  //
}

/**
 * @brief Очистка документа
 */
void PrintDocument::clear(void) {
  m_list.clear();
  m_nextCommand = -1;
}

/**
 * @brief Сброс счётчика команд
 */
void PrintDocument::resetNext() {
  m_nextCommand = -1;
}

/**
 * @brief Добавление команды в очередь
 * @param type Тип команды
 * @param data Данные для команды
 */
void PrintDocument::addCommand(int type, const QVariantMap &data) {
  QVariantMap cmdData;
  cmdData["type"] = type;
  cmdData["data"] = data;
  m_list.append(cmdData);
}

/**
 * @brief Получение индекса следующей команды
 * @return Индекс следующей команды. Если следующей команды нет, возвращается -1.
 */
int PrintDocument::nextCommand(void) {
  m_nextCommand++;
  if (m_nextCommand >= m_list.size()) m_nextCommand = -1;
  return m_nextCommand;
}

/**
 * @brief Получение флага последней команды по индексу команды
 * @return Флаг последней команды в документе
 */
bool PrintDocument::isLast(int index) {
  return ++index >= m_list.size();
}

/**
 * @brief Получение типа команды по индексу команды
 * @param index Индекс команды
 * @return Тип команды
 */
int PrintDocument::commandType(int index) const {
  if (index < 0 || index >= m_list.size()) return CommandUnknown;
  return m_list[index]["type"].toInt();
}

/**
 * @brief Получение данных команды по индексу команды
 * @param index Индекс команды
 * @return Данные команды
 */
QVariantMap PrintDocument::commandData(int index) const {
  if (index < 0 || index >= m_list.size()) return QVariantMap();
  return m_list[index]["data"].toMap();
}
