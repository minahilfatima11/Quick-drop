abstract class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {
  final int id;
  ProfileLoadEvent({required this.id});
}
