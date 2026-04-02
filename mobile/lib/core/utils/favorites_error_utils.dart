String resolveFavoritesErrorMessageKey(Object error) {
  final raw = error.toString().toLowerCase();

  if (raw.contains('failed to load favorites')) {
    return 'favorites_error_generic';
  }

  if (raw.contains('failed to add favorite')) {
    return 'favorites_error_generic';
  }

  if (raw.contains('failed to remove favorite')) {
    return 'favorites_error_generic';
  }

  if (raw.contains('signed in') || raw.contains('client profile')) {
    return 'favorites_error_generic';
  }

  return 'favorites_error_generic';
}
