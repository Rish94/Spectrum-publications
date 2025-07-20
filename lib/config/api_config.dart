class ApiConfig {
  static const String baseUrl = 'https://app.spectrumpublication.in';
  static const String contentType = 'application/json';

  // API Endpoints
  static const String getMetadata = '/mobile-apis/getMetadata';
  static const String getSeries = '/mobile-apis/series';
  static const String getTypes = '/mobile-apis/types';
  static const String getClasses = '/mobile-apis/classes';
  static const String getSubjects = '/mobile-apis/subjects';
  static const String getBooks = '/mobile-apis/books';

  // Legacy endpoints (to be migrated)
  static const String getClassesOfSeries = '/series/{seriesId}/classes';
  static const String getBooksOfClass =
      '/series/{seriesId}/class/{classId}/books';
}
