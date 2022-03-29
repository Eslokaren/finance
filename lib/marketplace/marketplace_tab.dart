import 'dart:ui';

import 'package:finance/finance/screens/pay_screen.dart';
import 'package:finance/marketplace/models/doc.dart';
import 'package:finance/marketplace/widgets/media_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api.dart';

class MarketplaceTab extends StatefulWidget {
  final String? type;
  const MarketplaceTab({Key? key, @required this.type}) : super(key: key);

  @override
  State<MarketplaceTab> createState() => _MarketplaceTabState();
}

class _MarketplaceTabState extends State<MarketplaceTab> {
  List? docs;
  Box<dynamic>? globalBox;

  final _scrollController = ScrollController();

  MarketplaceApi _api = new MarketplaceApi();

  Future buildMarketplace(String type, bool refresh, bool loadMore) async {
    final box = await Hive.openBox('marketplace_${widget.type}');
    List? localDocs = box.get('marketplace_${widget.type}');
    if (localDocs != null && !refresh) {
      print("Reading from localDocs");
      if (loadMore) {
        List newDocs = await _api.loadMarketplace(widget.type!, refresh);
        docs = localDocs..addAll(newDocs);
        box.put('marketplace_${widget.type}', docs);
        localDocs = box.get('marketplace_${widget.type}');
      }
      setState(() {
        docs = localDocs;
      });
    } else if (refresh || localDocs == null) {
      print("Loading ${widget.type}");
      final docList = await _api.loadMarketplace(widget.type!, refresh);
      setState(() {
        docs = docList as List;
        globalBox = box;
      });
      box.put('marketplace_${widget.type}', docList as List);
      box.put('marketplace_${widget.type}_date',
          '${DateTime.now().toIso8601String()}');
    }
  }

  @override
  void initState() {
    buildMarketplace(widget.type!, false, false);

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          buildMarketplace(widget.type!, false, true);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (docs == null)
      return Center(
        child: CircularProgressIndicator(),
      );
    return RefreshIndicator(
      onRefresh: () => buildMarketplace(widget.type!, true, false),
      child: widget.type == "audio"
          ? _AudioContent(docs: docs!)
          : _ImagesAndVideosContent(
              docs: docs!,
              isImage: widget.type == 'image',
              scrollController: _scrollController,
            ),
    );
  }
}

class _ImagesAndVideosContent extends StatelessWidget {
  const _ImagesAndVideosContent(
      {Key? key,
      required this.docs,
      required this.isImage,
      required this.scrollController})
      : super(key: key);

  final List docs;
  final bool isImage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return docs.isEmpty
        ? DiscoverNoResults(type: isImage ? MediaType.image : MediaType.video)
        : GridView.builder(
            controller: scrollController,
            itemCount: docs.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: 123 / 172,
            ),
            itemBuilder: (BuildContext context, int index) {
              Doc doc = Doc.fromMap(docs[index]);
              return GestureDetector(
                child: MediaItem(
                    thumbnail: doc.thumbnail ?? "",
                    avatarUrl: doc.thumbnail ?? "",
                    displayName: doc.publisher?.displayName ?? ""),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PayScreen(
                        doc: doc,
                        isFromSubscription: false,
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  t(String s) {
    return t;
  }
}

class _AudioContent extends StatelessWidget {
  const _AudioContent({Key? key, required this.docs}) : super(key: key);
  final List docs;

  @override
  Widget build(BuildContext context) {
    return docs.isEmpty
        ? DiscoverNoResults(type: MediaType.audio)
        : ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, index) {
              Doc doc = Doc.fromMap(docs[index]);

              return _audioTile(context, doc);
            });
  }

  Widget _audioTile(BuildContext context, Doc doc) {
    final duration = Duration(seconds: doc.duration ?? 0);
    return ListTile(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PayScreen(
                  doc: doc,
                  isFromSubscription: false,
                ),
              ),
            ),
        leading: _BuildLeading(),
        title: Text(
          doc.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          doc.author ?? doc.publisher?.displayName ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text((duration.inMinutes).toString() +
            ':' +
            ((duration.inSeconds) % 60).toString().padLeft(2, "0")));
  }
}

class _BuildLeading extends StatelessWidget {
  const _BuildLeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundImage:
              AssetImage("lib/assets/images/cover_placeholder.png"),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Material(
              elevation: 16.0,
              color: Colors.transparent,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscoverNoResults extends StatelessWidget {
  final MediaType type;
  const DiscoverNoResults({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;

    switch (type) {
      case MediaType.image:
        title = 'discover.discover_connections.image_tab.item_title.no_results';
        subtitle =
            'discover.discover_connections.image_tab.item_subtitle.no_results';
        break;
      case MediaType.video:
        title = 'discover.discover_connections.video_tab.item_title.no_results';
        subtitle =
            'discover.discover_connections.video_tab.item_subtitle.no_results';
        break;
      default:
        title = 'discover.discover_connections.audio_tab.item_title.no_results';
        subtitle =
            'discover.discover_connections.audio_tab.item_subtitle.no_results';
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          Container(
            height: 15,
          ),
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Container(
            height: 10,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

enum MediaType { image, video, audio }
