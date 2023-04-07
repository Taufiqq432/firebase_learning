import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}


class _AddPostState extends State<AddPost> {
  bool loading=false;
  final database=FirebaseDatabase.instance.ref('My post');
  final postcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Add your post '),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children:  [
            SizedBox(height: 50,),
            TextFormField(

              controller: postcontroller,
              maxLines: 5,
              decoration: InputDecoration(

                hintText: "what is in your in  mind",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Add',loading: loading, onTap: (){

              setState(() {
                loading=true;
              });
              String id= DateTime.now().microsecondsSinceEpoch.toString();
             database.child(id).set({
                'title':postcontroller.text.toString(),
               'id':id
              }).then((value) {
                setState(() {
                loading=false;
                });
             }).onError((error, stackTrace)  {
               Utlis().toastMessage(error.toString());

             });
            })


          ],
        ),
      ),

    );
  }
}
