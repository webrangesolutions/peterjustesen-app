import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peterjustesen/ui/screens/CategoriesScreen.dart';
import 'package:peterjustesen/ui/screens/SingleCategoryScreen.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';

part 'main_event.dart';
part 'main_state.dart';

class PeterMainBloc extends Bloc<NavEvent, PeterState> {
  PeterMainBloc()
      : super(PeterState(
          selectedTab: "Home",
        )) {
    // this is a constructor initializer list and it is used to initialize the fields of a class in the same place where they are declared. dart automatically calls the constructor initializer list after the constructor body has been executed.
    on<TabChanged>((event, emit) {
      emit(PeterState(selectedTab: event.tabName));
    });
    on<HomePageClicked>((event, emit) {
      emit(PeterState(selectedTab: "Home"));
    });
  }
}
