import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main()=>runApp(const TastyBitesApp());

class TastyBitesApp extends StatelessWidget{
 const TastyBitesApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(
  debugShowCheckedModeBanner:false,title:'Tasty Bites',
  theme:ThemeData(brightness:Brightness.dark,scaffoldBackgroundColor:const Color(0xFF080807),textTheme:GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFFFFB347),brightness:Brightness.dark)),
  home:const HomePage());
}

class Food{
 final String name,category,emoji,description;final int price;
 const Food(this.name,this.category,this.emoji,this.description,this.price);
}
const foods=<Food>[
 Food('Truffle Burger','Burgers','🍔','Smoked cheddar, truffle aioli and crispy onions.',249),
 Food('Firewood Pizza','Pizza','🍕','Charred crust, mozzarella, basil and roasted tomato.',329),
 Food('Creamy Alfredo','Pasta','🍝','Silky parmesan cream, herbs and roasted garlic.',279),
 Food('Garden Bowl','Healthy','🥗','Avocado, greens, roasted vegetables and seeds.',219),
 Food('Chocolate Cloud','Desserts','🍫','Warm chocolate, vanilla cream and crunchy cocoa.',189),
 Food('Berry Fizz','Drinks','🥤','Fresh berries, citrus and sparkling water.',149),
];

