import 'dart:math';

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
    openbox();
  }

  openbox()async{
    box=await Hive.openBox("mybox");
    loadTodoItems();
  }

    void loadTodoItems(){
    List<Map<String,String>>? task=box.get("notes")?.cast<String>();
    print("tasks loaded:$task");
    setState(() {
      notes=task!;
    });
    }

    void edit(int index){
      titleContoller.text=notes[index]["title"]??"";
      categoryContoller.text=notes[index]["category"]??"";
      descriptionContoller.text=notes[index]["description"]??"";
      dateContoller.text=notes[index]["date"]??"";

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
                        backgroundColor: Colors.amber,
                      ),
                      onPressed: (){
                        setState(() {
                          notes[index]=({
                            "title":titleContoller.text,
                            "category":categoryContoller.text,
                            "description":descriptionContoller.text,
                            "date":dateContoller.text
                            });
                            box.put("notes", notes.map((e)=>Map<String,dynamic>.from(e)).toList());
                        });
                        titleContoller.clear();
                        categoryContoller.clear();
                        descriptionContoller.clear();
                        dateContoller.clear();

                        Navigator.pop(context);
                      }, child: Text("Save",style: TextStyle(fontSize: 20,color: Colors.white),)),

                    SizedBox(width: 15,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        backgroundColor: Colors.amber
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.white),)),
                  ],
                )
              ],
            ),
          );
        });
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.8,crossAxisSpacing: 10,mainAxisSpacing: 10),itemCount: notes.length, itemBuilder: (context,index){
          return GridTile(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color.fromARGB(155, 255, 246, 164),),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(child: Text("${notes[index]["title"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.amber),)),
                    SizedBox(width: 20,),
                    IconButton(onPressed: (){
                      edit(index);
                    }, icon: Icon(Icons.edit,color: Colors.amber,))
                  ],
                ),
                Text("${notes[index]["category"]}",style: TextStyle(fontSize: 18,color: Colors.grey),),
                Text("${notes[index]["description"]}",style: TextStyle(fontSize: 15,color: Colors.grey),),
                
                SizedBox(height: 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${notes[index]["date"]}",style: TextStyle(fontSize: 17,color: Colors.black),),
                    IconButton(onPressed: (){
                      setState(() {
                        notes.removeAt(index);
                        box.put("notes", notes.map((e)=>Map<String,dynamic>.from(e)).toList());
                      });
                    }, icon: Icon(Icons.delete),iconSize: 30,color: Colors.amber,)
                  ],
                )
                ],
            )));
        }),
      ),
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
                        backgroundColor: Colors.amber,
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
                      onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.white),)),
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