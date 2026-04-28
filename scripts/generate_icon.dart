import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  const int size = 1024;
  final image = img.Image(width: size, height: size);

  // 1. Background (Primary Blue: #1565C0)
  img.fill(image, color: img.ColorRgba8(21, 101, 192, 255));

  // 2. Draw white car silhouette (Icons.local_car_wash style)
  final white = img.ColorRgba8(255, 255, 255, 255);
  final whiteTrans = img.ColorRgba8(255, 255, 255, 140); // For semi-transparent effects

  // Car Body (rounded rect style)
  // Lower body
  img.fillCircle(image, x: 300, y: 550, radius: 100, color: white);
  img.fillCircle(image, x: 724, y: 550, radius: 100, color: white);
  for (int y = 500; y < 650; y++) {
    img.drawLine(image, x1: 300, y1: y, x2: 724, y2: y, color: white);
  }

  // Upper body (roof)
  for (int y = 350; y < 500; y++) {
    double ratio = (y - 350) / (500 - 350);
    int width = (180 + (120 * ratio)).toInt();
    img.drawLine(image, x1: 512 - width, y1: y, x2: 512 + width, y2: y, color: white);
  }

  // Windows (cut out from roof)
  final bgBlue = img.ColorRgba8(21, 101, 192, 255);
  for (int y = 380; y < 480; y++) {
    double ratio = (y - 380) / (100);
    int width = (150 + (100 * ratio)).toInt();
    img.drawLine(image, x1: 512 - width, y1: y, x2: 512 + width, y2: y, color: bgBlue);
  }
  // Center pillar
  img.drawLine(image, x1: 502, y1: 350, x2: 522, y2: 500, color: white, thickness: 20);

  // Wheels
  img.fillCircle(image, x: 350, y: 650, radius: 80, color: bgBlue); // Wheel well
  img.fillCircle(image, x: 674, y: 650, radius: 80, color: bgBlue); 
  img.fillCircle(image, x: 350, y: 650, radius: 60, color: white); // Wheel
  img.fillCircle(image, x: 674, y: 650, radius: 60, color: white);

  // 3. Water Drops (Above the car)
  img.fillCircle(image, x: 512, y: 200, radius: 40, color: whiteTrans);
  img.fillCircle(image, x: 400, y: 250, radius: 30, color: whiteTrans);
  img.fillCircle(image, x: 624, y: 250, radius: 30, color: whiteTrans);

  // Save the image
  final png = img.encodePng(image);
  File('assets/images/app_icon.png').writeAsBytesSync(png);
  print('Original Design App icon generated successfully at assets/images/app_icon.png');
}
