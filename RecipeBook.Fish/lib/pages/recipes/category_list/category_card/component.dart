import 'package:fish_redux/fish_redux.dart';

import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CategoryCardComponent extends Component<CategoryCardState> {
  CategoryCardComponent()
      : super(
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CategoryCardState>(
                adapter: null,
                slots: <String, Dependent<CategoryCardState>>{
                }),);

}