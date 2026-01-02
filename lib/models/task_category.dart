class TaskCategory {
  static const String personal = 'Personal';
  static const String work = 'Work';
  static const String classCategory = 'Class';
  static const String health = 'Health';
  static const String finance = 'Finance';
  static const String shopping = 'Shopping';
  static const String travel = 'Travel';
  static const String study = 'Study';
  static const String meeting = 'Meeting';
  static const String appointment = 'Appointment';
  static const String other = 'Other';

  static const List<String> allCategories = [
    personal,
    work,
    classCategory,
    health,
    finance,
    shopping,
    travel,
    study,
    meeting,
    appointment,
    other,
  ];

  static String getIcon(String category) {
    switch (category) {
      case personal:
        return '👤';
      case work:
        return '💼';
      case classCategory:
        return '🎓';
      case health:
        return '🏥';
      case finance:
        return '💰';
      case shopping:
        return '🛒';
      case travel:
        return '✈️';
      case study:
        return '📚';
      case meeting:
        return '🤝';
      case appointment:
        return '📅';
      case other:
        return '📝';
      default:
        return '📝';
    }
  }

  static String getColor(String category) {
    switch (category) {
      case personal:
        return '#2196F3'; // Blue
      case work:
        return '#FF9800'; // Orange
      case classCategory:
        return '#9C27B0'; // Purple
      case health:
        return '#4CAF50'; // Green
      case finance:
        return '#795548'; // Brown
      case shopping:
        return '#E91E63'; // Pink
      case travel:
        return '#00BCD4'; // Cyan
      case study:
        return '#3F51B5'; // Indigo
      case meeting:
        return '#FF5722'; // Deep Orange
      case appointment:
        return '#607D8B'; // Blue Grey
      case other:
        return '#9E9E9E'; // Grey
      default:
        return '#9E9E9E';
    }
  }
}