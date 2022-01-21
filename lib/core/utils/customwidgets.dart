import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttext;
  final IconData? icon;
  final VoidCallback? callback;
  final String errormessage;
  final bool isphone;
  final bool enabled;
  const CustomTextField({Key? key,this.enabled=true,this.controller,this.hinttext="",this.icon,this.callback,this.errormessage="",this.isphone=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: isphone?TextInputType.phone:TextInputType.name,
      maxLength: isphone?10:100,
      inputFormatters: [
        isphone?FilteringTextInputFormatter.digitsOnly:FilteringTextInputFormatter.allow("")
      ],
      validator: (text){
        if(text!.isEmpty){
          return errormessage;
        }
        else{
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hinttext,
        
        suffixIcon: Visibility(
          visible: icon!=null,
          child: IconButton(
            icon: Icon(icon),
            onPressed: callback,
          ),
        ),
        hintStyle:const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey)
      ),
    );
  }
}