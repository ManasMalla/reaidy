import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CertificatePage extends StatefulWidget {
  final bool isReport;
  final List<int> skills;
  final String title;
  final String name;
  final String date;
  const CertificatePage(
      {super.key,
      this.isReport = false,
      required this.skills,
      required this.title,
      required this.name,
      required this.date});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReaidyLogo(),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bytes = await controller.capture();
          Directory("/storage/emulated/0/DCIM/reaidy").create().then((value) =>
              File(value.path + "/certificate_${widget.title}.png")
                  .writeAsBytes(bytes!));
        },
        child: Icon(Icons.download),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AspectRatio(
              aspectRatio: 1.6,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.amber.shade300)),
                child: WidgetsToImage(
                  controller: controller,
                  child: Container(
                    color: Colors.white,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Stack(alignment: Alignment.center, children: [
                        Positioned(
                          top: -(constraints.maxHeight / 6),
                          left: -(constraints.maxHeight / 3),
                          child: Image.asset(
                            "assets/top-removebg-preview.png",
                            width: constraints.maxWidth / 2,
                          ),
                        ),
                        Positioned(
                          bottom: -(constraints.maxHeight / 6),
                          right: -(constraints.maxHeight / 3),
                          child: Image.asset(
                            "assets/bottom-removebg-preview.png",
                            width: constraints.maxWidth / 2,
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight / 18,
                          child: ReaidyLogo(
                            color: Color(0xFFf79421),
                            height: constraints.maxHeight * 0.06,
                          ),
                        ),
                        Positioned(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.22,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        widget.isReport
                                            ? "Report"
                                            : "Certificate",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Color(0xFFD3AC39),
                                              fontFamily: "Amsterdam",
                                              height: 2.4,
                                            ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 54),
                                        child: Text(
                                          widget.isReport
                                              ? "on Mock Interview"
                                              : "on course completion",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Color(0xFFD3AC39),
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.04,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Color(0xFFD3AC39),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.isReport
                                            ? "Report given to interviee"
                                            : "This certificate is proudly awarded to",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Color(0xFFD3AC39),
                                              fontSize: widget.isReport
                                                  ? constraints.maxHeight * 0.04
                                                  : constraints.maxHeight *
                                                      0.03,
                                              height: 3,
                                            ),
                                      ),
                                      Text(
                                        widget.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Color(0xFFD3AC39),
                                              fontFamily: "Amsterdam",
                                              fontSize:
                                                  constraints.maxHeight * 0.04,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "This is awarded to for ${widget.isReport ? "attempting" : "completing"} the",
                              style: TextStyle(
                                  color: Color(0x70263574),
                                  fontSize: constraints.maxHeight * 0.03),
                            ),
                            Text(
                              "\"${widget.title}\" ${widget.isReport ? "interview" : "Course"}",
                              style: TextStyle(
                                  color: Color(0xFF263574),
                                  fontSize: constraints.maxHeight * 0.055,
                                  fontWeight: FontWeight.bold,
                                  height: constraints.maxHeight * 0.0045),
                            ),
                            Text(
                              "on",
                              style: TextStyle(
                                color: Color(0x70263574),
                                fontSize: constraints.maxHeight * 0.03,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                                color: Color(0xFFD3AC39),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 3),
                                child: Text(widget.date,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            constraints.maxHeight * 0.03))),
                            SizedBox(height: constraints.maxHeight * 0.04),
                            Row(
                              mainAxisAlignment: widget.isReport
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "assets/badge-removebg-preview.png",
                                  height: constraints.maxHeight * 0.2,
                                ),
                                widget.isReport
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth / 10,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value:
                                                        widget.skills[0] / 100,
                                                    backgroundColor:
                                                        Color(0xFFF6E1D3),
                                                    color: Color(0xFFD3AC39),
                                                    strokeCap: StrokeCap.round,
                                                    strokeWidth: 4,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.skills[0]}%",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                          fontSize: constraints
                                                                  .maxHeight *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Text(
                                            "Technical skills",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.03),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                widget.isReport
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth / 10,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value:
                                                        widget.skills[1] / 100,
                                                    backgroundColor:
                                                        Color(0xFFF6E1D3),
                                                    color: Color(0xFFD3AC39),
                                                    strokeCap: StrokeCap.round,
                                                    strokeWidth: 4,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.skills[1]}%",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                          fontSize: constraints
                                                                  .maxHeight *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Text(
                                            "Communication skills",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.03),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                widget.isReport
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth / 10,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value:
                                                        widget.skills[2] / 100,
                                                    backgroundColor:
                                                        Color(0xFFF6E1D3),
                                                    color: Color(0xFFD3AC39),
                                                    strokeCap: StrokeCap.round,
                                                    strokeWidth: 4,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.skills[2]}%",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                          fontSize: constraints
                                                                  .maxHeight *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Text(
                                            "Overall skills",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.03),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: widget.isReport
                                      ? constraints.maxWidth * 0.1
                                      : 0,
                                )
                              ],
                            )
                          ],
                        )),
                        Positioned(
                          bottom: 2,
                          child: Text(
                            "WWW.REAIDY.IO",
                            style: TextStyle(
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        )
                      ]);
                    }),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
