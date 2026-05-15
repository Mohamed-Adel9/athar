import 'package:athar/features/profile/data/models/setting_item.dart';
import 'package:athar/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());

  final List<SettingItem> settings = [
    SettingItem(icon: CupertinoIcons.cube_box, title: 'طلباتي', onTap: () {}),
    SettingItem(
      icon: Icons.design_services_outlined,
      title: 'تصاميمي',
      onTap: () {},
    ),
    SettingItem(icon: Icons.settings, title: 'الإعدادت', onTap: () {}),
  ];

  void selectSection(ProfileSection section) {
    emit(state.copyWith(selectedSection: section));
  }

  void updateProfile({String? name, String? email, String? password}) {
    emit(state.copyWith(name: name ?? state.name, email: email ?? state.email));
  }

  void addOrder() {
    emit(state.copyWith(orders: state.orders + 1));
  }
}
