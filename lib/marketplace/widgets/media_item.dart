import 'dart:ui';

import 'package:finance/global/utils.dart';
import 'package:flutter/material.dart';

class MediaItem extends StatelessWidget {
  const MediaItem({
    Key? key,
    required this.thumbnail,
    required this.avatarUrl,
    required this.displayName,
    this.hasMenu = false,
  }) : super(key: key);

  final String thumbnail;

  final String? avatarUrl;

  final String displayName;

  final bool hasMenu;

  @override
  Widget build(BuildContext context) {
    final words = displayName.split(' ');
    return Stack(
      children: [
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: 100 / 140,
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage(thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.3,
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Spacer(flex: 2),
                  Flexible(
                    flex: 6,
                    child: FractionallySizedBox(
                      heightFactor: 0.8,
                      child: Stack(
                        children: [
                          avatarUrl != null
                              ? Container(
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        avatarUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: getRandomColor(),
                                  child: Text(
                                    '${words[0][0]}${words[1][0]}',
                                    style: TextStyle(fontSize: 36),
                                  ),
                                ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: Colors.blue),
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 14,
                    child: Text(
                      displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
