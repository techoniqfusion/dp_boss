import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerEffect({bool isHomePageShimmer = true}) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade300,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade300,
              direction: ShimmerDirection.ltr,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 173,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            Visibility(
              visible: isHomePageShimmer,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                direction: ShimmerDirection.ltr,
                child: Container(
                  // margin: EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: 153,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Visibility(
                visible: !isHomePageShimmer,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          height: 12.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Container(
                          width: 40,
                          height: 12.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                )),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade300,
              direction: ShimmerDirection.ltr,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: isHomePageShimmer ? EdgeInsets.only(top: 8) : EdgeInsets.zero,
                itemBuilder: (_, __) =>
                isHomePageShimmer ? Container(
                  margin: EdgeInsets.only(top: 7),
                  height: 83,
                  decoration: BoxDecoration(
                   color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),) :
                    Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 51.0,
                        height: 51.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            // Container(
                            //   width: 40.0,
                            //   height: 8.0,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 20,
              ),
            ),
          ],
        ),
      ));
}
