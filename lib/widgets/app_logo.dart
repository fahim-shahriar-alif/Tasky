import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/theme_provider.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom Logo matching the provided design
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: ThemeProvider.gradientColors[0].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomPaint(
            size: Size(size, size),
            painter: TaskyLogoPainter(size: size),
          ),
        ),
        
        if (showText) ...[
          SizedBox(width: size * 0.2),
          Text(
            'Tasky',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: textColor ?? colorScheme.onSurface,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Custom painter to recreate the exact logo design
class TaskyLogoPainter extends CustomPainter {
  final double size;

  TaskyLogoPainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF8B5FBF), // Purple
          Color(0xFFFF6B9D), // Pink
        ],
      ).createShader(Rect.fromLTWH(0, 0, size, size));

    final path = Path();
    
    // Scale factor for the logo within the container
    final scale = size * 0.7;
    final offsetX = size * 0.15;
    final offsetY = size * 0.15;
    
    // Create the checkmark/arrow path based on the logo design
    // Starting from the left part (checkmark base)
    path.moveTo(offsetX + scale * 0.15, offsetY + scale * 0.5);
    path.lineTo(offsetX + scale * 0.4, offsetY + scale * 0.75);
    path.lineTo(offsetX + scale * 0.45, offsetY + scale * 0.7);
    path.lineTo(offsetX + scale * 0.25, offsetY + scale * 0.5);
    path.lineTo(offsetX + scale * 0.45, offsetY + scale * 0.3);
    
    // Arrow part extending to the right
    path.lineTo(offsetX + scale * 0.75, offsetY + scale * 0.3);
    path.lineTo(offsetX + scale * 0.7, offsetY + scale * 0.25);
    path.lineTo(offsetX + scale * 0.85, offsetY + scale * 0.4);
    path.lineTo(offsetX + scale * 0.9, offsetY + scale * 0.35);
    path.lineTo(offsetX + scale * 0.85, offsetY + scale * 0.3);
    path.lineTo(offsetX + scale * 0.9, offsetY + scale * 0.25);
    path.lineTo(offsetX + scale * 0.85, offsetY + scale * 0.2);
    path.lineTo(offsetX + scale * 0.75, offsetY + scale * 0.3);
    
    // Complete the arrow head
    path.lineTo(offsetX + scale * 0.8, offsetY + scale * 0.35);
    path.lineTo(offsetX + scale * 0.75, offsetY + scale * 0.4);
    path.lineTo(offsetX + scale * 0.5, offsetY + scale * 0.4);
    path.lineTo(offsetX + scale * 0.4, offsetY + scale * 0.5);
    
    // Back to start
    path.close();

    canvas.drawPath(path, paint);
    
    // Add a more accurate recreation of the logo
    _drawAccurateTaskyLogo(canvas, paint, offsetX, offsetY, scale);
  }
  
  void _drawAccurateTaskyLogo(Canvas canvas, Paint paint, double offsetX, double offsetY, double scale) {
    final path = Path();
    
    // Recreate the exact checkmark + arrow design
    // Left checkmark part
    path.moveTo(offsetX + scale * 0.2, offsetY + scale * 0.55);
    path.lineTo(offsetX + scale * 0.35, offsetY + scale * 0.7);
    path.lineTo(offsetX + scale * 0.45, offsetY + scale * 0.6);
    path.lineTo(offsetX + scale * 0.4, offsetY + scale * 0.55);
    path.lineTo(offsetX + scale * 0.35, offsetY + scale * 0.6);
    path.lineTo(offsetX + scale * 0.25, offsetY + scale * 0.5);
    path.close();
    
    // Right arrow part
    final arrowPath = Path();
    arrowPath.moveTo(offsetX + scale * 0.45, offsetY + scale * 0.4);
    arrowPath.lineTo(offsetX + scale * 0.7, offsetY + scale * 0.4);
    arrowPath.lineTo(offsetX + scale * 0.65, offsetY + scale * 0.35);
    arrowPath.lineTo(offsetX + scale * 0.8, offsetY + scale * 0.5);
    arrowPath.lineTo(offsetX + scale * 0.65, offsetY + scale * 0.65);
    arrowPath.lineTo(offsetX + scale * 0.7, offsetY + scale * 0.6);
    arrowPath.lineTo(offsetX + scale * 0.45, offsetY + scale * 0.6);
    arrowPath.close();
    
    canvas.drawPath(path, paint);
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// SVG Logo Widget - Use this when you have the SVG file
class SvgTaskyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const SvgTaskyLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SVG Logo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5FBF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.22),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        if (showText) ...[
          SizedBox(width: size * 0.2),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF8B5FBF), // Purple
                Color(0xFFFF6B9D), // Pink
              ],
            ).createShader(bounds),
            child: Text(
              'Tasky',
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Alternative logo with the exact design
class TaskyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const TaskyLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Recreate the exact logo from the image
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5FBF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5FBF), // Purple
                  Color(0xFFFF6B9D), // Pink
                ],
              ).createShader(bounds),
              child: Icon(
                Icons.trending_up_rounded,
                size: size * 0.6,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        if (showText) ...[
          SizedBox(width: size * 0.2),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF8B5FBF), // Purple
                Color(0xFFFF6B9D), // Pink
              ],
            ).createShader(bounds),
            child: Text(
              'Tasky',
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Smart Logo Widget - Uses SVG if available, falls back to custom design
class SmartTaskyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const SmartTaskyLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SvgTaskyLogo(
      size: size,
      showText: showText,
      textColor: textColor,
    );
  }
}
class ExactTaskyLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF8B5FBF), // Purple
          Color(0xFFFF6B9D), // Pink
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    
    // Recreate the exact checkmark + arrow design from the logo
    final w = size.width;
    final h = size.height;
    
    // Left checkmark part
    path.moveTo(w * 0.15, h * 0.55);
    path.lineTo(w * 0.35, h * 0.75);
    path.lineTo(w * 0.45, h * 0.65);
    path.lineTo(w * 0.4, h * 0.6);
    path.lineTo(w * 0.35, h * 0.65);
    path.lineTo(w * 0.2, h * 0.5);
    path.lineTo(w * 0.15, h * 0.55);
    
    // Arrow shaft
    path.moveTo(w * 0.4, h * 0.45);
    path.lineTo(w * 0.65, h * 0.45);
    path.lineTo(w * 0.65, h * 0.55);
    path.lineTo(w * 0.4, h * 0.55);
    path.close();
    
    // Arrow head
    path.moveTo(w * 0.65, h * 0.35);
    path.lineTo(w * 0.85, h * 0.5);
    path.lineTo(w * 0.65, h * 0.65);
    path.lineTo(w * 0.7, h * 0.6);
    path.lineTo(w * 0.75, h * 0.5);
    path.lineTo(w * 0.7, h * 0.4);
    path.close();

    canvas.drawPath(path, paint);
    
    // Draw the complete integrated shape
    final completePath = Path();
    
    // Start from bottom left of checkmark
    completePath.moveTo(w * 0.15, h * 0.6);
    // Checkmark bottom
    completePath.lineTo(w * 0.35, h * 0.8);
    completePath.lineTo(w * 0.4, h * 0.75);
    // Checkmark top part connecting to arrow
    completePath.lineTo(w * 0.65, h * 0.5);
    // Arrow head top
    completePath.lineTo(w * 0.75, h * 0.4);
    completePath.lineTo(w * 0.85, h * 0.5);
    // Arrow head bottom
    completePath.lineTo(w * 0.75, h * 0.6);
    completePath.lineTo(w * 0.65, h * 0.5);
    // Back to checkmark
    completePath.lineTo(w * 0.35, h * 0.65);
    completePath.lineTo(w * 0.2, h * 0.5);
    completePath.close();

    canvas.drawPath(completePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}