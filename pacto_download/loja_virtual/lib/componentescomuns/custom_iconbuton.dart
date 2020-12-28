import 'package:flutter/material.dart';

class CustomIconButton  extends StatelessWidget {

  const CustomIconButton({this.iconData, this.color, this.onTap,this.size});

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double size;
  @override
  Widget build(BuildContext context) {

    //DEIXA A ANIMAÇÃO REDONDA
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        
       color: Colors.transparent,
        //INKWELL FAZ UMA ANIMAÇÃO QUANDO CLICA NO BOTÃO
        child: InkWell(

          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              iconData,
              color: onTap!= null ?color : Colors.grey[400],
              size: size ?? 24,

            ),
          ),
        ),
      ),
    );
  }
}
