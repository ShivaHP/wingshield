import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttext;
  final IconData? icon;
  final String errormessage;
  final bool isphone;
  final bool enabled;
  const CustomTextField({Key? key,this.enabled=true,this.controller,this.hinttext="",this.icon,this.errormessage="",this.isphone=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: isphone?TextInputType.phone:TextInputType.name,
      maxLength: isphone?10:100,
      inputFormatters: [
        isphone?FilteringTextInputFormatter.digitsOnly:FilteringTextInputFormatter.deny("")
      ],
      validator: (text){
        if(text!.isEmpty){
          return errormessage;
        }
        else if(isphone&&text.length<10){
          return errormessage;
        }
        else{
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hinttext,
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

        ),
        suffixIcon: Visibility(
          visible: icon!=null,
          child: IconButton(
            icon: Icon(icon,color: Colors.yellow,),
           onPressed: (){},
          ),
        ),
        hintStyle:const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey)
      ),
    );
  }
}


