import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  @override

//ESTILOS DE TEXTOS PRONTOS, USADOS PRINCIPALMENTE NO CARTÃO ANIMADO DE CRÉDITO
  const CardTextField({this.title,this.bold = false,
    this.hint, this.textInputType, this.inputFormatters, this.validator,
    this.maxLenght,this.textAlign = TextAlign.start,
    this.onSubmitted, this.focusNode }): textInputAction = onSubmitted == null? TextInputAction.done
  : TextInputAction.next;



  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLenght;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;

  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      validator: validator,
      builder: (state){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              if(title!= null)
                 Row(
                   children: <Widget>[
                     Text(
                       title,
                       style:const TextStyle(
                         fontSize: 10,
                         color: Colors.white,
                         fontWeight: FontWeight.w400,
                       ),
                     ),
                     if(state.hasError)
                       const Text(
                         '   Inválido',
                         style: TextStyle(
                           color: Colors.red,
                           fontSize: 9,
                         ),
                       ),
                   ],
                 ),
                TextFormField(
                  style: TextStyle(
                    color: title == null && state.hasError ?  Colors.red
                    : Colors.white,
                    fontWeight: bold? FontWeight.bold : FontWeight.w500,
                  ),
                  cursorColor: Colors.white ,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title == null && state.hasError ?Colors.red
                      : Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    counterText: '', //NÃO CONTAR A QUANTIDADE DE CARACTERES DO CVV
                  ),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,

                  //SEMPRE QUE DIGITAR ALGO, O INITIAL VALUE VIRA O VALOR QUE COLOQUEI
                  onChanged: (text){
                    state.didChange(text);
                  },

                  maxLength: maxLenght,
                  textAlign: textAlign,
                  focusNode: focusNode,
                  onFieldSubmitted: onSubmitted,
                  textInputAction: textInputAction,

                )
              ],
            ),
          );
        },
      );
    }
  }
