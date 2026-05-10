class ProfileState {
  final String name;
  final String email;
  final int orders;
  final int designs;
  final int wishlist;

  const ProfileState({
    required this.name,
    required this.email,
    required this.orders,
    required this.designs,
    required this.wishlist,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      name: "Mohamed Adel",
      email: "eng.mohamed.adel49@email.com",
      orders: 12,
      designs: 8,
      wishlist: 24,
    );
  }
}
