import 'dart:math';

import 'package:finance/marketplace/models/doc.dart';
import 'package:finance/marketplace/models/media_details.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InformationContent extends StatelessWidget {
  final VoidCallback closeModal;
  final Doc doc;
  final MediaDetails details;

  const InformationContent(this.closeModal, this.doc, this.details);

  @override
  Widget build(BuildContext context) {
    final bool hasAdditionalInfo = ((details.categories?.isNotEmpty ?? false) ||
        (details.skills?.isNotEmpty ?? false) ||
        details.location != null ||
        details.premiereDate != null);
    return Expanded(
      child: details.istNotEmpty()
          ? Scaffold(
              body: ListView(
                padding: EdgeInsets.only(bottom: 16),
                children: [
                  _InformationStatistics(
                    doc: doc,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  if (details.title != null || details.description != null)
                    InformationTitle(details),
                  if (hasAdditionalInfo)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InformationAdditionial(details),
                    ),
                  if (details.socialLinks != null)
                    if (details.socialLinks!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InformationLinks(details),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                  if (details.actorsOrTalents?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.actorsOrTalents,
                      title: 'Actor or Talents:',
                    ),
                  if (details.directors?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.directors,
                      title: 'Directors:',
                    ),
                  if (details.photographyDirectors?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.photographyDirectors,
                      title: 'Cinematographer:',
                    ),
                  if (details.musicBy?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.musicBy,
                      title: 'Music by:',
                    ),
                  if (details.licenseOwner?.id != null)
                    _InformationActors(
                      users: details.licenseOwner,
                      title: 'License Owner:',
                    ),
                  if (details.mediaModels?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.mediaModels,
                      title: 'Models:',
                    ),
                  if (details.stylists?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.stylists,
                      title: 'Stylists:',
                    ),
                  if (details.makeupArtists?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.makeupArtists,
                      title: 'Makeup Artist:',
                    ),
                  if (details.photographers?.isNotEmpty ?? false)
                    _InformationActors(
                      users: details.photographers,
                      title: 'Photographers:',
                    ),
                ],
              ),
            )
          : Scaffold(
            body: Center(
                child: Text("X. empty"),
              ),
          ),
    );
  }
}

class InformationTitle extends StatelessWidget {
  InformationTitle(this.mediaDetails);
  final MediaDetails mediaDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: mediaDetails.title == null,
            child: Text(
              '${mediaDetails.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Offstage(
            offstage: mediaDetails.description == null,
            child: ShowMoreDescription(mediaDetails.description ?? ""),
          ),
        ],
      ),
    );
  }
}

class ShowMoreDescription extends StatefulWidget {
  const ShowMoreDescription(this.text);

  final String text;

  @override
  _ShowMoreDescriptionState createState() => _ShowMoreDescriptionState();
}

class _ShowMoreDescriptionState extends State<ShowMoreDescription> {
  bool isExpanded = false;

  //TODO este proceso de obtener el key no puede ir aqui adentro, daña el funcionamiento del modal...
  // Box<dynamic>? box;

  // void loadScreenKeys() async {
  //   if (box?.get('keys') == null) {
  //     final keysBox = await Hive.openBox('language');
  //       box = keysBox;

  //   }
  // }

  String t(String key) {
    return isExpanded ? "Show less" : "Show more";
    // return box?.get('keys')[key];
  }

  @override
  void initState() {
    // loadScreenKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: isExpanded ? null : 70.0,
        child: Text(
          widget.text,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
        // child: Linkify(
        //   softWrap: true,
        //   overflow: TextOverflow.fade,
        //   text: widget.text,
        //   onOpen: (element) => LinkWebBrowser.instance.openWebPage(element.url),
        // ),
      ),
      isExpanded
          ? TextButton(
              child: Text(t(
                'flutter_information.links.link_widget.show_less',
              )),
              onPressed: () => setState(() => isExpanded = false),
            )
          : TextButton(
              child: Text(t(
                'flutter_information.links.link_widget.read_more',
              )),
              onPressed: () => setState(() => isExpanded = true),
            )
    ]);
  }
}

