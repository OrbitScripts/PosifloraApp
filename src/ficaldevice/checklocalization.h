#ifndef CHECKLOCALIZATION_H
#define CHECKLOCALIZATION_H

#include <QString>

class CheckLocalization {
public:
  CheckLocalization() = delete;

  enum Lang {
    Ru = 0,
    En
  };

  enum StrSemantic {
    CashCheck,
    Receipt,
    ReturnReceipt,
    Cashier,
    Subtotal,
    Discount,
    Total,
    Cash,
    Electronically,
    Prepayment,
    Credit,
    Change,
    TotalLessDiscount,
    TotalIncludingDiscount,
    BonusPoints,
    BonusPointsLeft,
    OrderNumber,
    BonusPointsCount,

    XReport,
    ZReport,
    OpeningBalance,
    Withdrawn,
    Deposit,
    CashProceeds,
    Expected,
    Prepayments,
    Returns,

    FloristCheck,
    DateOfExecution,
    Budget,
    Comment,
    Composition,
    Assortment,
    PrepaymentSum,
    ToPay,
    DateTimeOfPrint,

    DeliveryCheck,
    DeliveryDate,
    Address,
    City_Short,
    Street_Short,
    House_Short,
    Building_Short,
    Apartment_Short,
    Recipient,
    Name,
    Phone,
    Customer,

    BouquetCheck,
    Bouquet,
    Parts_Short,
    Cost,

    Florist,
    Courier
  };

  static QString translate(Lang lang, StrSemantic semantic);
  static Lang getLanguage(const QString& checkLanguage);
};

typedef CheckLocalization cTr;

#endif // CHECKLOCALIZATION_H
