import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  //ThemeMode是enum 在運用的是index value 代表dark,light,system
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);
//取資料
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return ThemeMode.values[json['theme'] as int];
    //throw UnimplementedError();
  }

//存資料
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // TODO: implement toJson
    return {'theme': state.index};
    //throw UnimplementedError();
  }
}
