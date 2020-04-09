import 'package:flutter/material.dart';
import './exhibit_details.dart';
import './exhibit_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museum',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('NFC MUSEUM'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ExhibitManager(
            [
              {
                "id": "0A:FA:86:A4",
                "title": "Богд Хааны Алтан Гутал",
                "description":
                    "Хааны эдэлж хэрэглэж байсан алтадсан савхин гадартай, ширэн ултай энэ гутал нь Монголчуудын дунд Богд хааны алтан гутал хэмээн нэрлэгддэг. \n Эл гутал нь 43,5 см өндөр, 35 см урт.",
                "image": "assets/exhibit/golden_boots.jpg",
              },
              {
                "id": "A5:12:CA:95",
                "title": "Богд Хааны Улаан Ордон",
                "description":
                    "Олноо өргөгдсөний 2 дугаар оноос хүрээний зураачид Богд хааны зарлигаар Их хүрээний сав газар, түүний ойр орчим байгаа тэр үеийн нийгэм, амьдралын олон талын үйл явдлуудыг тусгаж харуулсан олон сайхацуврал зургуудыг том жижиг хэмжээгээр зурж байсан.",
                "image": "assets/exhibit/red_palace.jpeg",
              },
              {
                "id": "5F:E5:48:ED:1A:FD:60",
                "title": "Халх Хаалга",
                "description":
                "Халх хаалга /Ямпай/ -ыг хааны зарлигаар байгуулагдсан сүм болон ордны өмнө талд хамгаалалт хаалт болгон барьдаг. Энэ нь тухайн сүм, ордны эзний сүр хүчийг зэрэг дэвийн илэрхийлэл гэж ойлгож болно. Аливаа муу бүхнийг өөртөө шингээн авч байдаг гэж үздэг бөгөөд сүүдэрт нь дайруулан явахыг цээрлэнэ. Хаалгыг Хөх тоосгоор босгож, хос луу ороолдон, уул сүндэрлэж, ус урссан дүрс, хээ угалз зэргийг ингэмэл барималаар урласан. Энэ нь нүдэнд үл үзэгдэх хийгээд үзэгдэх ад зэтгэр, өвчин жижиг тэргүүтэн элдэв аюулаас эгнэгт халхлан хамгаалах бэлгэдэлтэй юм.",
                "image": "assets/exhibit/khalkh_gate.jpg",
              },
            ],
          ),
        ),
      ),
    );
  }
}
