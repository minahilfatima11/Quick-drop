class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final dynamic data;
  ProfileLoaded({required this.data});
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});
}
