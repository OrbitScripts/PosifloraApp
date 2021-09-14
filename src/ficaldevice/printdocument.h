#ifndef PRINTDOCUMENT_H
#define PRINTDOCUMENT_H

#include <QList>
#include <QVariantMap>

class PrintDocument {

public:

  enum Command {
    CommandUnknown = 0,
    CommandString,
    CommandLine,
    CommandField,
    CommandCut
  };

  enum Align {
    AlignLeft,
    AlignRight,
    AlignCenter
  };

  enum WordWrap {
    WrapBreakWord = 1,
    WrapBreakChar,
    WrapCrop
  };

private:

  QList<QVariantMap> m_list;
  int m_nextCommand;

public:

  PrintDocument();
  PrintDocument(const PrintDocument &doc);
  ~PrintDocument();

  void clear(void);
  void resetNext(void);
  void addCommand(int type, const QVariantMap &data);
  int size(void) const { return m_list.size(); }
  int nextCommand(void);
  bool isLast(int index);

  int commandType(int index) const;
  QVariantMap commandData(int index) const;

};

Q_DECLARE_METATYPE(PrintDocument)

#endif // PRINTDOCUMENT_H
