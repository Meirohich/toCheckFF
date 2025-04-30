// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

class YoutubePlayerCustom extends StatefulWidget {
  const YoutubePlayerCustom({
    super.key,
    this.width,
    this.height,
    this.videoLink,
    this.onFullscreenChange,
  });

  final double? width;
  final double? height;
  final String? videoLink;
  final Future Function(bool isFullScreen)? onFullscreenChange;

  @override
  State<YoutubePlayerCustom> createState() => _YoutubePlayerCustomState();
}

class _YoutubePlayerCustomState extends State<YoutubePlayerCustom> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = widget.videoLink != null
        ? YoutubePlayer.convertUrlToId(widget.videoLink!)
        : '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
        widget.onFullscreenChange(_controller.value.isFullScreen);
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    // Reset orientation when widget is disposed
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              print('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        if (_controller.value.isFullScreen) {
          return player; // Fullscreen - just show the player
        }
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: player,
            ),
          ],
        );
        //   return Column(
        //     children: [
        //       player,
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             _space,
        //             _text('Title', _videoMetaData.title),
        //             _space,
        //             _text('Channel', _videoMetaData.author),
        //             _space,
        //             _text('Video Id', _videoMetaData.videoId),
        //             _space,
        //             Row(
        //               children: [
        //                 _text(
        //                   'Playback Quality',
        //                   _controller.value.playbackQuality ?? '',
        //                 ),
        //                 const Spacer(),
        //                 _text(
        //                   'Playback Rate',
        //                   '${_controller.value.playbackRate}x  ',
        //                 ),
        //               ],
        //             ),
        //             _space,
        //             TextField(
        //               enabled: _isPlayerReady,
        //               controller: _idController,
        //               decoration: InputDecoration(
        //                 border: InputBorder.none,
        //                 hintText: 'Enter youtube <video id> or <link>',
        //                 fillColor: Colors.blueAccent.withAlpha(20),
        //                 filled: true,
        //                 hintStyle: const TextStyle(
        //                   fontWeight: FontWeight.w300,
        //                   color: Colors.blueAccent,
        //                 ),
        //                 suffixIcon: IconButton(
        //                   icon: const Icon(Icons.clear),
        //                   onPressed: () => _idController.clear(),
        //                 ),
        //               ),
        //             ),
        //             _space,
        //             Row(
        //               children: [
        //                 _loadCueButton('LOAD'),
        //                 const SizedBox(width: 10.0),
        //                 _loadCueButton('CUE'),
        //               ],
        //             ),
        //             _space,
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 IconButton(
        //                   icon: const Icon(Icons.skip_previous),
        //                   onPressed: null,
        //                 ),
        //                 IconButton(
        //                   icon: Icon(
        //                     _controller.value.isPlaying
        //                         ? Icons.pause
        //                         : Icons.play_arrow,
        //                   ),
        //                   onPressed: _isPlayerReady
        //                       ? () {
        //                           _controller.value.isPlaying
        //                               ? _controller.pause()
        //                               : _controller.play();
        //                           setState(() {});
        //                         }
        //                       : null,
        //                 ),
        //                 IconButton(
        //                   icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
        //                   onPressed: _isPlayerReady
        //                       ? () {
        //                           _muted
        //                               ? _controller.unMute()
        //                               : _controller.mute();
        //                           setState(() {
        //                             _muted = !_muted;
        //                           });
        //                         }
        //                       : null,
        //                 ),
        //                 FullScreenButton(
        //                   controller: _controller,
        //                   color: Colors.blueAccent,
        //                 ),
        //                 IconButton(
        //                   icon: const Icon(Icons.skip_next),
        //                   onPressed: null,
        //                 ),
        //               ],
        //             ),
        //             _space,
        //             Row(
        //               children: <Widget>[
        //                 const Text(
        //                   "Volume",
        //                   style: TextStyle(fontWeight: FontWeight.w300),
        //                 ),
        //                 Expanded(
        //                   child: Slider(
        //                     inactiveColor: Colors.transparent,
        //                     value: _volume,
        //                     min: 0.0,
        //                     max: 100.0,
        //                     divisions: 10,
        //                     label: '${(_volume).round()}',
        //                     onChanged: _isPlayerReady
        //                         ? (value) {
        //                             setState(() {
        //                               _volume = value;
        //                             });
        //                             _controller.setVolume(_volume.round());
        //                           }
        //                         : null,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             _space,
        //             AnimatedContainer(
        //               duration: const Duration(milliseconds: 800),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20.0),
        //                 color: _getStateColor(_playerState),
        //               ),
        //               padding: const EdgeInsets.all(8.0),
        //               child: Text(
        //                 _playerState.toString(),
        //                 style: const TextStyle(
        //                   fontWeight: FontWeight.w300,
        //                   color: Colors.white,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   );
      },
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
