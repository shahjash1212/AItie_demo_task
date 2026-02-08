enum TrendFilterEnum { daily, weekly, monthly, yearly }

extension TrendFilterEnumExtension on TrendFilterEnum {
  String toStringValue() {
    switch (this) {
      case TrendFilterEnum.daily:
        return 'daily';
      case TrendFilterEnum.weekly:
        return 'weekly';
      case TrendFilterEnum.monthly:
        return 'monthly';
      case TrendFilterEnum.yearly:
        return 'yearly';
    }
  }
}