class HomePage extends StatefulWidget{const HomePage({super.key});@override State<HomePage> createState()=>_HomePageState();}
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
 final scroll=ScrollController();
 final keys={for(final x in ['Home','Menu','Offers','About','Reviews','Contact'])x:GlobalKey()};
 late final AnimationController float;
 String category='All';bool top=false;
 @override void initState(){super.initState();float=AnimationController(vsync:this,duration:const Duration(seconds:3))..repeat(reverse:true);scroll.addListener((){final v=scroll.offset>500;if(v!=top)setState(()=>top=v);});}
 @override void dispose(){float.dispose();scroll.dispose();super.dispose();}
 void go(String name){final c=keys[name]?.currentContext;if(c!=null)Scrollable.ensureVisible(c,duration:const Duration(milliseconds:700),curve:Curves.easeInOutCubic);}
 @override Widget build(BuildContext context)=>Scaffold(body:Stack(children:[
  CustomScrollView(controller:scroll,slivers:[
   SliverToBoxAdapter(child:nav()),
   SliverToBoxAdapter(key:keys['Home'],child:hero()),
   SliverToBoxAdapter(key:keys['Menu'],child:menu()),
   SliverToBoxAdapter(key:keys['Offers'],child:offers()),
   SliverToBoxAdapter(key:keys['About'],child:about()),
   SliverToBoxAdapter(key:keys['Reviews'],child:reviews()),
   SliverToBoxAdapter(key:keys['Contact'],child:contact()),
   SliverToBoxAdapter(child:footer())]),
  if(top)Positioned(right:24,bottom:24,child:FloatingActionButton(backgroundColor:const Color(0xFFFFB347),foregroundColor:Colors.black,onPressed:()=>scroll.animateTo(0,duration:const Duration(milliseconds:700),curve:Curves.easeOut),child:const Icon(Icons.keyboard_arrow_up_rounded)))
 ]));
 Widget nav()=>LayoutBuilder(builder:(context,c){final mobile=c.maxWidth<820;return Container(padding:EdgeInsets.symmetric(horizontal:mobile?18:55,vertical:18),decoration:BoxDecoration(color:const Color(0xEE080807),border:Border(bottom:BorderSide(color:Colors.white.withOpacity(.07)))),child:Row(children:[
  const Icon(Icons.restaurant_rounded,color:Color(0xFFFFB347),size:30),const SizedBox(width:10),
  const Text('TASTY',style:TextStyle(fontSize:21,fontWeight:FontWeight.w800)),const Text(' BITES',style:TextStyle(fontSize:21,fontWeight:FontWeight.w300,color:Color(0xFFFFB347))),const Spacer(),
  if(!mobile)Row(children:keys.keys.map((x)=>TextButton(onPressed:()=>go(x),child:Text(x))).toList())
  else IconButton(onPressed:()=>showModalBottomSheet(context:context,backgroundColor:const Color(0xFF12110E),builder:(_)=>Column(mainAxisSize:MainAxisSize.min,children:keys.keys.map((x)=>ListTile(title:Text(x),onTap:(){Navigator.pop(context);go(x);})).toList())),icon:const Icon(Icons.menu_rounded)),
  const SizedBox(width:8),FilledButton(style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFFB347),foregroundColor:Colors.black),onPressed:()=>go('Contact'),child:const Text('Book a Table'))
 ]));});
 Widget hero()=>LayoutBuilder(builder:(context,c){final mobile=c.maxWidth<850;return Container(padding:EdgeInsets.symmetric(horizontal:mobile?24:70,vertical:80),constraints:const BoxConstraints(minHeight:680),decoration:const BoxDecoration(gradient:RadialGradient(center:Alignment(0.7,-0.2),radius:1.2,colors:[Color(0xFF332612),Color(0xFF080807)])),child:mobile?Column(crossAxisAlignment:CrossAxisAlignment.start,children:[heroText(),const SizedBox(height:35),foodHero()]):Row(children:[Expanded(child:heroText()),Expanded(child:foodHero())]));});
 Widget heroText()=>Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children:[
  const Text('PREMIUM RESTAURANT',style:TextStyle(color:Color(0xFFFFB347),letterSpacing:2.4,fontSize:12,fontWeight:FontWeight.w800)),
  const SizedBox(height:16),const Text('Taste the\nextraordinary.',style:TextStyle(fontSize:64,fontWeight:FontWeight.w900,height:1.02)),
  const SizedBox(height:20),const Text('Bold flavours. Beautiful plates. A warm place for unforgettable evenings.',style:TextStyle(color:Colors.white60,fontSize:17,height:1.7)),
  const SizedBox(height:28),Wrap(spacing:12,runSpacing:12,children:[
   FilledButton(style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFFB347),foregroundColor:Colors.black,padding:const EdgeInsets.symmetric(horizontal:22,vertical:16)),onPressed:()=>go('Menu'),child:const Text('Explore Menu')),
   OutlinedButton(onPressed:()=>go('Contact'),child:const Text('Reserve a Table'))]),
  const SizedBox(height:45),const Row(children:[_Stat('12+','signature dishes'),SizedBox(width:38),_Stat('4.9','guest rating'),SizedBox(width:38),_Stat('7 days','open weekly')])
 ]);
 Widget foodHero()=>AnimatedBuilder(
  animation:float,
  builder:(context,_){
   final y=lerpDouble(-12,12,float.value)!;
   return Transform.translate(
    offset:Offset(0,y),
    child:Center(
     child:Stack(
      alignment:Alignment.center,
      children:[
       Container(width:330,height:330,decoration:BoxDecoration(shape:BoxShape.circle,color:const Color(0xFFFFB347).withOpacity(.09),boxShadow:[BoxShadow(color:const Color(0xFFFFB347).withOpacity(.14),blurRadius:80,spreadRadius:15)])),
       const Text('🍔',style:TextStyle(fontSize:190)),
       Positioned(right:8,top:35,child:glass('CHEF’S\\nCHOICE')),
       Positioned(left:8,bottom:35,child:glass('FRESH\\nDAILY')),
      ],
     ),
    ),
   );
  },
 );
 Widget glass(String s)=>ClipRRect(borderRadius:BorderRadius.circular(18),child:BackdropFilter(filter:ImageFilter.blur(sigmaX:12,sigmaY:12),child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white.withOpacity(.08),border:Border.all(color:Colors.white.withOpacity(.12)),borderRadius:BorderRadius.circular(18)),child:Text(s,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w800,height:1.2)))));
 Widget menu(){final cats=['All','Burgers','Pizza','Pasta','Healthy','Desserts','Drinks'];final shown=category=='All'?foods:foods.where((f)=>f.category==category).toList();return section('SIGNATURE MENU','Made for cravings.','Handcrafted favourites with a modern Tasty Bites touch.',Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Wrap(spacing:8,runSpacing:8,children:cats.map((x)=>ChoiceChip(label:Text(x),selected:category==x,onSelected:(_)=>setState(()=>category=x))).toList()),const SizedBox(height:28),
  LayoutBuilder(builder:(context,c){final n=c.maxWidth>1000?3:c.maxWidth>650?2:1;return GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:shown.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:n,crossAxisSpacing:18,mainAxisSpacing:18,childAspectRatio:1.08),itemBuilder:(_,i)=>foodCard(shown[i]));})
 ]));}
 Widget foodCard(Food f)=>Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:const Color(0xFF11110F),borderRadius:BorderRadius.circular(26),border:Border.all(color:Colors.white.withOpacity(.07))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Row(children:[Text(f.emoji,style:const TextStyle(fontSize:52)),const Spacer(),Text('₹'+f.price.toString(),style:const TextStyle(color:Color(0xFFFFB347),fontSize:18,fontWeight:FontWeight.w800))]),
  const Spacer(),Text(f.name,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),const SizedBox(height:7),Text(f.description,style:const TextStyle(color:Colors.white54,height:1.5)),
  const SizedBox(height:16),Row(children:[Text(f.category,style:const TextStyle(color:Colors.white38,fontSize:12)),const Spacer(),const Icon(Icons.arrow_forward_rounded,color:Color(0xFFFFB347))])
 ]));
 Widget offers()=>section('WEEKEND FEAST','A little extra makes it special.','Bring your favourite people and turn dinner into a memory.',Container(padding:const EdgeInsets.all(30),decoration:BoxDecoration(borderRadius:BorderRadius.circular(30),gradient:const LinearGradient(colors:[Color(0xFF332512),Color(0xFF17130D)]),border:Border.all(color:Colors.white.withOpacity(.08))),child:LayoutBuilder(builder:(context,c){final mobile=c.maxWidth<700;final content=Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  const Text('15% OFF',style:TextStyle(fontSize:42,fontWeight:FontWeight.w900,color:Color(0xFFFFB347))),const SizedBox(height:8),const Text('on weekend family tables',style:TextStyle(fontSize:23,fontWeight:FontWeight.w700)),const SizedBox(height:8),const Text('Valid Friday–Sunday. Dine in and enjoy the moment.',style:TextStyle(color:Colors.white54)),const SizedBox(height:20),
  FilledButton(style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFFB347),foregroundColor:Colors.black),onPressed:()=>go('Contact'),child:const Text('Reserve now'))]);return mobile?content:Row(children:[Expanded(child:content),const Text('🍕',style:TextStyle(fontSize:130))]);})));
 Widget about()=>section('OUR STORY','Food should feel like a memory.','We combine familiar comfort food with modern presentation, seasonal ingredients and a lot of curiosity.',LayoutBuilder(builder:(context,c){final mobile=c.maxWidth<800;final left=Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('From a tiny kitchen to a table full of stories.',style:TextStyle(fontSize:27,fontWeight:FontWeight.w700)),const SizedBox(height:15),const Text('Every plate is designed to make you pause, smile and take one more bite.',style:TextStyle(color:Colors.white60,height:1.8))]);final right=Container(height:280,decoration:BoxDecoration(borderRadius:BorderRadius.circular(30),gradient:const RadialGradient(colors:[Color(0xFF40301B),Color(0xFF17130D)])),child:const Center(child:Text('👨‍🍳',style:TextStyle(fontSize:130))));return mobile?Column(children:[left,const SizedBox(height:25),right]):Row(children:[Expanded(child:left),const SizedBox(width:45),Expanded(child:right)]);}));
 Widget reviews()=>section('GUEST NOTES','Loved by our guests.','A few words from people who came hungry and left smiling.',LayoutBuilder(builder:(context,c){final cols=c.maxWidth>850?3:1;const data=[['Beautiful atmosphere and seriously good food.','Ananya R.'],['The burger was incredible. Presentation was next level.','Rahul K.'],['Perfect place for a relaxed dinner with friends.','Meera S.']];return GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:data.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:cols,crossAxisSpacing:18,mainAxisSpacing:18,childAspectRatio:1.5),itemBuilder:(_,i)=>Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(color:const Color(0xFF11110F),borderRadius:BorderRadius.circular(25),border:Border.all(color:Colors.white.withOpacity(.07))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  const Text('★★★★★',style:TextStyle(color:Color(0xFFFFB347),letterSpacing:2)),const Spacer(),Text('“'+data[i][0]+'”',style:const TextStyle(fontSize:17,height:1.4)),const SizedBox(height:14),Text('— '+data[i][1],style:const TextStyle(color:Colors.white54))
 ])));}));
 Widget contact()=>section('CONTACT','Let’s make dinner memorable.','Book a table, ask a question or just say hello.',LayoutBuilder(builder:(context,c){final mobile=c.maxWidth<800;final info=Container(padding:const EdgeInsets.all(28),decoration:BoxDecoration(color:const Color(0xFF11110F),borderRadius:BorderRadius.circular(28),border:Border.all(color:Colors.white.withOpacity(.07))),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  _Info(Icons.location_on_rounded,'Visit','12 Food Street, Hyderabad'),SizedBox(height:22),_Info(Icons.access_time_rounded,'Opening hours','Mon–Sun · 11:00 AM – 11:00 PM'),SizedBox(height:22),_Info(Icons.phone_rounded,'Call','+91 98765 43210')
 ]));final form=Column(children:[field('Your name'),const SizedBox(height:12),field('Email address'),const SizedBox(height:12),field('Message',lines:4),const SizedBox(height:14),SizedBox(width:double.infinity,child:FilledButton(style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFFB347),foregroundColor:Colors.black,padding:const EdgeInsets.symmetric(vertical:17)),onPressed:(){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Thanks! We will contact you shortly.')));},child:const Text('Send Message')))]);return mobile?Column(children:[info,const SizedBox(height:20),form]):Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:info),const SizedBox(width:20),Expanded(child:form)]);}));
 Widget field(String hint,{int lines=1})=>TextField(maxLines:lines,decoration:InputDecoration(hintText:hint,filled:true,fillColor:const Color(0xFF11110F),border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide(color:Colors.white.withOpacity(.07))),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide(color:Colors.white.withOpacity(.07)))));
 Widget section(String eyebrow,String title,String subtitle,Widget child)=>Container(padding:const EdgeInsets.symmetric(horizontal:24,vertical:85),child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:1180),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Text(eyebrow,style:const TextStyle(color:Color(0xFFFFB347),letterSpacing:2,fontSize:11,fontWeight:FontWeight.w800)),const SizedBox(height:10),
  Text(title,style:const TextStyle(fontSize:40,fontWeight:FontWeight.w800,height:1.1)),const SizedBox(height:10),
  ConstrainedBox(constraints:const BoxConstraints(maxWidth:650),child:Text(subtitle,style:const TextStyle(color:Colors.white54,height:1.7))),const SizedBox(height:36),child
 ]))));
 Widget footer()=>Container(padding:const EdgeInsets.all(30),decoration:const BoxDecoration(border:Border(top:BorderSide(color:Colors.white12))),child:const Center(child:Text('© 2026 Tasty Bites · Crafted with passion.',style:TextStyle(color:Colors.white38))));
}
class _Stat extends StatelessWidget{final String a,b;const _Stat(this.a,this.b);@override Widget build(BuildContext c)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(a,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),Text(b,style:const TextStyle(color:Colors.white38,fontSize:11))]);}
class _Info extends StatelessWidget{final IconData icon;final String title,text;const _Info(this.icon,this.title,this.text);@override Widget build(BuildContext c)=>Row(children:[Icon(icon,color:const Color(0xFFFFB347)),const SizedBox(width:14),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w700)),Text(text,style:const TextStyle(color:Colors.white54))])]);}
