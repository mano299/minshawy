import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minshawy/data/api_service.dart';
import 'package:minshawy/models/surah_model.dart';

part 'suras_state.dart';

class SurasCubit extends Cubit<SurasState> {
  SurasCubit() : super(SurasInitial());

  List<SurahModel> suras = [];

  Future<void> getSuras() async {
    emit(SurasLoading());

    try {
      suras = await ApiService.getSuras();

      emit(SurasSuccess(suras));
    } catch (e) {
      emit(SurasError(e.toString()));
    }
  }
}
