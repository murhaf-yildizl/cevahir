import 'dart:convert';
import 'package:cevahir/view/warehouse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/main.dart';
import 'package:cevahir/models/image.dart';
import 'package:cevahir/controller/image_controller.dart';
import 'package:cevahir/view/add_image.dart';
import 'package:cevahir/view/add_order.dart';
import 'package:cevahir/view/all_customers.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:cevahir/view/all_orders.dart';
import 'package:cevahir/view/all_recipts.dart';
import 'package:cevahir/view/loadmore.dart';
import 'package:cevahir/view/setting_interface.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:cevahir/view/warehouse.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'dart:async';
import 'add_customer.dart';
import 'add_model.dart';

import 'add_recipt.dart';
import 'create_drawer.dart';
import 'image_zoom.dart';

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()=>_HomePageState();
}

class _HomePageState extends State{

  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  List<ImageDetails> images=List<ImageDetails>();
  int currentPage=0;
  PageController pageController=PageController(initialPage:0);
   static bool increment=true;
   ScrollController scrollController=ScrollController();
   Timer _timer;
   double height,width;

  @override
  void initState() {

     if(images.isEmpty)
       getImageList().then((value){
      if(images.length>1)
      {
        SystemChannels.textInput.invokeMethod("TextInput.hide");
        _timer=timer();
      }});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer!=null)
       if(_timer.isActive)
         _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height/1.2;
    width=MediaQuery.of(context).size.width;

     return Scaffold(
       appBar:AppBar(
         toolbarHeight:70 ,
         backgroundColor:Colors.indigo.withOpacity(0.9),
         title:Center(child: Text_Style("cevahir style".toUpperCase(),22,Colors.white,"rtl")) ,

       ) ,
       drawer:Theme(
           data: Theme.of(context).copyWith(
               canvasColor: Colors.lightBlue.shade100,

           ) ,

           child:CreateDrawer(["الزبائن","الموديلات","المستودع","الطلبيات","الفواتير","إعدادات التطبيق","إنهاء التطبيق"],[Zoom(),AllModels(),WarehouseWidget(),AllOrders(),AllRecipts(),SettingInterface(),"exit"])
          ) ,
       body: Center(
         child: Container(
           padding: EdgeInsets.only(top:20),
               child: images.length>0?PageView.builder(
                           controller: pageController,
                           itemBuilder: (context,index){

                             return Stack(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [

                             SingleChildScrollView(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                  InkWell(

                                    child:  Container(
                             padding:EdgeInsets.all(10) ,
                             height:height,
                             width: width,
                             child:Image.memory(base64Decode(images[index].url),fit: BoxFit.fill),
                             ),
                                    onLongPress:(){
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){
                                        return AddImage(0,"setting");
                                      }));
                                    } ,
                                  ),
                                  SizedBox(height: 10,),
                                  _pageindicator(images.length),
                                 SizedBox(height: 10,),
                                  Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:[

                                       Text_Style("${images[index].title}",18,Colors.black,"rtl"),
                                           ]),

                               ],
                               ),
                             ),
                              ]);
                           },
                         itemCount: images.length,
                           onPageChanged: (index) {
                             pageIndexNotifier.value = index;
                           }
                       ):
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text_Style("أضف صوراً الآن", 18, Colors.black, "rtl"),
                   SizedBox(height:20),
                   FloatingActionButton(
                       child: Icon(Icons.add),
                       onPressed:(){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                           return AddImage(0,"setting");
                         }));
                       }),
                 ],
               )
           ,
               ),
       ),
 
        
     );
  }

  Future<dynamic> getImageList() async{
      await DataBaseHelper.import_from_dadabase("SELECT * FROM start_images").then((value) {
       if(value.isNotEmpty)
       setState(() {
         images=ImageController.to_image(value);
         print(value);
       });
       return value;
     });
  }

  Widget _pageindicator(int length) {
    return PageViewIndicator(

      pageIndexNotifier: pageIndexNotifier,
      length: length,

      normalBuilder: (animationController, index) => Circle(
        size: 12.0,
        color: Colors.black,
      ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
        child: Circle(
          size: 12.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Timer timer()
  {

     return  Timer.periodic(Duration(seconds:2),(Timer timer)
    {
      if(currentPage==images.length)
        currentPage=0;

         pageController.animateToPage(currentPage++, duration: Duration(milliseconds:150 ), curve: Curves.easeIn);

     });


  }
}