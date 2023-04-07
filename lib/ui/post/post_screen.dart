import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_learning/ui/auth/login_screen.dart';
import 'package:firebase_learning/ui/post/add_post.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final refe = FirebaseDatabase.instance.ref('My post');
  final search=TextEditingController();
  final editingcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text('Post'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utlis().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(
          Icons.add_circle_outline_outlined,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
                hintText: 'Search'

              ),
              onChanged: (String value){
                setState(() {

                });
              },

            ),
          ),

          Expanded(
            child: FirebaseAnimatedList(
                query: refe,
                itemBuilder: (context, snapshot, animation, index) {
                  final title= snapshot.child('title').value.toString();
                  final id=snapshot.child('id').value.toString();
                  if(search.text.isEmpty){
                    return Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: ListTile(
                          title: Text(
                            snapshot.child('id').value.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            snapshot.child('title').value.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context)=>[
                              PopupMenuItem(
                                  child: ListTile(
                                    onTap:(){
                                      Navigator.pop(context);
                                      showMyDialog(title,id);
                                    },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )),
                              PopupMenuItem(
                                onTap:(){
                                  //Navigator.pop(context);
                                  refe.child(id).remove();
                                },
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('delete'),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }else if(title.toLowerCase().contains(search.text.toLowerCase())){
                    return ListTile(
                      title: Text(
                        snapshot.child('id').value.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        snapshot.child('title').value.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }else{
                    return Container();
                  }

                }),
          )
        ],
      ),
    );
  }
  Future<void> showMyDialog(String title,String id)async{
    editingcontroller.text=title;
    return showDialog(context: context,
        builder: (BuildContext){
      return AlertDialog(
        title: Text('update'),
        content: Container(
          child: TextField(
            controller: editingcontroller,
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancle')),
          TextButton(onPressed: (){
            Navigator.pop(context);
            refe.child(id).update({
              'title':editingcontroller.text.toLowerCase()
            }).then((value) {
              Utlis().toastMessage('updated');
            }).onError((error, stackTrace) {
              Utlis().toastMessage(error.toString());
            });
          }, child: Text('Update'))
        ],
      );
        }
    );
  }
}
// Expanded(child: StreamBuilder(
// stream: refe.onValue,
// builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
// if(!snapshot.hasData){
// return CircularProgressIndicator();
// }else{
// Map<dynamic, dynamic>map=snapshot.data!.snapshot.value as dynamic;
// List<dynamic>list=[];
// list.clear();
// list=map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
//
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// });
// }
// },
// )),
