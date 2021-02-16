import 'package:Gifts/src/common/providers/ngos_provider.dart';
// import 'package:Gifts/src/common/widgets/causes_grid.dart';
import 'package:Gifts/src/common/widgets/ngo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NgosGrid extends StatelessWidget {
  final bool showFavs;
  final String id;

  const NgosGrid({@required this.showFavs, @required this.id});

  @override
  Widget build(BuildContext context) {
    final _ngosData = Provider.of<NgosProvider>(context);
    final ngos = showFavs ? _ngosData.favoriteItems : _ngosData.items;

    return ListView.builder(
      itemCount: ngos.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: ngos[i],
        child: NgoItem(id),
      ),
      shrinkWrap: true,
    );
  }
}
// return GridView.builder(
//   shrinkWrap: true,
//   padding: const EdgeInsets.all(10),
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     childAspectRatio: 3 / 2,
//     crossAxisSpacing: 10,
//     mainAxisSpacing: 10,
//   ),
//   itemCount: ngos.length,
//   itemBuilder: (context, i) => ChangeNotifierProvider.value(
//     value: ngos[i],
//     child: NgoItem(id),
//   ),
// );

// String causeId;
// String causeTitle;

// class CausesGrid2 extends StatelessWidget {
//   final bool showFavs;

//   const CausesGrid2(this.showFavs);

//   @override
//   Widget build(BuildContext context) {
//     final causesData = Provider.of<CausesProvider>(context);
//     final causes = showFavs ? causesData.favoriteItems : causesData.items;

//     return GridView.builder(
//       padding: const EdgeInsets.all(10),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 3 / 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: causes.length,
//       itemBuilder: (context, i) => ChangeNotifierProvider.value(
//         value: causes[i],
//         child: CauseItem2(causeId, causeTitle),
//       ),
//     );
//   }
// }
