import 'package:flutter/material.dart';

class FooterAction extends StatelessWidget {
  const FooterAction({
    Key? key,
    required this.onPress,
    required this.optionalBuilder,
    required this.isLoading,
    this.buttonHide = false,
  }) : super(key: key);

  final Function(double height) onPress;
  final Widget Function(double height) optionalBuilder;
  final bool isLoading;
  final bool buttonHide;

  double getWrapHeight(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    print('loadingState.isLoadingSave.value : ${isLoading ? 'y' : 'n'}');
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          optionalBuilder(getWrapHeight(context)),
          isLoading && !buttonHide
              ? (!buttonHide
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink())
              : (!buttonHide
                  ? TextButton(
                      onPressed: () {
                        onPress(getWrapHeight(context));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : SizedBox.shrink())
          // ValueListenableBuilder(
          //   valueListenable: isLoading,
          //   builder: (context, loading, child) {
          //     return loading && !buttonHide
          //         ? (!buttonHide
          //             ? Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: CircularProgressIndicator(),
          //               )
          //             : SizedBox.shrink())
          //         : (!buttonHide
          //             ? TextButton(
          //                 onPressed: () {
          //                   onPress(getWrapHeight(context));
          //                 },
          //                 style: TextButton.styleFrom(
          //                   foregroundColor: Colors.black,
          //                 ),
          //                 child: const Text(
          //                   'Simpan',
          //                   style: TextStyle(fontSize: 14),
          //                 ),
          //               )
          //             : SizedBox.shrink());
          //   },
          // ),
        ],
      ),
    );
  }
}
