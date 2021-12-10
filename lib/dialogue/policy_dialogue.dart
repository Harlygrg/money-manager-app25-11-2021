import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
class PolicyDialogue extends StatelessWidget {
   PolicyDialogue({Key? key,
    required this.mdFileName,}) :
        assert(mdFileName.contains(".md"),'the file must contain the .md extension'),super(key: key);
 final String mdFileName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
    children: [
      Expanded(
        child: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 150)).then((value){
            return rootBundle.loadString("termsAndPolicy/$mdFileName");
          }),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Markdown(data: snapshot.data.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      ElevatedButton(
        child: Text("CLOSE"),
        onPressed: (){
          Navigator.pop(context);
        },
      )
    ],
    ));
  }
}
