class NearbyUser {
  const NearbyUser({
    required this.name,
    this.isFollowing = false,
  });

  final String name;
  final bool isFollowing;

  NearbyUser copyWith({
    String? name,
    bool? isFollowing,
  }) {
    return NearbyUser(
      name: name ?? this.name,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
