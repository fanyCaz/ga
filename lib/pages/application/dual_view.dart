import 'package:flutter/cupertino.dart';

class DualView extends StatelessWidget{

  const DualView({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.spacing = 0.0,
    this.aspectRatio = 0.7,
    this.verticalPercentSeparation = 0.5,
  }) : super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double spacing;
  final double aspectRatio;
  final double verticalPercentSeparation;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      final width = constraints.maxWidth;
      final itemHeight = (width*0.5) / aspectRatio;
      final height = constraints.maxHeight + itemHeight;
      return OverflowBox(
          maxWidth: width,
          maxHeight: height,
          minHeight: height,
          minWidth: width,
          child: GridView.builder(
              padding: EdgeInsets.only(top: itemHeight*0.5, bottom: itemHeight),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: itemCount,
              itemBuilder: (context,index) {
                return Transform.translate(
                    offset: Offset(0.0, index.isOdd? itemHeight * verticalPercentSeparation : 0.0),child: itemBuilder(context,index)
                );
              })
      );
    }
    );
  }
}
