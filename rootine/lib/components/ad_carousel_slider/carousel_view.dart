import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rootine/components/ad_carousel_slider/data.dart';
import 'package:rootine/components/ad_carousel_slider/image_viewer.dart';

class CarouselViewer extends StatefulWidget {
  const CarouselViewer({super.key});

  @override
  State<CarouselViewer> createState() => _CarouselViewerState();
}

class _CarouselViewerState extends State<CarouselViewer> {
  late CarouselController carouselController;
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //CarouselView
          Positioned.fill(
            child: CarouselSlider(
              items: CarouselImageData.carouselImages.map(
                (imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ImageViewer.show(context: context, assetPath: imagePath);
                    },
                  );
                },
              ).toList(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      currentPage = index;
                    },
                  );
                },
              ),
            ),
          ),
          //Indicators
          Positioned(
            bottom: 20,
            child: Row(
              children: List.generate(
                CarouselImageData.carouselImages.length,
                (index) {
                  bool isSelected = currentPage == index;
                  return GestureDetector(
                    onTap: () {
                      carouselController.animateToPage(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isSelected ? 55 : 17,
                      height: 10,
                      margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey.shade200,
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
