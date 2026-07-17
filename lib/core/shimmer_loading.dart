import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerLoading extends StatelessWidget {

  const ShimmerLoading({
    super.key,
  });


  Widget box({
    double height = 20,
    double width = double.infinity,
  }) {

    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );

  }


  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(12),

        child: Column(

          children: [

            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),


            const SizedBox(height: 15),


            ...List.generate(
              6,
              (index) {

                return Container(

                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),

                  padding: const EdgeInsets.all(12),

                  height: 220,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Column(
                    children: [

                      box(
                        height: 25,
                        width: 150,
                      ),

                      const SizedBox(height: 20),

                      box(),

                      box(),

                      box(),

                      box(),

                    ],
                  ),

                );

              },
            )

          ],
        ),
      ),
    );
  }
}