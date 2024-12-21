import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Notepage extends StatefulWidget{
  const Notepage({super.key});
  @override
  State<Notepage> createState()=> _notepageState();
}

class _notepageState extends State<Notepage>{

  TextEditingController titleContoller=TextEditingController();
  TextEditingController categoryContoller=TextEditingController();
  TextEditingController descriptionContoller=TextEditingController();
  TextEditingController dateContoller=TextEditingController();

  List<Map<String,String>> notes=[];
  late Box box;

  void initState(){
    super.initState();
    box=Hive.box("mybox");
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: notes.length), itemBuilder: (context,index){
        return GridTile(
          child: Column());
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
        showModalBottomSheet(context: context, builder: (BuildContext context){
          return Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
            height: 400,
            width: 500,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color.fromARGB(255, 255, 255, 255)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: titleContoller,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),labelText: "Title",labelStyle: TextStyle(color: Colors.amber,fontSize: 20)),),
                TextField(
                  controller: categoryContoller,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),labelText: "Category",labelStyle: TextStyle(color: Colors.amber,fontSize: 20)),),
                TextField(
                  controller: descriptionContoller,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),labelText: "Description",labelStyle: TextStyle(color: Colors.amber,fontSize: 20)),),
                TextField(
                  controller: dateContoller,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),labelText: "Date",labelStyle: TextStyle(color: Colors.amber,fontSize: 20)),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        backgroundColor: Colors.amber
                      ),
                      onPressed: (){
                        setState(() {
                          notes.add({
                            "title":titleContoller.text,
                            "category":categoryContoller.text,
                            "description":descriptionContoller.text,
                            "date":dateContoller.text
                            });
                            box.put("notes",notes);
                        });
                        titleContoller.clear();
                        categoryContoller.clear();
                        descriptionContoller.clear();
                        dateContoller.clear();

                        Navigator.pop(context);
                      }, child: Text("Add",style: TextStyle(fontSize: 20,color: Colors.white),)),

                    SizedBox(width: 15,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        backgroundColor: Colors.amber
                      ),
                      onPressed: (){}, child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.white),)),
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Text("+",style: TextStyle(fontSize: 35,color: Colors.white),),),
    );
  }
}