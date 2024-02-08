import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false; // Track the play/pause state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Player and Full Screen Player'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mini Player
          MiniPlayer(
            isPlaying: isPlaying,
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),

          // Spacer to create some space between mini and full player
          SizedBox(height: 20),

          // Full Screen Player
          FullScreenPlayer(
            isPlaying: isPlaying,
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ],
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  MiniPlayer({required this.isPlaying, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: (){
                onPressed();
              }
          ),
          Text('Mini Player'),
        ],
      ),
    );
  }
}

class FullScreenPlayer extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  FullScreenPlayer({required this.isPlaying, required this.onPressed});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Full Screen Player',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              iconSize: 50,
              onPressed: widget.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
