import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';

class IsoGame extends Game {
  static const double SIZE = 50.0;

  final _whiteStroke = Paint()
    ..color = Color(0xffffffff)
    ..style = PaintingStyle.stroke;

  final _red = Paint()..color = Color(0xffff0000);
  final _blue = Paint()..color = Color(0xff0000ff);
  final _yellow = Paint()..color = Color(0xfff0ea3c);

  final Size screenSize;

  Position playerPos = Position(0, 0);

  IsoGame(this.screenSize);

  final board = [
    [1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1],
  ];

  @override
  void update(double dt) {}

  void movePlayerRight() {
    playerPos = playerPos.add(Position(1, 0));
  }

  void movePlayerLeft() {
    playerPos = playerPos.add(Position(-1, 0));
  }

  void movePlayerUp() {
    playerPos = playerPos.add(Position(0, -1));
  }

  void movePlayerDown() {
    playerPos = playerPos.add(Position(0, 1));
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // making the 0, 0 on the middle of the screen
    // adding the board.length to give a sense of depth, but this is probably an ugly workaround, there may be a better way to calculate this
    canvas.translate(screenSize.width / 2,
        screenSize.height / 2 - (board.length * SIZE / 2));

    for (var y = 0; y < board.length; y++) {
      for (var x = 0; x < board[y].length; x++) {
        drawTile(canvas, Position(x.toDouble(), y.toDouble()), board[y][x]);
      }
    }

    final playerProjectedPosition =
        cartesianToIso(playerPos.clone().times(SIZE));
    final rect = Rect.fromLTWH(
        playerProjectedPosition.x, playerProjectedPosition.y, SIZE, SIZE);
    canvas.drawOval(rect, _yellow);

    canvas.restore();
  }

  Position cartesianToIso(Position p) {
    final isoX = p.x - p.y;
    final isoY = (p.x + p.y) / 2;

    return Position(isoX, isoY);
  }

  void drawTile(Canvas c, Position point, int value) {
    final projectedPosition = cartesianToIso(point.times(SIZE));

    final rect =
        Rect.fromLTWH(projectedPosition.x, projectedPosition.y, SIZE, SIZE);
    final paint = value == 1 ? _blue : _red;

    c.drawRect(rect, paint);
    c.drawRect(rect, _whiteStroke);
  }
}
