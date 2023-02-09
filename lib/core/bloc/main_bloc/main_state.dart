part of 'main_bloc.dart';

class PeterState extends Equatable {
  PeterState({
    required this.selectedTab,
    this.isNavBarHidden = false,
  }): super();

  String selectedTab = "Home";
  bool isNavBarHidden = false;

  @override
  List<Object> get props => [selectedTab, isNavBarHidden];
}
