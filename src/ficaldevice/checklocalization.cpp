#include "checklocalization.h"

QString CheckLocalization::translate(Lang lang, StrSemantic semantic) {
  if (lang == Ru) {
    if (semantic == CashCheck) return "Кассовый чек";
    if (semantic == Receipt) return "Приход";
    if (semantic == ReturnReceipt) return "Возврат прихода";
    if (semantic == Cashier) return "Кассир";
    if (semantic == Subtotal) return "Общая стоимость";
    if (semantic == Discount) return "Скидка";
    if (semantic == Total) return "Итог";
    if (semantic == Cash) return "Наличными";
    if (semantic == Electronically) return "Безналичными";
    if (semantic == Prepayment) return "Аванс";
    if (semantic == Credit) return "Кредит";
    if (semantic == Change) return "Сдача";
    if (semantic == TotalLessDiscount) return "Итого без скидок";
    if (semantic == TotalIncludingDiscount) return "Cумма с учётом скидки";
    if (semantic == BonusPoints) return "Из них бонусов";
    if (semantic == BonusPointsLeft) return "Осталось бонусов";
    if (semantic == OrderNumber) return "Номер заказа";
    if (semantic == BonusPointsCount) return "Количество бонусов";

    if (semantic == XReport) return "X-Отчёт";
    if (semantic == ZReport) return "Z-Отчёт";
    if (semantic == OpeningBalance) return "Баланс при открытии";
    if (semantic == Withdrawn) return "Изъято";
    if (semantic == Deposit) return "Внесено";
    if (semantic == CashProceeds) return "Наличная выручка";
    if (semantic == Expected) return "Ожидается";
    if (semantic == Prepayments) return "Авансы";
    if (semantic == Returns) return "Возвраты";

    if (semantic == FloristCheck) return "Чек флориста";
    if (semantic == DateOfExecution) return "Дата исполнения";
    if (semantic == Budget) return "Бюджет";
    if (semantic == Comment) return "Комментарий";
    if (semantic == Composition) return "Состав";
    if (semantic == Assortment) return "Ассортимент";
    if (semantic == PrepaymentSum) return "Аванс на сумму";
    if (semantic == ToPay) return "К оплате";
    if (semantic == DateTimeOfPrint) return "Дата и время печати";

    if (semantic == DeliveryCheck) return "Чек доставки";
    if (semantic == DeliveryDate) return "Дата доставки";
    if (semantic == Address) return "Адрес";
    if (semantic == City_Short) return "г.";
    if (semantic == Street_Short) return "ул.";
    if (semantic == House_Short) return "д.";
    if (semantic == Building_Short) return "корп.";
    if (semantic == Apartment_Short) return "кв.";
    if (semantic == Recipient) return "Получатель";
    if (semantic == Name) return "Имя";
    if (semantic == Phone) return "Телефон";
    if (semantic == Customer) return "Заказчик";

    if (semantic == BouquetCheck) return "Чек букета";
    if (semantic == Bouquet) return "Букет";
    if (semantic == Parts_Short) return "шт.";
    if (semantic == Cost) return "Стоимость";

    if (semantic == Florist) return "Флорист";
    if (semantic == Courier) return "Курьер";

  } else if (lang == En) {
    if (semantic == CashCheck) return "Cash Check";
    if (semantic == Receipt) return "Receipt";
    if (semantic == ReturnReceipt) return "Return Receipt";
    if (semantic == Cashier) return "Cashier";
    if (semantic == Subtotal) return "Subtotal";
    if (semantic == Discount) return "Discount";
    if (semantic == Total) return "Total";
    if (semantic == Cash) return "Cash";
    if (semantic == Electronically) return "Electronically";
    if (semantic == Prepayment) return "Prepayment";
    if (semantic == Credit) return "Credit";
    if (semantic == Change) return "Change";
    if (semantic == TotalLessDiscount) return "Total Less Discount";
    if (semantic == TotalIncludingDiscount) return "Total Including Discount";
    if (semantic == BonusPoints) return "Bonus Points";
    if (semantic == BonusPointsLeft) return "Bonus Points Left";
    if (semantic == OrderNumber) return "Order Number";
    if (semantic == BonusPointsCount) return "Bonus Points Count";

    if (semantic == XReport) return "X-Report";
    if (semantic == ZReport) return "Z-Report";
    if (semantic == OpeningBalance) return "Opening Balance";
    if (semantic == Withdrawn) return "Withdrawn";
    if (semantic == Deposit) return "Deposit";
    if (semantic == CashProceeds) return "Cash Proceeds";
    if (semantic == Expected) return "Expected";
    if (semantic == Prepayments) return "Prepayments";
    if (semantic == Returns) return "Returns";

    if (semantic == FloristCheck) return "Florist Check";
    if (semantic == DateOfExecution) return "Date Of Execution";
    if (semantic == Budget) return "Budget";
    if (semantic == Comment) return "Comment";
    if (semantic == Composition) return "Composition";
    if (semantic == Assortment) return "Assortment";
    if (semantic == PrepaymentSum) return "Prepayment Sum";
    if (semantic == ToPay) return "To Pay";
    if (semantic == DateTimeOfPrint) return "Date and Time of Print";

    if (semantic == DeliveryCheck) return "Delivery Check";
    if (semantic == DeliveryDate) return "Delivery Date";
    if (semantic == Address) return "Address";
    if (semantic == City_Short) return "";
    if (semantic == Street_Short) return "st.";
    if (semantic == House_Short) return "";
    if (semantic == Building_Short) return "bd.";
    if (semantic == Apartment_Short) return "apt.";
    if (semantic == Recipient) return "Recipient";
    if (semantic == Name) return "Name";
    if (semantic == Phone) return "Phone";
    if (semantic == Customer) return "Customer";

    if (semantic == BouquetCheck) return "Bouquet Check";
    if (semantic == Bouquet) return "Bouquet";
    if (semantic == Parts_Short) return "PCS";
    if (semantic == Cost) return "Cost";

    if (semantic == Florist) return "Florist";
    if (semantic == Courier) return "Courier";
  }
  return {};
}

CheckLocalization::Lang CheckLocalization::getLanguage(const QString& checkLanguage) {
  if (checkLanguage == "RU") {
    return cTr::Ru;
  } else if (checkLanguage == "EN") {
    return cTr::En;
  }
  return cTr::Ru;
}
