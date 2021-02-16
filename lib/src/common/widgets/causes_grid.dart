import 'package:Gifts/src/common/providers/causes_provider.dart';
import 'package:Gifts/src/common/widgets/cause_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String causeId;
String causeTitle;
int causeFilter;

class CausesGrid extends StatelessWidget {
  final bool showFavs;

  const CausesGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final causesData = Provider.of<CausesProvider>(context);
    final causes = showFavs ? causesData.favoriteItems : causesData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: causes.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: causes[i],
        child: CauseItem(causeId, causeTitle, causeFilter),
      ),
    );
  }
}

class CausesGrid2 extends StatelessWidget {
  final bool showFavs;

  const CausesGrid2(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final causesData = Provider.of<CausesProvider>(context);
    final causes = showFavs ? causesData.favoriteItems : causesData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: causes.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: causes[i],
        child: CauseItem2(causeId, causeTitle, causeFilter),
      ),
    );
  }
}