class InformationAdditionial extends StatelessWidget {
  InformationAdditionial(this.mediaDetails);
  final MediaDetails mediaDetails;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (mediaDetails.categories?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Categories: ${mediaDetails.categories?.join(', ')}'),
              SizedBox(height: 8),
            ],
          ),
        if (mediaDetails.skills?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skills: ${mediaDetails.skills?.join(', ')}'),
              SizedBox(height: 8),
            ],
          ),
        Offstage(
          offstage: mediaDetails.location == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: ${mediaDetails.location?.address}'),
              SizedBox(height: 8),
            ],
          ),
        ),
        Offstage(
          offstage: mediaDetails.premiereDate == null,
          child: Text('Premiere date: ${mediaDetails.premiereDate}'),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _InformationLinks extends StatelessWidget {
  _InformationLinks(this.details);
  final MediaDetails details;

  @override
  Widget build(BuildContext context) {
    List socialLinks = details.socialLinks ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Website & Social Links',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            ...socialLinks.map((e) => ListTile(
                  leading: Icon(
                    Icons.public,
                    color: Colors.black,
                  ),
                  visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      //overflow: TextOverflow.ellipsis,
                      color: Colors.blue,
                    ),
                  ),
                )),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Icon(Icons.facebook, color: Colors.blue),
                SizedBox(width: 8),
                Text('Facebook: Oshinstar_'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _InformationActors extends StatelessWidget {
  final images;
  final users;
  final title;

  _InformationActors({this.images, this.users, this.title});

  @override
  Widget build(BuildContext context) {
    int profilesLength;

    if (users is Profile) {
      profilesLength = 1;
    } else if (users is List) {
      profilesLength = users.length;
    } else {
      profilesLength = 1;
    }

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 140.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              itemCount: profilesLength,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // onTap: () => router.navigateTo(
                  //   context,
                  //   '/profile/${users is Profile ? users.username : users[index].username}',
                  // ),
                  child: Container(
                    width: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularBorder(
                            child: ((users is Profile
                                        ? users.avatar
                                        : users[index].avatar) !=
                                    null)
                                ? Container(
                                    width: 75.0,
                                    height: 75.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(users is Profile
                                            ? users.avatar
                                            : users[index].avatar),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ))
                                : Container(
                                    width: 75.0,
                                    height: 75.0,
                                    child: Icon(
                                      users is Profile
                                          ? users.hasAvatar
                                          : users[index].hasAvatar
                                              ? Icons.visibility_off
                                              : users is Profile
                                                  ? users.gender
                                                  : users[index].gender ==
                                                          "female"
                                                      ? MdiIcons.faceWoman
                                                      : MdiIcons.faceMan,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  )),
                        SizedBox(height: 16),
                        if (users != null)
                          Text(
                            users is Profile
                                ? users.displayName
                                : users[index].displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CircularBorder extends StatelessWidget {
  ///  El color del borde.
  final Color color;

  /// El diámetro del círculo.
  final double diameter;

  /// El grosor del borde.
  final double strokeWidth;

  /// El hijo del que tendrá esto.
  final Widget child;

  /// El número de ocurrencias de arcos que tendrá el borde.
  ///
  /// El espaciado entre los arcos es calculado automáticamente.
  final int arcOcurrences;

  /// El tamaño que hay entre [child] y la circuferencia del borde.
  final int borderPadding;

  /// El margen del borde.
  final EdgeInsetsGeometry margin;

  const CircularBorder({
    this.color = Colors.amber,
    this.diameter = 70,
    this.strokeWidth = 4.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.borderPadding = 8,
    this.arcOcurrences = 16,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      alignment: Alignment.center,
      margin: margin,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          CustomPaint(
            size: Size(diameter, diameter),
            foregroundPainter: _DashedBorderPaint(
              color: color,
              strokeWidth: strokeWidth,
              ocurrences: arcOcurrences,
              borderPadding: borderPadding,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationStatistics extends StatelessWidget {
  _InformationStatistics({required this.doc});
  final Doc doc;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${doc.likes}'),
                SizedBox(
                  height: 4,
                ),
                Icon(Icons.thumb_up_alt_outlined)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${doc.views}'),
                SizedBox(
                  height: 4,
                ),
                Icon(Icons.remove_red_eye_outlined)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('jun 21'),
                SizedBox(
                  height: 4,
                ),
                Text('2021'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPaint extends CustomPainter {
  /// El color del borde
  final Color color;

  /// El grosor del borde.
  final double strokeWidth;

  /// El número de líneas discontinuas que tendrá el borde.
  ///
  /// El espacio entre ellas es automáticamente calculado, comienza a crearse
  /// desde `pi` radian.
  final int ocurrences;

  /// Se le agrega al radio calculado para dar la ilusión de un "padding".
  final int borderPadding;

  const _DashedBorderPaint({
    required this.color,
    required this.strokeWidth,
    required this.ocurrences,
    required this.borderPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint p1 = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final origin = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) + borderPadding;
    final arcLen = pi / ocurrences;
    var radianAngle = pi - arcLen;
    for (var i = 0; i < (ocurrences * 2); i++) {
      radianAngle += arcLen;
      if (i % 2 != 0) continue;
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: radius),
        radianAngle,
        arcLen,
        false,
        p1,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Un modal que puede crecer y disminuir en el eje y.
class ExpandableScrollableModal extends StatefulWidget {
  /// El contenido de esto.
  final Widget child;

  /// Se ejecuta al cerrar este modal.
  final void Function() onModalDismiss;

  const ExpandableScrollableModal({
    required this.child,
    required this.onModalDismiss,
  });

  @override
  _ExpandableScrollableModalState createState() =>
      _ExpandableScrollableModalState();
}

class _ExpandableScrollableModalState extends State<ExpandableScrollableModal> {
  bool scrollControllerHasNoListeners = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.70,
      minChildSize: 0.00,
      builder: (context, scrollController) {
        if (scrollControllerHasNoListeners) {
          scrollControllerHasNoListeners = false;
          scrollController.addListener(() {
            if (scrollController.position.pixels == -1.0) {
              final e = widget.onModalDismiss;
              if (e != null) e();
            }
          });
        }
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(20),
              right: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.height * 0.008,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}
