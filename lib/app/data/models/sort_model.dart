enum AlarmSortMode {
  defaultSort, 
  timeOfDay, 
  label, 
  creationDate,
  lastModified,
  customOrder;

  String get displayName {
    switch (this) {
      case AlarmSortMode.defaultSort:
        return 'Smart Sort (Enabled + Next Occurrence)';
      case AlarmSortMode.timeOfDay:
        return 'Time of Day';
      case AlarmSortMode.label:
        return 'Alarm Label';
      case AlarmSortMode.creationDate:
        return 'Creation Date';
      case AlarmSortMode.lastModified:
        return 'Last Modified';
      case AlarmSortMode.customOrder:
        return 'Custom Order';
    }
  }
}

enum SortDirection {
  ascending,
  descending;

  String get displayName {
    switch (this) {
      case SortDirection.ascending:
        return 'Ascending';
      case SortDirection.descending:
        return 'Descending';
    }
  }
} 