class ProviderDashboardSummary {
  const ProviderDashboardSummary({
    required this.totalEarnings,
    required this.completedJobs,
    required this.averageRating,
    required this.isAvailable,
  });

  final double totalEarnings;
  final int completedJobs;
  final double averageRating;
  final bool isAvailable;
}