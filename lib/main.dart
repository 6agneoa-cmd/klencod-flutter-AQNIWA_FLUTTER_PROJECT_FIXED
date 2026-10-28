import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const AqniwaApp());

class AqniwaApp extends StatelessWidget {
  const AqniwaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'اقنيوا AQNIWA',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffd8a64a), brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xff101820)),
    home: const EmpireScreen(),
  );
}

class EmpireScreen extends StatefulWidget { const EmpireScreen({super.key}); @override State<EmpireScreen> createState()=>_EmpireScreenState(); }
class _EmpireScreenState extends State<EmpireScreen> {
 int gold=180, wood=120, food=150, stone=80, soldiers=12, day=1, land=1, wins=0;
 final Map<String,int> buildings={'مزرعة':1,'منجم':1,'ثكنة':1,'برج دفاع':0};
 String message='مرحبًا بالقائد. جزيرتك تنتظر أن تبني إمبراطورية.';
 final Random rng=Random();
 void note(String s)=>setState(()=>message=s);
 void build(String name,int g,int w,int s){ if(gold<g||wood<w||stone<s){note('الموارد لا تكفي لبناء $name. اجمع موارد أكثر.');return;} setState((){gold-=g;wood-=w;stone-=s;buildings[name]=(buildings[name]??0)+1;message='تم بناء $name بنجاح!';}); }
 void gather(){setState((){wood+=18+rng.nextInt(12);stone+=8+rng.nextInt(12);food+=12+rng.nextInt(12);gold+=8+rng.nextInt(15);message='جمعت موارد من الجزيرة. استعد للغزاة!';});}
 void recruit(){if(gold<25||food<15){note('تحتاج 25 ذهبًا و15 طعامًا لتجنيد جندي.');return;}setState((){gold-=25;food-=15;soldiers++;message='انضم جندي جديد إلى جيشك.';});}
 void raid(){final power=soldiers+(buildings['برج دفاع']??0)*4; if(power<8){note('جيشك ضعيف. جنّد جنودًا قبل الهجوم.');return;} setState((){day++; if(power>=10+rng.nextInt(15)){final reward=35+rng.nextInt(45);gold+=reward;food+=20;land++;wins++;message='انتصار! احتللت أرضًا جديدة وربحت $reward ذهبًا.';}else{soldiers=max(1,soldiers-3);message='خسائر في المعركة! فقدت 3 جنود. قوّ جيشك وبرج دفاعك.';}});}
 void endDay(){setState((){day++;food=max(0,food-soldiers);gold+=(buildings['منجم']??0)*12;food+=(buildings['مزرعة']??0)*16;wood+=(buildings['مزرعة']??0)*3; if(food==0) message='انتهى الطعام! اجمع الموارد أو طوّر المزرعة.'; else message='بدأ اليوم $day. المزارع والمناجم أنتجت مواردها.';});}
 @override Widget build(BuildContext context){
 return Scaffold(appBar:AppBar(title:const Text('اقنيوا AQNIWA',style:TextStyle(fontWeight:FontWeight.w900)),centerTitle:true,backgroundColor:const Color(0xff17242b),actions:[IconButton(onPressed:()=>showAboutDialog(context:context,applicationName:'اقنيوا AQNIWA',children:[const Text('لعبة استراتيجية فردية تجريبية. ابنِ قاعدتك، اجمع الموارد واهزم الغزاة.')]),icon:const Icon(Icons.info_outline))]),
 body:SafeArea(child:ListView(padding:const EdgeInsets.all(14),children:[
 Container(height:190,decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xff174e52),Color(0xff1b303a),Color(0xff8a6538)],begin:Alignment.topLeft,end:Alignment.bottomRight),border:Border.all(color:const Color(0xffd8a64a),width:1.2)),child:Stack(children:[Positioned(left:16,top:14,child:Text('اليوم $day  •  الأراضي $land',style:const TextStyle(fontWeight:FontWeight.bold))),const Center(child:Icon(Icons.castle,size:78,color:Color(0xfff4d48a))),const Positioned(left:18,bottom:14,child:Text('مملكة اقنيوا',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900))),Positioned(right:15,bottom:12,child:Text('🏰 ${soldiers} جندي',style:const TextStyle(fontWeight:FontWeight.bold))) ])),
 const SizedBox(height:12),Wrap(spacing:8,runSpacing:8,children:[_resource('ذهب',gold,'🪙'),_resource('خشب',wood,'🪵'),_resource('طعام',food,'🌾'),_resource('حجر',stone,'🪨')]),
 const SizedBox(height:12),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xff1a2830),borderRadius:BorderRadius.circular(16)),child:Text(message,textAlign:TextAlign.center,style:const TextStyle(fontSize:15))),
 const SizedBox(height:18),const Text('إدارة الإمبراطورية',textAlign:TextAlign.right,style:TextStyle(fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:8),
 GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),mainAxisSpacing:9,crossAxisSpacing:9,childAspectRatio:1.35,children:[_building('🌾','مزرعة','المستوى ${buildings['مزرعة']}',()=>build('مزرعة',45,30,10)),_building('⛏️','منجم','المستوى ${buildings['منجم']}',()=>build('منجم',55,25,20)),_building('⚔️','ثكنة','المستوى ${buildings['ثكنة']}',()=>build('ثكنة',70,45,15)),_building('🛡️','برج دفاع','المستوى ${buildings['برج دفاع']}',()=>build('برج دفاع',60,25,35))]),
 const SizedBox(height:18),const Text('العمليات العسكرية والموارد',textAlign:TextAlign.right,style:TextStyle(fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:8),
 _action(Icons.forest,'جمع الموارد','خشب وحجر وطعام وذهب',gather),_action(Icons.person_add_alt_1,'تجنيد جندي','25 ذهب + 15 طعام',recruit),_action(Icons.swords,'غزو أرض جديدة','قاتل الغزاة واربح موارد وأراضي',raid),_action(Icons.nightlight_round,'إنهاء اليوم','الإنتاج واستهلاك الطعام',endDay),
 const SizedBox(height:12),Text('الانتصارات: $wins  •  الأراضي المحتلة: $land',textAlign:TextAlign.center,style:const TextStyle(color:Color(0xffe9c36a))),const SizedBox(height:10),const Text('نسخة أولية فردية تعمل دون حساب أو خدمة مدفوعة. لا تتضمن اتصالًا أونلاين حقيقيًا.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white54,fontSize:12)),
 ])),);
 }
 Widget _resource(String name,int value,String emoji)=>Container(width:(MediaQuery.of(context).size.width-44)/2,padding:const EdgeInsets.symmetric(vertical:12,horizontal:14),decoration:BoxDecoration(color:const Color(0xff1b2a32),borderRadius:BorderRadius.circular(14),border:Border.all(color:Colors.white10)),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text('$emoji $name'),Text('$value',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:17))]));
 Widget _building(String emoji,String name,String level,VoidCallback action)=>InkWell(onTap:action,borderRadius:BorderRadius.circular(15),child:Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:const Color(0xff1b2a32),borderRadius:BorderRadius.circular(15),border:Border.all(color:const Color(0xff45545b))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(emoji,style:const TextStyle(fontSize:28)),Text(name,style:const TextStyle(fontWeight:FontWeight.w900)),Text(level,style:const TextStyle(color:Colors.white60,fontSize:12)),const SizedBox(height:4),const Text('اضغط للتطوير',style:TextStyle(color:Color(0xffe9c36a),fontSize:11))]));
 Widget _action(IconData icon,String title,String sub,VoidCallback action)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Material(color:const Color(0xff1b2a32),borderRadius:BorderRadius.circular(14),child:InkWell(onTap:action,borderRadius:BorderRadius.circular(14),child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[Container(width:44,height:44,decoration:BoxDecoration(color:const Color(0xff3c3322),borderRadius:BorderRadius.circular(12)),child:Icon(icon,color:const Color(0xffe9c36a))),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w900,fontSize:16)),Text(sub,style:const TextStyle(color:Colors.white60,fontSize:12))])),const SizedBox(width:8),const Icon(Icons.chevron_right)])))));
}