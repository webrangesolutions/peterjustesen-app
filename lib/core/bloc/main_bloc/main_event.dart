part of 'main_bloc.dart';

abstract class NavEvent extends Equatable {
  const NavEvent(): super();

  @override
  List<Object> get props => [];
}

class TabChanged extends NavEvent {
  final String tabName;

  const TabChanged({required this.tabName});

  @override
  List<Object> get props => [tabName];
}

class HomePageClicked extends NavEvent {
  const HomePageClicked();

  @override
  List<Object> get props => [];
}
