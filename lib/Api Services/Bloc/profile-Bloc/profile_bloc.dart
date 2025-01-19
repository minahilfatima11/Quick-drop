import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zipline_project/Api%20Services/Repository/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo profileRepo;
  ProfileBloc(this.profileRepo) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onProfileLoaded);
  }

  _onProfileLoaded(ProfileLoadEvent event, Emitter<ProfileState> emit) async {
    try {
      var data = await profileRepo.fetchProfile(event.id);
      emit(ProfileLoaded(data: data));
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }
}
